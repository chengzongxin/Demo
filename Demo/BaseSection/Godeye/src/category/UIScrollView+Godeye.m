//
//  UIScrollView+Godeye.m
//  Pods
//
//  Created by jerry.jiang on 2018/12/28.
//

#import "UIScrollView+Godeye.h"
#import <objc/runtime.h>
#import "GESwizzer.h"
#import "UIView+Godeye.h"
#import "GEWidgetProcessor.h"
#import "GECollectionView.h"
#import "GETableView.h"
#import "Godeye.h"
@interface GEScrollViewExposeEventBundle : NSObject
@property (nonatomic, strong) GEWidgetExposeEvent *event;
@property (nonatomic, assign) NSTimeInterval appearTime;
@property (nonatomic, assign) BOOL processing;
@end
@implementation GEScrollViewExposeEventBundle
@end


@interface GEScrollViewObserver : NSObject
{
    UIScrollView *_obserevingScrollView;
}
@property (nonatomic, strong) NSHashTable <UIView *> *observedViews;
@end

@implementation GEScrollViewObserver

static const char *kExposeEventBundleKey = "GEExposeEventBundleKey";

static dispatch_queue_t _trackQueue;
static dispatch_semaphore_t _semaphore;

#define EXPOSE_QUEUE_LOCK       do { dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER); } while(0)
#define EXPOSE_QUEUE_UNLOCK     do { dispatch_semaphore_signal(_semaphore); } while(0)

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    self = [super init];
    if (self) {
        _observedViews = [NSHashTable weakObjectsHashTable];
        _obserevingScrollView = scrollView;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _trackQueue = dispatch_queue_create("com.to8to.godeye.exposeTrackQueue", DISPATCH_QUEUE_SERIAL);
            _semaphore = dispatch_semaphore_create(1);
        });
    }
    return self;
}

- (void)registerSubview:(UIView *)view forExposeEvent:(GEWidgetExposeEvent *)expose
{
    NSParameterAssert(view);
    NSParameterAssert(expose);
    GEScrollViewExposeEventBundle *bundle = [[GEScrollViewExposeEventBundle alloc] init];
    bundle.event = expose;
    objc_setAssociatedObject(view, kExposeEventBundleKey, bundle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    EXPOSE_QUEUE_LOCK;
    [self.observedViews addObject:view];
    EXPOSE_QUEUE_UNLOCK;
}

- (void)reportEventWithView:(UIView *)view;
{
    GEScrollViewExposeEventBundle *bundle = objc_getAssociatedObject(view, kExposeEventBundleKey);
    objc_setAssociatedObject(view, kExposeEventBundleKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (![bundle isKindOfClass:[GEScrollViewExposeEventBundle class]]) {//bugly上有报一个错：-[__NSDictionaryM event]: unrecognized selector sent to instance，需要需要对它做一个判断
        return;
    }
    if (bundle && bundle.event && [bundle.event isKindOfClass:[GEWidgetExposeEvent class]] && bundle.event.willExposeBlock) {
        __weak typeof(view) wk_view = view;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(view) view = wk_view;
            if (bundle && [bundle isKindOfClass:[GEScrollViewExposeEventBundle class]] && bundle.event && [bundle.event isKindOfClass:[GEWidgetExposeEvent class]]) {
                bundle.event.willExposeBlock(view,bundle.event.resource);
            }
        });
    } else {
        [bundle.event report];
    }
    
    EXPOSE_QUEUE_LOCK;
    [self.observedViews removeObject:view];
    EXPOSE_QUEUE_UNLOCK;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object != _obserevingScrollView || ![keyPath isEqualToString:@"contentOffset"]) {
        return;
    }
    
    [self reportRegisterViews];
    
    //两次间隔至少0.5s才会触发上报
    __weak typeof(self) wk_self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(self) self = wk_self;
        if (self) {
            [self reportRegisterViews];
        }
    });
}

