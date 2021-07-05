//
//  THKSearchAnimation.m
//  HouseKeeper
//
//  Created by ben.gan on 2020/11/24.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKSearchAnimation.h"
#import "THKSearchAnimation+UI.h"

@interface THKSearchAnimation ()

@property (nonatomic, strong) NSArray <UIView *> *enterFadeViews;
@property (nonatomic, strong) NSArray <UIView *> *enterShowViews;
@property (nonatomic, assign) CGRect searchBarStartFrame;
@property (nonatomic, assign) CGRect searchBarEndFrame;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, assign) BOOL cancelBtnAni;
@property (nonatomic, assign) BOOL cancelBtnEnter;
@property (nonatomic, strong) NSString *searchTxt;

@property (nonatomic, assign) CGRect cancelBtnFrame;
@property (nonatomic, assign) BOOL txtHighlighted;
@property (nonatomic, assign) CGFloat beginOffset;
@property (nonatomic, assign) CGFloat endOffset;
@property (nonatomic, strong) NSString *beginBkgImg;

@end

@implementation THKSearchAnimation

- (instancetype)initWithSearchBarStartFrame:(CGRect)searchBarStartFrame
                          searchBarEndFrame:(CGRect)searchBarEndFrame
                             enterFadeViews:(NSArray <UIView *> *)enterFadeViews
                             enterShowViews:(NSArray <UIView *> *)enterShowViews
                                  searchTxt:(NSString *)searchTxt
                             txtHighlighted:(BOOL)txtHighlighted {
    return [self initWithSearchBarStartFrame:searchBarStartFrame searchBarEndFrame:searchBarEndFrame enterFadeViews:enterFadeViews enterShowViews:enterShowViews cancelBtnAni:NO cancelBtnEnter:NO searchTxt:searchTxt txtHighlighted:txtHighlighted beginOffset:0 endOffset:0];
}

- (instancetype)initWithSearchBarStartFrame:(CGRect)searchBarStartFrame
                          searchBarEndFrame:(CGRect)searchBarEndFrame
                             enterFadeViews:(NSArray <UIView *> *)enterFadeViews
                             enterShowViews:(NSArray <UIView *> *)enterShowViews
                               cancelBtnAni:(BOOL)cancelBtnAni
                             cancelBtnEnter:(BOOL)cancelBtnEnter
                                  searchTxt:(NSString *)searchTxt
                             txtHighlighted:(BOOL)txtHighlighted {
     return [self initWithSearchBarStartFrame:searchBarStartFrame searchBarEndFrame:searchBarEndFrame enterFadeViews:enterFadeViews enterShowViews:enterShowViews cancelBtnAni:cancelBtnAni cancelBtnEnter:cancelBtnEnter searchTxt:searchTxt txtHighlighted:txtHighlighted beginOffset:0 endOffset:0];
}

