//
//  TMCardComponentBaseListView.m
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "TMCardComponentBaseListView.h"
#import "THKCommonJavaRequest.h"
#define TMCardComponentBaseListViewSectionHeaderIdentifier @"kSectionHeader"
#define TMCardComponentBaseListViewSectionFooterIdentifier @"kSectionFooter"

@interface TMCardComponentBaseListView()<
UICollectionViewDelegate,
UICollectionViewDataSource,
CHTCollectionViewDelegateWaterfallLayout,
UIScrollViewDelegate
>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong, class, readonly)NSDictionary<NSNumber *, TMBasicCardCellIdentifier *> *styleMapCellIdentifiers;

@end

@implementation TMCardComponentBaseListView

@synthesize layout = _layout;

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = THKColor_FlowListBackgroundColor;
    self.clipsToBounds = YES;
    [self addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    if (@available(iOS 13.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self registerSectionHeaderFooter];
    [self registerCells];
}

- (void)registerCells {
    //注册一个异常逻辑时，按reuseidentifier方式返回一个空cell,保持app不crash
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"kExceptEmptyCell"];
    //
    NSArray<NSString *> *identifiers = [self class].styleMapCellIdentifiers.allValues;
    for (NSString *identifier in identifiers) {
        Class cellCls = cardCellClassOfCellIdentifier(identifier);
        if (cellCls) {
            [self.collectionView registerClass:[cellCls class] forCellWithReuseIdentifier:identifier];
        }
    }
}

- (void)registerSectionHeaderFooter {
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:TMCardComponentCollectionElementKindSectionHeader withReuseIdentifier:TMCardComponentBaseListViewSectionHeaderIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:TMCardComponentCollectionElementKindSectionFooter withReuseIdentifier:TMCardComponentBaseListViewSectionFooterIdentifier];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - public api
- (void)reloadData {
    [self.collectionView reloadData];
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        if (self) {
            [self callBackVisibleIndexPathsWhenScrollDidEndIfNeed];
        }
    });
}

- (void)insertItemsWithBlock:(NSArray<NSIndexPath *> *(^)(void))dataInsertBlock  {
    NSAssert(dataInsertBlock, @"dataInsertBlock can not be nil");
    
    NSArray<NSIndexPath*> *insertIndexPaths = dataInsertBlock();
    if (insertIndexPaths.count > 0) {
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:insertIndexPaths];
        } completion:^(BOOL finished) {
            [self.collectionView reloadData];
        }];
    }
}

- (void)deleteItemsWithBlock:(NSArray<NSIndexPath *> *(^)(void))dataDeleteBlock  {
    NSAssert(dataDeleteBlock, @"dataDeleteBlock can not be nil");
    
    NSArray<NSIndexPath*> *deleteIndexPaths = dataDeleteBlock();
    if (deleteIndexPaths.count > 0) {
        [self.collectionView performBatchUpdates:^{
            [self.collectionView deleteItemsAtIndexPaths:deleteIndexPaths];
        } completion:^(BOOL finished) {
            [self.collectionView reloadData];
        }];
    }
}

- (void)updateItemsWithBlock:(void(^)(NSMutableArray<NSIndexPath *> *toAddIndexPaths, NSMutableArray<NSIndexPath *> *toDeleteIndexPaths))updateBlock {
    NSMutableArray *toAddIndexPaths = [NSMutableArray array];
    NSMutableArray *toDeleteIndexPaths = [NSMutableArray array];
    if (updateBlock) {
        updateBlock(toAddIndexPaths, toDeleteIndexPaths);
        if (toAddIndexPaths.count > 0 ||
            toDeleteIndexPaths.count > 0) {
            
            [self.collectionView performBatchUpdates:^{
                if (toAddIndexPaths.count > 0) {
                    [self.collectionView insertItemsAtIndexPaths:toAddIndexPaths];
                }
                if (toDeleteIndexPaths.count > 0) {
                    NSInteger number = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
                    if (number) {
                        [self.collectionView deleteItemsAtIndexPaths:toDeleteIndexPaths];
                    }
                    else {
                        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:0]];
                    }
                }
            } completion:^(BOOL finished) {
                [self.collectionView reloadData];
            }];
        }
    }
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (NSArray<NSIndexPath *> *)visibleIndexPaths {
    return [self.collectionView indexPathsForVisibleItems];
}