- (void)reportRegisterViews {
    
    if (_obserevingScrollView.disableExposeReport) {
        return;
    }
    
    EXPOSE_QUEUE_LOCK;
    NSArray <UIView *> *views = self.observedViews.allObjects;
    EXPOSE_QUEUE_UNLOCK;
    
    for (UIView *view in views) {
        GEScrollViewExposeEventBundle *bundle = objc_getAssociatedObject(view, kExposeEventBundleKey);
        CGRect frame = view.frame;
        frame = [view convertRect:view.bounds toView:_obserevingScrollView.window];
        if (![bundle isKindOfClass:[GEScrollViewExposeEventBundle class]]) {//bugly上有报一个错：-[__NSDictionaryM event]: unrecognized selector sent to instance，需要需要对它做一个判断
            return;
        }
        if (!bundle || !bundle.event || bundle.processing || !_obserevingScrollView.isDisplayedInScreen) {
            continue;
        }
        bundle.processing = YES;
        CGRect windowFrame = _obserevingScrollView.window.bounds;
        dispatch_async(_trackQueue, ^{
            
            CGRect scrollInset = CGRectIntersection(frame, windowFrame);
            BOOL isAppear = (scrollInset.size.width*scrollInset.size.height)/(frame.size.width*frame.size.height) > 0.5;
            
            if (bundle.appearTime) {
                if (CURRENT_TIMESTAMP - bundle.appearTime > 0.5 && isAppear) {
                    [self reportEventWithView:view];
                } else if (!isAppear) {
                    bundle.appearTime = 0;
                }
            } else {
                if (isAppear) {
                    bundle.appearTime = CURRENT_TIMESTAMP;
                }
            }
            
            bundle.processing = NO;
        });
    }
}

