//
//  TMCardComponentBaseListViewContontroller.m
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "TMCardComponentBaseListViewContontroller.h"
//#import "TMCardComponentBaseListViewContontroller+jumpToContentDetailPageAsCustomPushPopTransition.h"

@interface TMCardComponentBaseListViewContontroller ()

@property (nonatomic, strong, readonly)TMCardComponentBaseListView *cardsView;

@property (nonatomic, strong)NSMutableArray<NSObject<TMCardComponentCellDataBasicProtocol> *> *dataList;



@end

@implementation TMCardComponentBaseListViewContontroller
@synthesize layout = _layout;
@synthesize cardsView = _cardsView;

- (void)loadView {
    self.view = self.cardsView;
    [self bindCardsViewBlocks];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = THKColor_FlowListBackgroundColor;
    self.view.clipsToBounds = YES;
    //触发提前注册自定义cell
    __weak typeof(self) wk_self = self;
    [self.cardsView registCustomCells:^(UICollectionView * _Nonnull collectionView) {
        __strong typeof(self) self = wk_self;
        [self registCustomCellInCollectionView:collectionView];
    }];
}

- (void)bindCardsViewBlocks {
    [self bindSectionHeaderAndFooterBlocks];
    [self bindDatasourceBlocks];
    [self bindCellReportDataBlocks];
    [self bindScrollEventBlocks];
}

- (void)bindDatasourceBlocks {
    __weak typeof(self) wk_self = self;
    [self.cardsView setNumberOfSectionsBlock:^NSInteger(TMCardComponentBaseListView * _Nonnull cardsCollectionView) {
        __strong typeof(self) self = wk_self;
        return [self numberOfSections];
    }];
    [self.cardsView setNumberOfItemsInSectionBlock:^NSInteger(TMCardComponentBaseListView * _Nonnull cardsCollectionView, NSInteger section) {
        __strong typeof(self) self = wk_self;
        return [self numberOfItemsInSection:section];
    }];
    [self.cardsView setColumnsInSectionBlock:^NSInteger(TMCardComponentBaseListView * _Nonnull cardsCollectionView, NSInteger section) {
        __strong typeof(self) self = wk_self;
        return [self columnsInSection:section];
    }];
    [self.cardsView setDataAtIndexPathBlock:^NSObject<TMCardComponentCellDataBasicProtocol> * _Nonnull(TMCardComponentBaseListView * _Nonnull cardsCollectionView, NSIndexPath * _Nonnull indexPath) {
        __strong typeof(self) self = wk_self;
        return [self dataAtIndexPath:indexPath];
    }];
    [self.cardsView setClickCellBlock:^(TMCardComponentBaseListView * _Nonnull cardsCollectionView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSObject<TMCardComponentCellDataBasicProtocol> * _Nonnull data) {
        __strong typeof(self) self = wk_self;
        [self didClickCell:cell atIndexPath:indexPath data:data];
    }];
    //自定义样式cell相关回调
    [self.cardsView setCustomCellIdentifierBlock:^NSString * _Nonnull(TMCardComponentBaseListView * _Nonnull cardsCollectionView, NSIndexPath * _Nonnull indexPath, NSObject<TMCardComponentCellDataBasicProtocol> * _Nonnull data) {
        __strong typeof(self) self = wk_self;
        return [self customCellReuseIdentifierAtIndexPath:indexPath data:data];
    }];
    [self.cardsView setFillCustomCellBlock:^(TMCardComponentBaseListView * _Nonnull cardsCollectionView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSObject<TMCardComponentCellDataBasicProtocol> * _Nonnull data) {
        __strong typeof(self) self = wk_self;
        [self fillCustomCell:cell atIndexPath:indexPath data:data];
    }];
    //子类扩展cellUI元素需要的额外接口
    [self.cardsView setExtraAddUIElementsOnCellBlock:^(TMCardComponentBaseListView * _Nonnull cardsCollectionView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSObject<TMCardComponentCellDataBasicProtocol> * _Nonnull data) {
        __strong typeof(self) self = wk_self;
        [self extraAddUIElementsOnCell:cell atIndexPath:indexPath data:data];
    }];
    if (self.needFloatingHeaderSupport) {
        [self.cardsView setFloatingHeaderAtIndexPath:^BOOL(NSIndexPath * _Nonnull indexPath) {
            __strong typeof(self) self = wk_self;
            return [self floatingHeaderAtIndexPath:indexPath];
        }];
    }else {
        self.cardsView.floatingHeaderAtIndexPath = nil;
    }
    [self.cardsView setWillDisplayCellAtIndexPathBlock:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath) {
        __strong typeof(self) self = wk_self;
        [self willDisplayCell:cell atIndexPath:indexPath];
    }];
    [self.cardsView setDidEndDisplayCellAtIndexPathBlock:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath) {
        __strong typeof(self) self = wk_self;
        [self didEndDisplayCell:cell atIndexPath:indexPath];
    }];
}