- (void)registCustomCells:(void(^)(UICollectionView *collectionView))registCustomCellBlock {
    if (registCustomCellBlock) {
        registCustomCellBlock(self.collectionView);
    }
}

#pragma mark - private
- (void)bindReportDataToCell:(UICollectionViewCell *)cell data:(NSObject<TMCardComponentCellDataBasicProtocol> *)data indexPath:(NSIndexPath *)indexPath {
    NSString *widgetUid = nil;
    if (self.cellWidgetUidBlock) {
        widgetUid = self.cellWidgetUidBlock(self, indexPath, data);
    }
    NSDictionary *dic = nil;
    if (widgetUid) {
        if (self.cellReportDataBlock) {
            dic = self.cellReportDataBlock(self, indexPath, data);
        }
    }
    
//    cell.geWidgetUid = widgetUid;
//    cell.geResource = dic;
//
//    if (widgetUid.length > 0) {
//        if (![data exposeFlag]) {
//            GEWidgetExposeEvent *event = [GEWidgetExposeEvent eventWithWidget:cell superWidget:self.collectionView indexPath:indexPath];
//            [event setOnReportFinish:^{
//                [data setExposeFlag:YES];
//            }];
//            [self.collectionView registerSubview:cell forExposeEvent:event];
//        }
//    }
}

- (void)doClickReportIfNeedWithCell:(UICollectionViewCell *)cell data:(NSObject<TMCardComponentCellDataBasicProtocol> *)data indexPath:(NSIndexPath *)indexPath {
    //数据上报
//    if (cell.geWidgetUid.length > 0) {
//        [[GEWidgetClickEvent eventWithWidget:cell indexPath:indexPath] report];
//    }
}
     
