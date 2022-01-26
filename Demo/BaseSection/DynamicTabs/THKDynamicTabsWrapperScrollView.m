//
//  THKDynamicTabsWrapperScrollView.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/12/21.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKDynamicTabsWrapperScrollView.h"
#import "THKDynamicTabsProtocol.h"

static void * const kTHKScrollViewContentOffsetKVOContext = (void*)&kTHKScrollViewContentOffsetKVOContext;

@interface THKDynamicTabsWrapperScrollView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>{
    __weak UIScrollView *_currentScrollView;
    BOOL _isObserving;
}

@property (nonatomic, assign, readwrite) BOOL pin;

@property (nonatomic, strong) NSMutableArray<UIScrollView *> *observedViews;

@property (nonatomic, assign) CGFloat _adjustContentOffsetIfNecessaryBefor;

@end

@implementation THKDynamicTabsWrapperScrollView
@dynamic delegate;


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.directionalLockEnabled = YES;
        self.bounces = YES;

        [self addObserver:self
               forKeyPath:NSStringFromSelector(@selector(contentOffset))
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:kTHKScrollViewContentOffsetKVOContext];
        _isObserving = YES;
    }
    return self;
}


- (void)scrollToTop:(BOOL)animated{
    self.pin = NO;
    // 外部调用置顶事件时，需要先把内部scrollView的内容也置顶，以免后续滑动监听拦截后，又把self.pin设为YES
    _currentScrollView.contentOffset = _currentScrollView.thk_topPoint;
    [self setContentOffset:self.thk_topPoint animated:animated];
}

- (void)addObserverToView:(UIScrollView *)scrollView{
    // 必须要设置不调整缩进，否则头部缩进了，下拉时会自动往下偏移
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        scrollView.tmui_viewController.automaticallyAdjustsScrollViewInsets = NO;
    }
    if ([scrollView isKindOfClass:UICollectionView.class] && scrollView.alwaysBounceVertical == NO) {
        // UICollectionView数据不足时是默认不能滑动的，这就不能实现刷新或加载更多数据的功能，需要开启。
        scrollView.alwaysBounceVertical = YES;
        
    }
    
    [scrollView addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(contentOffset))
                    options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                    context:kTHKScrollViewContentOffsetKVOContext];
}

//- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated{
//    [super setContentOffset:contentOffset animated:animated];
//}
//
//- (void)setContentOffset:(CGPoint)contentOffset{
//    [super setContentOffset:contentOffset];
//}

//- (void)_adjustContentOffsetIfNecessary{
//    self._adjustContentOffsetIfNecessaryBefor = self.contentOffset.y;
////    NSLog(@"override super _adjustContentOffsetIfNecessary before %f",self.contentOffset.y);
//    [super _adjustContentOffsetIfNecessary];
////    NSLog(@"override super _adjustContentOffsetIfNecessary after %f",self.contentOffset.y);
//    if (self._adjustContentOffsetIfNecessaryBefor != self.contentOffset.y) {
//        // 系统动态调整了offset，需要判断是不是需要改
//        if (self.disableAdjustContentOffsetIfNecessary) {
//            self.contentOffset = CGPointMake(self.contentOffset.x, self._adjustContentOffsetIfNecessaryBefor);
//        }
//    }
//}

//- (void)setBounds:(CGRect)bounds{
//    [super setBounds:bounds];
//}
//
//- (void)setFrame:(CGRect)frame{
//     [super setFrame:frame];
//}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == kTHKScrollViewContentOffsetKVOContext && [keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        
        CGPoint new = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGPoint old = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
        CGFloat diff = old.y - new.y;
        
        if (diff == 0.0 || !_isObserving) { return ;}
        
        if (object == self) {
            // 2. 滑动区域大于锁定区域
            // 3. 内部scrollview刚好在吸顶的临界情况
            self.pin = (new.y >= -_lockArea) || (old.y == -_lockArea && _currentScrollView && !_currentScrollView.thk_isAtTop);
            [self doCallBackRealChanged:diff];
        }
        