- (instancetype)initWithSearchBarStartFrame:(CGRect)searchBarStartFrame
                          searchBarEndFrame:(CGRect)searchBarEndFrame
                             enterFadeViews:(NSArray <UIView *> *)enterFadeViews
                             enterShowViews:(NSArray <UIView *> *)enterShowViews
                               cancelBtnAni:(BOOL)cancelBtnAni
                             cancelBtnEnter:(BOOL)cancelBtnEnter
                                  searchTxt:(NSString *)searchTxt
                             txtHighlighted:(BOOL)txtHighlighted
                                beginOffset:(CGFloat)beginOffset
                                  endOffset:(CGFloat)endOffset {
    return [self initWithSearchBarStartFrame:searchBarStartFrame searchBarEndFrame:searchBarEndFrame enterFadeViews:enterFadeViews enterShowViews:enterShowViews cancelBtnAni:cancelBtnAni cancelBtnEnter:cancelBtnEnter searchTxt:searchTxt txtHighlighted:txtHighlighted beginOffset:beginOffset endOffset:endOffset beginBkgImg:nil];
}
- (instancetype)initWithSearchBarStartFrame:(CGRect)searchBarStartFrame
                          searchBarEndFrame:(CGRect)searchBarEndFrame
                             enterFadeViews:(NSArray <UIView *> *)enterFadeViews
                             enterShowViews:(NSArray <UIView *> *)enterShowViews
                               cancelBtnAni:(BOOL)cancelBtnAni
                             cancelBtnEnter:(BOOL)cancelBtnEnter
                                  searchTxt:(NSString *)searchTxt
                             txtHighlighted:(BOOL)txtHighlighted
                                beginOffset:(CGFloat)beginOffset
                                  endOffset:(CGFloat)endOffset
                                beginBkgImg:(nonnull NSString *)beginBkgImg {
    if (self = [super init]) {
        NSMutableArray *enterFadeArr = [NSMutableArray array];
        [enterFadeViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [enterFadeArr safeAddObject:[self obtainAniView:obj]];
        }];
        NSMutableArray *enterShowArr = [NSMutableArray array];
        [enterShowViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [enterShowArr safeAddObject:[self obtainAniView:obj]];
        }];
        self.enterFadeViews = enterFadeArr;
        self.enterShowViews = enterShowArr;
        
        self.searchBarStartFrame = searchBarStartFrame;
        self.searchBarEndFrame = searchBarEndFrame;
        self.cancelBtnAni = cancelBtnAni;
        if (self.cancelBtnAni) {
            self.cancelBtn = [THKSearchAnimation cancelBtn];
            self.cancelBtnFrame = self.cancelBtn.frame;
        }
        self.cancelBtnEnter = cancelBtnEnter;
        self.searchTxt = searchTxt;
        self.txtHighlighted = txtHighlighted;
        self.beginOffset = beginOffset;
        self.endOffset = endOffset;
        self.beginBkgImg = beginBkgImg;
    }
    return self;
}