#pragma mark - collectionview delegate & datasource & layoutdelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.numberOfSectionsBlock) {
        return self.numberOfSectionsBlock(self);
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.numberOfItemsInSectionBlock) {
        return self.numberOfItemsInSectionBlock(self, section);
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section {
    if (self.columnsInSectionBlock) {
        return self.columnsInSectionBlock(self, section);
    }
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.InsetsOfSectionsBlock) {
        return self.InsetsOfSectionsBlock(self, section);
    }
    return self.layout.sectionInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section {
    if (self.sectionHeaderHeightBlock) {
        return self.sectionHeaderHeightBlock(self, section);
    }
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section {
    if (self.sectionFooterHeightBlock) {
        return self.sectionFooterHeightBlock(self, section);
    }
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.sectionFooterHeightBlock) {
        return self.minimumInteritemSpacingBlock(self,section);
    }
    return self.layout.minimumInteritemSpacing;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    UICollectionReusableView *view = nil;
    void (^fillBlock)(TMCardComponentBaseListView *, NSInteger , UICollectionReusableView *) = nil;
    
    if ([kind isEqualToString:TMCardComponentCollectionElementKindSectionHeader]) {
        identifier = TMCardComponentBaseListViewSectionHeaderIdentifier;
        fillBlock = self.sectionHeaderViewBlock;
    }else if ([kind isEqualToString:TMCardComponentCollectionElementKindSectionFooter]) {
        identifier = TMCardComponentBaseListViewSectionFooterIdentifier;
        fillBlock = self.sectionFooterViewBlock;
    }
    
    if (identifier) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        if (fillBlock) {
            fillBlock(self, indexPath.section, view);
        }
    }
    
    if (!view) {
        view = [[UICollectionReusableView alloc] init];
    }
    
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(CHTCollectionViewWaterfallLayout*)layout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSObject<TMCardComponentCellDataBasicProtocol> *data = [self dataAtIndexPath:indexPath];
    return data ? data.layout_cellSize : CGSizeZero;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell<TMCardComponentCellProtocol> *cell = nil;
    NSObject<TMCardComponentCellDataBasicProtocol> *data = [self dataAtIndexPath:indexPath];
    NSString *identifier = [self class].styleMapCellIdentifiers[@(data.style)];
    
    //超出当前版本支持style的数据显示为不支持的cell类型
    if (!identifier && data.style >= TMCardComponentCellStyleNotSupport) {
        identifier = [self class].styleMapCellIdentifiers[@(TMCardComponentCellStyleNotSupport)];
    }
    
    if (!identifier) {
        if (self.customCellIdentifierBlock) {
            identifier = self.customCellIdentifierBlock(self, indexPath, data);
        }
    }
    if (identifier) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    }
    
    if (cell) {
        // 绑定天眼埋点数据赋值及暴光处理逻辑
        [self bindReportDataToCell:cell data:data indexPath:indexPath];
        if ([cell conformsToProtocol:@protocol(TMCardComponentCellProtocol)]) {
            // 更新UI
            [cell updateUIElement:data];
        }else {
            if (self.fillCustomCellBlock) {
                self.fillCustomCellBlock(self, cell, indexPath, data);
            }
        }
        //extra custom cell ui elements in sub class
        if (self.extraAddUIElementsOnCellBlock) {
            self.extraAddUIElementsOnCellBlock(self, cell, indexPath, data);
        }
#if DEBUG
        if ([cell respondsToSelector:@selector(removeCellLongPressGestureWithVcClass:)]) {
            [cell performSelector:@selector(removeCellLongPressGestureWithVcClass:) withObject:[self.viewController class]];
        }
#endif
    }else {
        NSString *assertStr = [NSString stringWithFormat:@"cardComponent cell can not be nil. | style: %ld", (long)[data style]];
#if DEBUG
        NSAssert(cell, assertStr);
#endif
        
//        THKDebugLog(@"%@==| firstId:%@", assertStr, kUnNilStr([TRequestParameter sharedParameter].first_id));
        
        UICollectionViewCell *holderCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kExceptEmptyCell" forIndexPath:indexPath];
        cell = (id)holderCell;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
   willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self doApiExposeReportIfNeedWithCell:cell indexPath:indexPath];
    if (self.willDisplayCellAtIndexPathBlock) {
        self.willDisplayCellAtIndexPathBlock(cell, indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didEndDisplayCellAtIndexPathBlock) {
        self.didEndDisplayCellAtIndexPathBlock(cell, indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [self doApiClickReportIfNeedWithCell:cell indexPath:indexPath];
    
    NSObject<TMCardComponentCellDataBasicProtocol> *data = [self dataAtIndexPath:indexPath];
    //天眼点击上报
    [self doClickReportIfNeedWithCell:cell data:data indexPath:indexPath];
    //点击回调
    if (self.clickCellBlock) {
        self.clickCellBlock(self, cell, indexPath, data);
    }
}

#pragma mark - 8.8 增加特定的cell可执行后台接口可配置的暴光及点击处理 (不是天眼上报,8.8暂按通用处理逻辑设计，相关数据暂为本地拼接)
- (void)doApiExposeReportIfNeedWithCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSObject *cellData = [self dataAtIndexPath:indexPath];
    if (![cellData conformsToProtocol:@protocol(TMCardComponentCellDataProtocol)]) {
        return;
    }
    NSObject<TMCardComponentCellDataProtocol> *data = (NSObject<TMCardComponentCellDataProtocol> *)cellData;
    if (data.reportConfig.reportActions & TMCardComponentDataReportActionsExpose) {
        if (!data.reportConfig.exposeFlag &&
            data.reportConfig.exposeReportUrl.length > 0 &&
            data.reportConfig.reportData.count > 0) {
            data.reportConfig.exposeFlag = YES;
            @weakify(data);
            [self doApiReportWithJavaReqUrl:data.reportConfig.exposeReportUrl params:data.reportConfig.reportData resultBlock:^(THKResponse *resp, NSError *err) {
                @strongify(data);
                if (resp && resp.status != THKStatusSuccess) {
                    //上报失败，回置状态值，以便下次滑动显示时再次尝试上报
                    data.exposeFlag = NO;
                }
            }];
        }
    }
}

- (void)doApiClickReportIfNeedWithCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSObject *cellData = [self dataAtIndexPath:indexPath];
    if (![cellData conformsToProtocol:@protocol(TMCardComponentCellDataProtocol)]) {
        return;
    }
    NSObject<TMCardComponentCellDataProtocol> *data = (NSObject<TMCardComponentCellDataProtocol> *)cellData;
    if (data.reportConfig.reportActions & TMCardComponentDataReportActionsClick) {
        if (data.reportConfig.clickReportUrl.length > 0 &&
            data.reportConfig.reportData.count > 0) {
            [self doApiReportWithJavaReqUrl:data.reportConfig.clickReportUrl params:data.reportConfig.reportData resultBlock:nil];
        }
    }
}