//        NSLog(@"=========== KVO event begin===========");
//        NSLog(@"ScrollView      : %@",[object class]);
//        NSLog(@"Observing       : %d",_isObserving);
//        NSLog(@"ContentOffset   : old[%.0f],new[%.0f],Offset[%.0f],Inset[%.0f]",old.y,new.y,self.contentOffset.y,self.contentInset.top);
//        NSLog(@"=========== KVO event end===========");
        
        if (_pin) {
            // 头部固定后，锁定不允许头部继续往上滑动
            if (object == self) {
                // 交互布局需要锁定wrapper位移
                if (self.layout == THKDynamicTabsLayoutType_Interaction) {
                    new = [self handleOffsetWhenInteraction:new];
                    [self scrollView:self setContentOffset:new];
                }else{
                    [self scrollView:self setContentOffset:CGPointMake(0, -_lockArea)];
                }
            }else{
//                [self scrollView:_currentScrollView setContentOffset:new];
                [self doCallBackContentChanged:object diff:diff];
            }
        }else{
            if (object == self) {
                // 交互布局需要锁定wrapper位移
                if (self.layout == THKDynamicTabsLayoutType_Interaction) {
                    new = [self handleOffsetWhenInteraction:new];
                    [self scrollView:self setContentOffset:new];
                }else if (_currentScrollView.thk_isAddRefreshControl && self.thk_isAtTop) {
                    // 当子scrollView包含下拉刷新头部组件，自身不往下滑动，（去除弹簧效果，不下拉刷新，使子VC开启下拉刷新）
                    if (new.y < -self.contentInset.top) {
                        new.y = -self.contentInset.top;
                    }
                    [self scrollView:self setContentOffset:new];
                }else{
//                    [self scrollView:self setContentOffset:new];
                }
            }else{
                if (_currentScrollView.thk_isAddRefreshControl && self.thk_isAtTop) {
                    // 当子scrollView包含下拉刷新头部组件，子scrollView可以继续往下滑动,（开始下拉刷新）
//                    [self scrollView:_currentScrollView setContentOffset:new];
                }else{
                    [self scrollView:_currentScrollView setContentOffset:_currentScrollView.thk_topPoint];
                }
                
                [self doCallBackContentChanged:object diff:diff];
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)scrollView:(UIScrollView*)scrollView setContentOffset:(CGPoint)offset {
    _isObserving = NO;
    scrollView.contentOffset = offset;
    _isObserving = YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    UIScrollView *scrollView = (UIScrollView *)otherGestureRecognizer.view;
    
    if ([self isNeedInteractiveScrollView:scrollView] == NO) {
        return NO;
    }
    
    // 交互布局，需要一起滚动，不加入监听
    if (self.layout != THKDynamicTabsLayoutType_Interaction) {
        [self addObservedView:scrollView];
        _currentScrollView = scrollView;
    }
    
    return YES;
}

- (CGPoint)handleOffsetWhenInteraction:(CGPoint)new{
    // -91-44  -44
    if (new.y < -self.contentInset.top) {
        new.y = -self.contentInset.top;
    }
    if (new.y > -_lockArea) {
        new.y = -_lockArea;
    }
    return new;
}

- (BOOL)isNeedInteractiveScrollView:(UIScrollView *)scrollView{
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    // 需要先排除自己，有可能自己也遵守了协议
    if (scrollView == self) {
        return NO;
    }
    
    if (scrollView.thk_isWarpperNotScroll) {
        return NO;
    }
    
    // 遵守协议了，就只取contentScrollView
    UIViewController <THKDynamicTabsProtocol> *vc = (UIViewController <THKDynamicTabsProtocol>*)scrollView.tmui_viewController;
    if ([vc respondsToSelector:@selector(contentScrollView)]) {
        UIScrollView *contentScrollView = [vc contentScrollView];
        if (contentScrollView == scrollView) {
            return YES;
        }else{
            return NO;
        }
    }
    
    return YES;
}

- (void)addObservedView:(UIScrollView *)scrollView{
    if (![self.observedViews containsObject:scrollView]) {
        [self.observedViews addObject:scrollView];
        [self addObserverToView:scrollView];
    }
}


- (void)dealloc{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:kTHKScrollViewContentOffsetKVOContext];
    [self removeObservedViews];
}


- (void)removeObservedViews{
    for (UIScrollView *scrollView in self.observedViews) {
        [self removeObserverFromView:scrollView];
    }
    [self.observedViews removeAllObjects];
}

- (void)removeObserverFromView:(UIScrollView *)scrollView{
    @try {
        [scrollView removeObserver:self
                        forKeyPath:NSStringFromSelector(@selector(contentOffset))
                           context:kTHKScrollViewContentOffsetKVOContext];
    }
    @catch (NSException *exception) {}
}

- (void)childViewControllerDidChanged:(UIViewController *)vc{
    if (_pin) {
        return;
    }
    [self.observedViews enumerateObjectsUsingBlock:^(UIScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tmui_viewController == vc) {
            obj.contentOffset = obj.thk_topPoint;
        }
    }];
}

- (void)doCallBackPinChanged:(BOOL)pin{
    if ([self.delegate respondsToSelector:@selector(pageWrapperScrollView:pin:)]) {
        [self.delegate pageWrapperScrollView:self pin:pin];
    }
}

- (void)doCallBackRealChanged:(CGFloat)diff{
    if ([self.delegate respondsToSelector:@selector(pageWrapperScrollViewRealChanged:diff:)]) {
        [self.delegate pageWrapperScrollViewRealChanged:self diff:diff];
    }
}

- (void)doCallBackContentChanged:(UIScrollView *)scrollView diff:(CGFloat)diff{
    if ([self.delegate respondsToSelector:@selector(pageWrapperContentScrollViewChanged:diff:)]) {
        [self.delegate pageWrapperContentScrollViewChanged:scrollView diff:diff];
    }
}

- (void)setPin:(BOOL)pin{
    if (_pin != pin) {
        _pin = pin;
        [self doCallBackPinChanged:pin];
    }
}

- (BOOL)isPin{
    return _pin;
}


TMUI_PropertyLazyLoad(NSMutableArray, observedViews)

@end


@implementation UIScrollView (THKDynamic_PageComponent)

TMUISynthesizeBOOLProperty(thk_isWarpperNotScroll, setThk_isWarpperNotScroll);
TMUISynthesizeBOOLProperty(thk_isAddRefreshControl, setThk_isAddRefreshControl);

- (CGPoint)thk_topPoint{
    return CGPointMake(self.contentOffset.x, -self.contentInset.top);
}
- (BOOL)thk_isAtTop{
    return (int)self.contentOffset.y <= -(int)self.contentInset.top;
}


//- #4    0x00000002115cac60 in -[UIScrollView(UIScrollViewInternal) _adjustContentOffsetIfNecessary] ()
//- (void)#8    0x000000021155e19c in -[UIScrollView(_UIOldConstraintBasedLayoutSupport) _resizeWithOldSuperviewSize:] ()
//{
//
//}
@end