- (void)bindSectionHeaderAndFooterBlocks {
    __weak typeof(self) wk_self = self;
    //section insets
    [self.cardsView setInsetsOfSectionsBlock:^UIEdgeInsets(TMCardComponentBaseListView * _Nonnull cardsCollectionView, NSInteger section) {
        __strong typeof(self) self = wk_self;
        return [self sectionInsectsAtSection:section];
    }];
    
    //section header
    [self.cardsView setSectionHeaderHeightBlock:^CGFloat(TMCardComponentBaseListView * _Nonnull cardsCollectionView, NSInteger section) {
        __strong typeof(self) self = wk_self;
        return [self sectionHeaderHeightAtSection:section];
    }];
    [self.cardsView setSectionHeaderViewBlock:^(TMCardComponentBaseListView * _Nonnull cardsCollectionView, NSInteger section, UICollectionReusableView * _Nonnull view) {
        __strong typeof(self) self = wk_self;
        [self fillContentInHeaderView:view atSection:section];
    }];
    //section footer
    [self.cardsView setSectionFooterHeightBlock:^CGFloat(TMCardComponentBaseListView * _Nonnull carsCollectionView, NSInteger section) {
        __strong typeof(self) self = wk_self;
        return [self sectionFooterHeight];
    }];
    [self.cardsView setSectionFooterViewBlock:^(TMCardComponentBaseListView * _Nonnull cardsCollectionView, NSInteger section, UICollectionReusableView * _Nonnull view) {
        __strong typeof(self) self = wk_self;
        [self fillContentInFooterView:view atSection:section];
    }];
    
    [self.cardsView setMinimumInteritemSpacingBlock:^CGFloat(TMCardComponentBaseListView * _Nonnull carsCollectionView, NSInteger section) {
        __strong typeof(self) self = wk_self;
        return [self minimumInteritemSpacingAtSection:section];
    }];
}

- (void)bindCellReportDataBlocks {
    __weak typeof(self) wk_self = self;
    [self.cardsView setCellWidgetUidBlock:^NSString * _Nullable(TMCardComponentBaseListView * _Nonnull cardsCollectionView, NSIndexPath * _Nonnull indexPath, NSObject<TMCardComponentCellDataBasicProtocol> * _Nonnull data) {
        __strong typeof(self) self = wk_self;
        return [self reportWidgetUidOfCellAtIndexPath:indexPath data:data];
    }];
    [self.cardsView setCellReportDataBlock:^NSDictionary * _Nullable(TMCardComponentBaseListView * _Nonnull cardsCollectionView, NSIndexPath * _Nonnull indexPath, NSObject<TMCardComponentCellDataBasicProtocol> * _Nonnull data) {
        __strong typeof(self) self = wk_self;
        return [self reportResourceOfCellAtIndexPath:indexPath data:data];
    }];
}

- (void)bindScrollEventBlocks {
    __weak typeof(self) wk_self = self;
    [self.cardsView setDidEndScrollWithVisibleIndexPathsBlock:^(NSArray<NSIndexPath *> * _Nonnull visibleIndexPaths) {
        __strong typeof(self) self = wk_self;
        [self didEndScrollWithVisibleIndexPaths:visibleIndexPaths];
    }];
}

#pragma mark - public api
- (void)reloadData {
    [self.cardsView reloadData];
}