- (void)doApiReportWithJavaReqUrl:(NSString *)javaReqUrl params:(NSDictionary *)params resultBlock:(void(^_Nullable)(THKResponse * _Nullable resp, NSError * _Nullable err))resultBlock {
    if (javaReqUrl.length > 0) {
        
        THKCommonJavaRequest *req = [[THKCommonJavaRequest alloc] init];
        req.common_requestUrl = javaReqUrl;
        req.common_httpMethod = THKHttpMethodPOST;
        req.common_parameters = params;
        
        @weakify(self);
        [[req.rac_requestSignal takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(THKCommonResponse *x) {
            @strongify(self);
            if (self && resultBlock) {
                resultBlock(x, nil);
            }
        } error:^(NSError * _Nullable error) {
            @strongify(self);
            if (self && resultBlock) {
                resultBlock(nil, error);
            }
        }];
        
    }else {
        if (resultBlock){
            resultBlock(nil, [NSError errorWithDomain:@"local.domain.err" code:-1 userInfo:nil]);
        }
    }
}

#pragma mark -
- (NSObject<TMCardComponentCellDataBasicProtocol> *)dataAtIndexPath:(NSIndexPath *)indexPath {
    NSObject<TMCardComponentCellDataBasicProtocol> *data = nil;
    if (self.dataAtIndexPathBlock) {
        data = self.dataAtIndexPathBlock(self, indexPath);
        if (!data) {//add by amby 做一个判空，否则下面会触发NSAssert
            return data;
        }
        if (CGSizeEqualToSize(CGSizeZero, data.layout_cellSize)) {
            if (data.style != TMCardComponentCellStyleCustom) {
                //非自定义样式才通用懒加载布局数据，若为自定义样式则外部需要主动赋值相关数据
                if ([data conformsToProtocol:@protocol(TMCardComponentCellDataProtocol)]) {
                    [TMCardComponentCellSizeTool loadCellSizeToCellDataIfNeed:(NSObject<TMCardComponentCellDataProtocol> *)data layout:self.layout];
                }else {
                    NSString *assertTip = [NSString stringWithFormat:@"not custom cell, card data must conformsToProtocol:TMCardComponentCellDataProtocol. => [%@]", NSStringFromClass(data.class)];
                    NSAssert(NO, assertTip);
                    //增加Log
//                    THKInfoLog(@"%@", assertTip);
                }
            }
        }
    }
    if (!data) {//add by amby 做一个判空，否则下面会触发NSAssert
        return data;
    }
    
    if (![data conformsToProtocol:@protocol(TMCardComponentCellDataBasicProtocol)]) {
        NSString *assertTip = [NSString stringWithFormat:@"card data must conformsToProtocol:TMCardComponentCellDataBasicProtocol. => [%@]", NSStringFromClass(data.class)];
        NSAssert(NO, assertTip);
        //增加Log
//        THKInfoLog(@"%@", assertTip);
    }
    
    return data;
}

#pragma mark - scrollview delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self callBackVisibleIndexPathsWhenScrollDidEndIfNeed];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self callBackVisibleIndexPathsWhenScrollDidEndIfNeed];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self callBackVisibleIndexPathsWhenScrollDidEndIfNeed];
}