- (void)dealloc {
    if (_obserevingScrollView) {
        [_obserevingScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

@end


@interface UIResponder (GEExposeEventTracker)
- (GEScrollViewObserver *)ge_observerWithScrollView:(UIScrollView *)scrollView;
@end

@implementation UIResponder (GEExposeEventTracker)

static const char *kObserverKey    = "GEExposeObserverKey";

- (GEScrollViewObserver *)ge_observerWithScrollView:(UIScrollView *)scrollView
{
    NSString *key = [NSString stringWithFormat:@"%p", scrollView];
    NSMutableDictionary *dic = objc_getAssociatedObject(self, kObserverKey);
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, kObserverKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    GEScrollViewObserver *ob = [dic objectForKey:key];
    if (!ob) {
        ob = [[GEScrollViewObserver alloc] initWithScrollView:scrollView];
        [dic setObject:ob forKey:key];
    }
    return ob;
}

- (GEScrollViewObserver *)ge_observerOfScrollView:(UIScrollView *)scrollView {
    NSString *key = [NSString stringWithFormat:@"%p", scrollView];
    NSMutableDictionary *dic = objc_getAssociatedObject(self, kObserverKey);
    if (!dic) {return  nil;}
    GEScrollViewObserver *ob = [dic objectForKey:key];
    if (!ob) {return nil;}
    return ob;
}

@end



@interface UIScrollView ()

@property (nonatomic, strong) RegistScrollViewProxy *scrollViewProxy;

@end

@implementation UIScrollView (Godeye)

- (BOOL)disableExposeReport {
    NSNumber *result = objc_getAssociatedObject(self, _cmd);
    if (!result) {
        return NO;
    }
    return [result boolValue];
}

- (void)setDisableExposeReport:(BOOL)disableExposeReport {
    if (self.scrollViewProxy) {
        [self.scrollViewProxy attachScrollView:disableExposeReport ? nil : self];
    }
    
    objc_setAssociatedObject(self, @selector(disableExposeReport), @(disableExposeReport), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/** SDK 0.9.0增加的新方法 begin  */
- (RegistScrollViewProxy *)scrollViewProxy {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setScrollViewProxy:(RegistScrollViewProxy *)scrollViewProxy {
    objc_setAssociatedObject(self, @selector(scrollViewProxy), scrollViewProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UIScrollViewDelegate>)originDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOriginDelegate:(id<UIScrollViewDelegate>)originDelegate {
    objc_setAssociatedObject(self, @selector(originDelegate), originDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (GEExposeBlock)geExposeBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGeExposeBlock:(GEExposeBlock)geExposeBlock {
    if (![self _scrollViewEnabledWithBlock:@"geExposeBlock"]) {
        return;
    }
    objc_setAssociatedObject(self, @selector(geExposeBlock), geExposeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (!geExposeBlock) {
        if (self.scrollViewProxy) {
            [self.scrollViewProxy attachScrollView:nil];
        }
    } else {
        [self didMoveToSuperview];
    }
}

- (GEExposeItemsBlock)geExposeItemsBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGeExposeItemsBlock:(GEExposeItemsBlock)geExposeItemsBlock {
    if (![self _scrollViewEnabledWithBlock:@"geExposeItemsBlock"]) {
        return;
    }
    objc_setAssociatedObject(self, @selector(geExposeItemsBlock), geExposeItemsBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (!geExposeItemsBlock) {
        if (self.scrollViewProxy) {
            [self.scrollViewProxy attachScrollView:nil];
        }
    } else {
        [self didMoveToSuperview];
    }
}

- (void)didMoveToSuperview {
    if (self.superview) {//添加到窗口
        //只监听UITableView和UICollectionView
        BOOL isAvailable = [self isKindOfClass:[GETableView class]] || [self isKindOfClass:[GECollectionView class]];
        if ([self exposeBlockEnabled] && !self.disableExposeReport && isAvailable) {
            if (!self.scrollViewProxy) {
                self.scrollViewProxy = [RegistScrollViewProxy proxy];
                [self.scrollViewProxy attachScrollView:self];
            }
        }
    }
}

- (BOOL)exposeBlockEnabled {
    return self.geExposeBlock || self.geExposeItemsBlock;
}

/**
 计算当前曝光的cell
 */
- (void)reportExpose {
    if ([self exposeBlockEnabled] && !self.disableExposeReport) {
        [GEScrollViewExposeManger calculateVisbleCellsWithScrollView:self];
    }
}

- (BOOL)_scrollViewEnabledWithBlock:(NSString *)blockString {
    //曝光的block只对GECollectionView和GETableView生效
    BOOL enabled = [self isKindOfClass:[GECollectionView class]] || [self isKindOfClass:[GETableView class]];
    NSString *viewString = @"GETableView";
    if ([self isKindOfClass:[UICollectionView class]]) {
        viewString = @"GECollectionView";
    }
    NSString *assertString = [NSString stringWithFormat:@"You have to use %@ and then set %@",viewString,blockString];
    NSAssert(enabled, assertString);
    
    return enabled;
}

/**   SDK 0.9.0增加的新方法 end    */


- (void)registerSubview:(UIView *)view forExposeEvent:(GEWidgetExposeEvent *)expose
{
    if (![self exposeBlockEnabled]) {
        NSAssert(self.nextResponder, @"the nextResponder of scrollView should not be nil");
        GEScrollViewObserver *ob = [self.nextResponder ge_observerWithScrollView:self];
        [ob registerSubview:view forExposeEvent:expose];
    }
}

- (void)reportRegisterViews {
    if (![self exposeBlockEnabled]) {
        if (!self.nextResponder) {return;}
        
        GEScrollViewObserver *ob = [self.nextResponder ge_observerOfScrollView:self];
        [ob reportRegisterViews];
    }
}

@end



@interface UITableView (Godeye)
@end

@implementation UITableView (Godeye)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzInstanceMethod(self, @selector(reloadData), @selector(ge_reloadData));
    });
}

- (void)ge_reloadData {
    [self ge_reloadData];
    
    __weak typeof(self) wk_self = self;
    if (![self exposeBlockEnabled]) {
        //第一次只能触发reportRegisterViews逻辑中的设置view.exposeBundle.appearTime
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(self) self = wk_self;
            if (self) {
                [self reportRegisterViews];
            }
        });
        //两次间隔至少0.5s才会触发上报
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(self) self = wk_self;
            if (self) {
                [self reportRegisterViews];
            }
        });
    }
}

@end


@interface UICollectionView (Godeye)
@end

@implementation UICollectionView (Godeye)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzInstanceMethod(self, @selector(reloadData), @selector(ge_reloadData));
    });
}

- (void)ge_reloadData {
    [self ge_reloadData];
    
    __weak typeof(self) wk_self = self;
    
    if (![self exposeBlockEnabled]) {
        //第一次只能触发reportRegisterViews逻辑中的设置view.exposeBundle.appearTime
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(self) self = wk_self;
            if (self) {
                [self reportRegisterViews];
            }
        });
        //两次间隔至少0.5s才会触发上报
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(self) self = wk_self;
            if (self) {
                [self reportRegisterViews];
            }
        });
    }
}

@end