- (void)insertItemsWithBlock:(NSArray<NSIndexPath *> *(^)(void))dataInsertBlock {
    [self.cardsView insertItemsWithBlock:dataInsertBlock];
}

- (void)deleteItemsWithBlock:(NSArray<NSIndexPath *> *(^)(void))dataDeleteBlock {
    [self.cardsView deleteItemsWithBlock:dataDeleteBlock];
}

- (void)updateItemsWithBlock:(void(^)(NSMutableArray<NSIndexPath *> *toAddIndexPaths, NSMutableArray<NSIndexPath *> *toDeleteIndexPaths))updateBlock {
    [self.cardsView updateItemsWithBlock:updateBlock];
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    [self.cardsView scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (NSArray<NSIndexPath *> *)visibleIndexPaths {
    return [self.cardsView visibleIndexPaths];
}

#pragma mark - 列表滚动停止时的回调，子类可根据需要进行重写

- (void)didEndScrollWithVisibleIndexPaths:(NSArray<NSIndexPath *> *)visibleIndexPaths { }

#pragma mark - 设置内部collectionview相关dataSource数据
- (NSInteger)numberOfSections {
    return 1;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 0;
}
- (NSInteger)columnsInSection:(NSInteger)section {
    return 2;
}
- (NSObject<TMCardComponentCellDataBasicProtocol> *)dataAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
- (void)didClickCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> *)data {
    [self public_common_didClickCell:cell atIndexPath:indexPath data:data];
}

- (void)doRouterJump:(TRouter *)router withClickCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> *)data {
    [self public_common_routerJump:router clickCell:cell atIndexPath:indexPath data:data];
}

- (NSString *)customCellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> *)data {
    return nil;
}

- (void)registCustomCellInCollectionView:(UICollectionView *)collectionView { }

- (void)fillCustomCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> *)data { }

#pragma mark - 当内部执行cellForItem方法按正常流程或自定义流程生成了有效的cell后，会额外回调一次以下方法，以便子类可对标准的卡片组件做一些扩展的UI调整(通常是在标准组件视图层上添加其它功能项子视图，例如：选择、删除蒙层等)
- (void)extraAddUIElementsOnCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> *)data {}

#pragma mark - 设置section Header & Footer的方法，子类根据实际情况选择实现
- (UIEdgeInsets)sectionInsectsAtSection:(NSInteger)section {
    return self.cardsView.layout.sectionInset;
}

- (CGFloat)sectionHeaderHeightAtSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)sectionFooterHeight {
    return CGFLOAT_MIN;
}

-(CGFloat)minimumInteritemSpacingAtSection:(NSInteger)section {
    return self.cardsView.layout.minimumInteritemSpacing;
}

- (void)fillContentInHeaderView:(UICollectionReusableView *)sectionHeaderView atSection:(NSInteger)section { }
- (void)fillContentInFooterView:(UICollectionReusableView *)sectionFooterView atSection:(NSInteger)section { }
- (void)setNeedFloatingHeaderSupport:(BOOL)needFloatingHeaderSupport {
    _needFloatingHeaderSupport = needFloatingHeaderSupport;
    
    if ([self isViewLoaded]) {
        if (needFloatingHeaderSupport) {
            @weakify(self);
            self.cardsView.floatingHeaderAtIndexPath = ^BOOL(NSIndexPath * _Nonnull indexPath) {
                @strongify(self);
                return [self floatingHeaderAtIndexPath:indexPath];
            };
        }else {
            self.cardsView.floatingHeaderAtIndexPath = nil;
        }
    }
}
- (BOOL)floatingHeaderAtIndexPath:(NSIndexPath *)indexPath { return NO; }
- (void)willDisplayCell:(__kindof UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {};
- (void)didEndDisplayCell:(__kindof UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {};

#pragma mark - 埋点相关方法,需要子类实现提供具体数据值
- (NSString *_Nullable)reportWidgetUidOfCellAtIndexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> * _Nonnull)data {
    return nil;
}
- (NSDictionary *_Nullable)reportResourceOfCellAtIndexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> * _Nonnull)data {
    return nil;
}

#pragma mark - lazy load ui