- (void)callBackVisibleIndexPathsWhenScrollDidEndIfNeed {
    if (self.didEndScrollWithVisibleIndexPathsBlock) {
        NSArray<NSIndexPath *> *indexPaths = [self.collectionView indexPathsForVisibleItems];
        if (indexPaths.count > 0) {
            self.didEndScrollWithVisibleIndexPathsBlock(indexPaths);
        }
    }
}

#pragma mark - lazy load ui
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (TMCardComponentCollectionViewLayout *)layout {
    if (!_layout) {
        _layout = [TMCardComponentCollectionViewLayout cardsCollectionLayout];
    }
    return _layout;
}

- (UIScrollView *)scrollView {
    return self.collectionView;
}

- (void)setFloatingHeaderAtIndexPath:(BOOL (^)(NSIndexPath * _Nonnull))floatingHeaderAtIndexPath
{
    if (_floatingHeaderAtIndexPath != floatingHeaderAtIndexPath) {
        _floatingHeaderAtIndexPath = floatingHeaderAtIndexPath;
        
        self.layout.lockHeaderAtTopBlock = floatingHeaderAtIndexPath;
    }
}

#pragma mark - helps

static NSDictionary *static_styleMapCellIdentifiers = nil;

//        TMCardComponentCellStyleNormal,
//        TMCardComponentCellStyleOldTopicAndQa,
//        TMCardComponentCellStyleTitleAndSubTitle,
//        TMCardComponentCellStyleCompany,
//        TMCardComponentCellStyleDesignMaster,
//        TMCardComponentCellStyleLive,
//        TMCardComponentCellStyleTopic,
//        TMCardComponentCellStyleTitleAndSubTitleUpSideDown
//        TMCardComponentCellStyleQa,
//        TMCardComponentCellStyleVideoSets
//        TMCardComponentCellStyleNotSupport

/**卡片组件展示的样式关联cell的identifier，若为custom则返回nil需要外部自行处理*/
+ (NSDictionary<NSNumber *, TMBasicCardCellIdentifier *> *)styleMapCellIdentifiers {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                
        NSMutableDictionary *dic = @{}.mutableCopy;
        dic[@(TMCardComponentCellStyleNormal)]          =   kCardCellStyleNormalIdentifier;
        dic[@(TMCardComponentCellStyleOldTopicAndQa)]   =   kCardCellStyleOldTopicAndQaIdentifier;
        dic[@(TMCardComponentCellStyleTitleAndSubTitle)] =  kCardCellStyleTileSubTitleIdentifier;
        dic[@(TMCardComponentCellStyleCompany)]         =   kCardCellStyleCompanyIdentifier;
        dic[@(TMCardComponentCellStyleDesignMaster)]    =   kCardCellStyleDesignMasterIdentifier;
        //8.5 add
        dic[@(TMCardComponentCellStyleLive)]            =   kCardCellStyleLiveIdentifier;
        //8.6 modify and add
        dic[@(TMCardComponentCellStyleTopic)]           =   kCardCellStyleTopicIdentifier;
        dic[@(TMCardComponentCellStyleTitleAndSubTitleUpSideDown)]  =   kCardCellStyleTitleSubTitleUpSideDownIdentifier;
        dic[@(TMCardComponentCellStyleQa)]              =   kCardCellStyleQaIdentifier;
        //8.8 add
        dic[@(TMCardComponentCellStyleVideoSets)]       =   kCardCellStyleVideoSetsIdentifier;
        //8.9 add
        dic[@(TMCardComponentCellStyleRecommendTags)]       =   kCardCellStyleRecommendTagsIdentifier;
        
        // trail add
        dic[@(TMCardComponentCellStyleNotSupport)]      =   kCardCellStyleNotSupportIdentifier;
        //
        static_styleMapCellIdentifiers = dic.copy;
    });
    
    return static_styleMapCellIdentifiers;
}