- (void)enterAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    /**
     内容页---> 搜索页
     
     搜索页---> 搜索结果页
     
     搜索结果页---> 搜索页
     
     搜索结果页---> 内容页
     
     */
    
    // 来源页面
    UIViewController *fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    while ([self isContainerViewController:fromVC]) {
        fromVC = [self topViewController:fromVC];
    }
    // 到达页面
    UIViewController *toVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    while ([self isContainerViewController:toVC]) {
        toVC = [self topViewController:toVC];
    }
    
    // 取出转场后视图控制器上的视图View
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    // 转场动画的视图容器
    UIView *containerView = [transitionContext containerView];
    
    // 导航栏
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, self.beginOffset, kScreenWidth, tmui_navigationBarHeight())];
    navView.backgroundColor = [UIColor whiteColor];
    
    if (self.navigationController) {
        [self.navigationController.navigationBar addSubview:navView];
    }
    
    // 搜索栏
    UIView *navBkgView = [THKSearchAnimation navBkgView];
    [navView addSubview:navBkgView];
    if (self.navigationController) {
        navBkgView.top = 0;
    }
    
    //背景图
    UIImageView *bkgImgView = [[UIImageView alloc] init];
    if (self.beginBkgImg) {
        navBkgView.backgroundColor = [UIColor clearColor];
        [bkgImgView loadImageWithUrlStr:self.beginBkgImg];
        bkgImgView.frame = navView.bounds;
        [navView insertSubview:bkgImgView belowSubview:navBkgView];
        bkgImgView.alpha = 1;
    }
    //待消失views
    [self.enterFadeViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [navBkgView addSubview:obj];
        obj.alpha = 1;
    }];

    //待显示views
    [self.enterShowViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [navBkgView addSubview:obj];
        obj.alpha = 0;
    }];
    
    //搜索框
    THKSearchView *searchView = [[self class] searchView:self.txtHighlighted];
    searchView.searchLabel.text = self.searchTxt;
    searchView.frame = self.searchBarStartFrame;
    [navBkgView addSubview:searchView];
    if (CGRectEqualToRect(self.searchBarStartFrame, CGRectZero)) {
        searchView.frame = self.searchBarEndFrame;
        searchView.alpha = 0;
    }
    
    //取消按钮
    if (self.cancelBtn && self.cancelBtnAni) {
        [navBkgView addSubview:self.cancelBtn];
        if (self.cancelBtnEnter) {
            self.cancelBtn.left = kScreenWidth;
            self.cancelBtn.alpha = 0;
        } else {
            self.cancelBtn.frame = self.cancelBtnFrame;
            self.cancelBtn.alpha = 1;
        }
    }

    // 遮盖搜索首页内容部分
    UIView *searchContentView = [[UIView alloc] initWithFrame:CGRectMake(0, navView.bottom, kScreenWidth, kScreenHeight - (navView.bottom))];
    searchContentView.backgroundColor = [UIColor whiteColor];
    searchContentView.alpha = 0;
    toView.alpha = 0;
    
    [containerView addSubview:searchContentView];
    [containerView addSubview:toView];

    if (!self.navigationController) {
        [containerView addSubview:navView];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] * 0.3 animations:^{
        searchContentView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:[self transitionDuration:transitionContext] * 0.7 animations:^{
            toView.alpha = 1;
        }];
    }];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        searchView.alpha = 1;
        searchView.frame = self.searchBarEndFrame;
        if (self.cancelBtn && self.cancelBtnAni) {
            if (self.cancelBtnEnter) {
                self.cancelBtn.frame = self.cancelBtnFrame;
                self.cancelBtn.alpha = 1;
            } else {
                self.cancelBtn.left = kScreenWidth;
                self.cancelBtn.alpha = 0;
            }
        }
        //待消失views
        [self.enterFadeViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.alpha = 0;
        }];

        //待显示views
        [self.enterShowViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.alpha = 1;
        }];
        navView.top = self.endOffset;
        bkgImgView.alpha = 0;
    } completion:^(BOOL finished) {
        navView.alpha = 0;
        
        [navView removeFromSuperview];
        [searchContentView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)backAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 来源页面
    UIViewController *fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    while ([self isContainerViewController:fromVC]) {
        fromVC = [self topViewController:fromVC];
    }
    // 到达页面
    UIViewController *toVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    while ([self isContainerViewController:toVC]) {
        toVC = [self topViewController:toVC];
    }
    
    // 取出转场后视图控制器上的视图View
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

    // 转场动画的视图容器
    UIView *containerView = [transitionContext containerView];
    
    // 导航栏
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, self.endOffset, kScreenWidth, tmui_navigationBarHeight())];
    navView.backgroundColor = [UIColor whiteColor];
    
    // 搜索栏
    UIView *navBkgView = [THKSearchAnimation navBkgView];
    [navView addSubview:navBkgView];
    
    //背景图
    UIImageView *bkgImgView = [[UIImageView alloc] init];
    if (self.beginBkgImg) {
        navBkgView.backgroundColor = [UIColor clearColor];
        [bkgImgView loadImageWithUrlStr:self.beginBkgImg];
        bkgImgView.frame = navView.bounds;
        [navView insertSubview:bkgImgView belowSubview:navBkgView];
        bkgImgView.alpha = 0;
    }
    
    //待显示views
    [self.enterFadeViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [navBkgView addSubview:obj];
        obj.alpha = 0;
    }];

    //待消失views
    [self.enterShowViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [navBkgView addSubview:obj];
        obj.alpha = 1;
    }];
    
    //搜索框
    THKSearchView *searchView = [[self class] searchView:self.txtHighlighted];
    searchView.searchLabel.text = self.searchTxt;
    searchView.frame = self.searchBarEndFrame;
    [navBkgView addSubview:searchView];
    
    //取消按钮
    if (self.cancelBtn && self.cancelBtnAni) {
        [navBkgView addSubview:self.cancelBtn];
        if (!self.cancelBtnEnter) {
            self.cancelBtn.left = kScreenWidth;
            self.cancelBtn.alpha = 0;
        } else {
            self.cancelBtn.frame = self.cancelBtnFrame;
            self.cancelBtn.alpha = 1;
        }
    }
    UIView *toViewSnapshotView = [toView snapshotViewAfterScreenUpdates:YES];
    [containerView addSubview:toViewSnapshotView];
    [containerView addSubview:fromView];
    [containerView addSubview:navView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        if (CGRectEqualToRect(self.searchBarStartFrame, CGRectZero)) {
            searchView.frame = self.searchBarEndFrame;
            searchView.alpha = 0;
            navView.alpha = 0;
        } else {
            searchView.frame = self.searchBarStartFrame;
        }
        if (self.cancelBtn && self.cancelBtnAni) {
            if (!self.cancelBtnEnter) {
                self.cancelBtn.frame = self.cancelBtnFrame;
                self.cancelBtn.alpha = 1;
            } else {
                self.cancelBtn.left = kScreenWidth;
                self.cancelBtn.alpha = 0;
            }
        }

        //待显示views
        [self.enterFadeViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.alpha = 1;
        }];

        //待消失views
        [self.enterShowViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.alpha = 0;
        }];
        fromView.alpha = 0;
        navView.top = self.beginOffset;
        bkgImgView.alpha = 1;
    } completion:^(BOOL finished) {
        navView.alpha = 0;
        [toViewSnapshotView removeFromSuperview];
        [navView removeFromSuperview];
        [fromView removeFromSuperview];
        [containerView addSubview:toView];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)changeEndOffset:(CGFloat)endOffset {
    self.endOffset = endOffset;
}