- (TMCardComponentBaseListView *)cardsView {
    if (!_cardsView) {
        _cardsView = [[TMCardComponentBaseListView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _cardsView;
}

- (TMCardComponentCollectionViewLayout *)layout {
    return self.cardsView.layout;
}

- (UIScrollView *)scrollView {
    return self.cardsView.scrollView;
}



#pragma mark - public common click cell action
- (void)public_common_didClickCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> *)data {
    
    if (![self checkSelfAsLastVcInNavVcsStack]) {
        //防止快速重复点击重复响应push操作
        return;
    }
    
    if (![data conformsToProtocol:@protocol(TMCardComponentCellDataBasicProtocol)]) {
        [self private_debug_exception_tip:@"用了卡片组件列表，但组装的cellData未服从协议：TMCardComponentCellDataBasicProtocol"];
        return;
    }
    
    if (data.style == TMCardComponentCellStyleCustom) {
        [self private_debug_exception_tip:@"自定义的非卡片组件类型里的样式cell需要子类自行实现其点击的相关处理逻辑"];
        return;
    }
    
    if ([data conformsToProtocol:@protocol(TMCardComponentCellDataProtocol)]) {
        if (data.style == TMCardComponentCellStyleRecommendTags) {
            //推荐的标签卡片整体点击事件不需要响应，处理单个标签项点击即可
            return;
        }
        
        id<TMCardComponentCellDataProtocol> cardData = (id<TMCardComponentCellDataProtocol>)data;
        if (cardData.content.router.length == 0) {
            [self private_debug_exception_tip:@"卡片组件cellData数据里路由串content.router为空，无法响应点击跳转"];
            return;
        }
            
        TRouter *router = [TRouter routerFromUrl:cardData.content.router jumpController:self.navigationController];
        [self public_common_routerJump:router clickCell:cell atIndexPath:indexPath data:data];
        
    }else {
        [self private_debug_exception_tip:@"用了标准样式卡片组件，但对应的cellData未服从协议：TMCardComponentCellDataProtocol"];
    }
        
}

- (void)public_common_routerJump:(TRouter *)router clickCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath data:(NSObject<TMCardComponentCellDataBasicProtocol> *)data {
    if ([data conformsToProtocol:@protocol(TMCardComponentCellDataProtocol)]) {
        id<TMCardComponentCellDataProtocol> cardData = (id<TMCardComponentCellDataProtocol>)data;
        //判断是否是跳转到效果图详情页，若是则单独处理增加跳转动效交互
//        if ([router routerMatch:THKRouterPage_PrettyPicDetail]) {
//            [self helper_jumpToPrettyDetailWithData:cardData indexPath:indexPath router:router cell:cell];
//            return;
//        }else if ([router routerMatch:THKRouterPage_VideoDetail]) {
//            [self helper_jumpToVideoDetailWithData:cardData router:router cell:cell];
//            return;
//        }else if ([router routerMatch:THKRouterPage_CaseDetail]) {
//            [self helper_jumpToCaseDetailWithData:cardData indexPath:indexPath router:router cell:cell];
//            return;
//        }else if ([router routerMatch:THKRouterPage_DiaryDetail]) {
//            [self helper_jumpToDiaryDetailWithData:cardData indexPath:indexPath router:router cell:cell];
//            return;
//        }
    }
    //默认按通用单一的路由跳转处理
    [[TRouterManager sharedManager] performRouter:router];
}

- (BOOL)checkSelfAsLastVcInNavVcsStack {
    UIViewController *lastNavVc = self;
    while (lastNavVc.parentViewController && ![lastNavVc.parentViewController isKindOfClass:[UINavigationController class]]) {
        lastNavVc = lastNavVc.parentViewController;
    }
    if ([lastNavVc.parentViewController isKindOfClass:[UINavigationController class]]) {
        if (![lastNavVc.navigationController.viewControllers.lastObject isEqual:lastNavVc]) {
            // 防止快速重复点击时，会push多个其它vc
            return NO;
        }
    }
    return YES;
}

- (void)private_debug_exception_tip:(NSString *)msg {
#if DEBUG
    if (msg.length > 0) {
        NSLog(@"%@", msg);
//        [TMToast toast:msg hideAfterDelay:3 hideFinishBlock:nil];
    }
#endif
}

@end