static NSDictionary<NSString *, NSString *> *static_cellIdentifierMapCellClassStrings = nil;
+ (NSDictionary<NSString *, NSString *> *)cellIdentifierMapCellClassStrings {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                        
        NSMutableDictionary *dic = @{}.mutableCopy;
        dic[kCardCellStyleNormalIdentifier]          =   NSStringFromClass([TMCardComponentNormalStyleCell class]);
        dic[kCardCellStyleOldTopicAndQaIdentifier]   =   NSStringFromClass([TMCardComponentOldTopicAndQaStyleCell class]);
        dic[kCardCellStyleTileSubTitleIdentifier]    =   NSStringFromClass([TMCardComponentTitleAndSubTitleStyleCell class]);
        dic[kCardCellStyleCompanyIdentifier]         =   NSStringFromClass([TMCardComponentCompanyStyleCell class]);
        dic[kCardCellStyleDesignMasterIdentifier]    =   NSStringFromClass([TMCardComponentDesignMasterStyleCell class]);
        //8.5 add
        dic[kCardCellStyleLiveIdentifier]            =   NSStringFromClass([TMCardComponentLiveStyleCell class]);
        //8.6 modify and add
        dic[kCardCellStyleTopicIdentifier]           =   NSStringFromClass([TMCardComponentTopicStyleCell class]);
        dic[kCardCellStyleTitleSubTitleUpSideDownIdentifier]  =   NSStringFromClass([TMCardComponentTitleSubTitleUpSideDownStyleCell class]);
        dic[kCardCellStyleQaIdentifier]              =   NSStringFromClass([TMCardComponentQaStyleCell class]);
        //8.8 add
        dic[kCardCellStyleVideoSetsIdentifier]        =   NSStringFromClass([TMCardComponentVideoSetsCell class]);
        //8.9 add
        dic[kCardCellStyleRecommendTagsIdentifier]    =   NSStringFromClass([TMCardComponentRecommendTagsCell class]);
        
        //trail add
        dic[kCardCellStyleNotSupportIdentifier]      =   NSStringFromClass([TMCardComponentNotSupportCell class]);
        //
        static_cellIdentifierMapCellClassStrings = dic.copy;
    });
    
    return static_cellIdentifierMapCellClassStrings;
}

NS_INLINE Class cardCellClassOfCellIdentifier(TMBasicCardCellIdentifier *cellIdentifier) {
    NSString *clsStr = [TMCardComponentBaseListView cellIdentifierMapCellClassStrings][cellIdentifier];
    if (clsStr) {
        return NSClassFromString(clsStr);
    }
    
    return nil;
};

#pragma mark - 构建cell 、style相关映射关系的字典

+ (NSArray<TMBasicCardCellIdentifier *> *)allCellIdentifiers {
    return [[self cellIdentifierMapCellClassStrings] allKeys];
}

/**当style为custom时返回nil*/
+ (TMBasicCardCellIdentifier *_Nullable)cellIdentifierOfCellStyle:(TMCardComponentCellStyle)style {
    if (style == TMCardComponentCellStyleCustom) {
        return nil;
    }
    
    if (style >= TMCardComponentCellStyleNotSupport) {
        return [self styleMapCellIdentifiers][@(TMCardComponentCellStyleNotSupport)];
    }
    return [self styleMapCellIdentifiers][@(style)];
}

/**返回指定identifier串对应的卡片cell的class*/
+ (Class)cellClassOfCellIdentifier:(TMBasicCardCellIdentifier *)identifier {
    if (identifier.length > 0) {
        return cardCellClassOfCellIdentifier(identifier);
    }
    return nil;
}

@end