#pragma mark - Public

- (void)changeSearchBarStartFrame:(CGRect)searchBarStartFrame {
    self.searchBarStartFrame = searchBarStartFrame;
}

- (void)changeSearchBarEndFrame:(CGRect)searchBarEndFrame {
    self.searchBarEndFrame = searchBarEndFrame;
}

- (void)changeEnterFadeViews:(NSArray <UIView *> *)enterFadeViews {
    NSMutableArray *enterFadeArr = [NSMutableArray array];
    [enterFadeViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [enterFadeArr safeAddObject:[self obtainAniView:obj]];
    }];

    self.enterFadeViews = enterFadeArr;
}

- (void)changeEnterShowViews:(NSArray <UIView *> *)enterShowViews {
    NSMutableArray *enterShowArr = [NSMutableArray array];
    [enterShowViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [enterShowArr safeAddObject:[self obtainAniView:obj]];
    }];
    self.enterShowViews = enterShowArr;
}

- (void)changeCancelBtnAni:(BOOL)cancelBtnAni {
    self.cancelBtnAni = cancelBtnAni;
}

- (void)changeCancelBtnEnter:(BOOL)cancelBtnEnter {
    self.cancelBtnEnter = cancelBtnEnter;
}

- (void)changeSearchTxt:(NSString *)searchTxt {
    self.searchTxt = searchTxt;
}

+ (CGRect)searchVCSearchBarFrame {
    return [THKSearchAnimation searchBar].frame;
}

+ (CGRect)searchResultContainerVCFrame {
    TMSearchBar *searchBar = [THKSearchAnimation searchBar];
    searchBar.left = [THKSearchAnimation backBtn].right;
    return searchBar.frame;
}

#pragma mark - Private

- (UIViewController *)topViewController:(UIViewController *)viewController {
    UIViewController *topViewController;
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        topViewController = ((UITabBarController *)viewController).selectedViewController;
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        topViewController = ((UINavigationController *)viewController).topViewController;
    } else {
        topViewController = viewController;
    }
    return topViewController;
}

- (BOOL)isContainerViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]] ||
        [viewController isKindOfClass:[UINavigationController class]]) {
        return YES;
    }
    return NO;
}

- (UIView *)obtainAniView:(UIView *)targetView {
    if (!targetView) {
        return nil;
    }
    
    if (targetView.superview) {
        UIView *view = [targetView snapshotViewAfterScreenUpdates:NO];
        view.frame = targetView.frame;
        return view;
    } else {
        return targetView;
    }
}

@end
