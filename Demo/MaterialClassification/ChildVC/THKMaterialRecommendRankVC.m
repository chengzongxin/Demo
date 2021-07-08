//
//  THKMaterialRecommendRankVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialRecommendRankVC.h"
#import "THKMaterialRecommendRankVM.h"
#import "THKMaterialClassificationRecommendCellLayout.h"
#import "THKMaterialClassificationRecommendRankHeader.h"
#import "THKMaterialClassificationRecommendNormalHeader.h"
#import "THKMaterialClassificationRecommendCellFooter.h"
#import "THKMaterialClassificationRecommendRankCell.h"
#import "THKMaterialClassificationRecommendNormalCell.h"
#import "THKMaterialClassificationVC.h"
#import "GECommonEventTracker.h"

@interface THKMaterialRecommendRankVC (Godeye)
/// header 曝光
- (void)brandHeaderExposeReport:(THKMaterialRecommendRankBrandList *)model indexPath:(NSIndexPath *)indexPath;
/// header 点击
- (void)brandHeaderClickReport:(THKMaterialRecommendRankBrandList *)model indexPath:(NSIndexPath *)indexPath;
/// header 曝光
- (void)goodsHeaderExposeReport:(THKMaterialRecommendRankGoodsRankListGoodsList *)model indexPath:(NSIndexPath *)indexPath;
/// header 点击
- (void)goodsHeaderClickReport:(THKMaterialRecommendRankGoodsRankListGoodsList *)model indexPath:(NSIndexPath *)indexPath;

@end


@interface THKMaterialRecommendRankVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,THKMaterialClassificationRecommendCellLayoutDecorationDelegate>

@property (nonatomic, strong) THKMaterialRecommendRankVM *viewModel;
@property (nonatomic, strong) THKMaterialClassificationRecommendCellLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL needExposeVisibleCell;

@end

@implementation THKMaterialRecommendRankVC
@dynamic viewModel;
#pragma mark - Lifecycle 

// 初始化
- (void)thk_initialize{
    self.gePageLevelPath = @"如何选材|主分类详情页|";
    self.gePageName = @"推荐榜单页";
}

// 渲染VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
}


// 子视图布局
- (void)thk_addSubviews{

}

// 绑定VM
- (void)bindViewModel {
    [self.viewModel bindWithView:self.view scrollView:self.collectionView appenBlock:^NSArray * _Nonnull(THKResponse * _Nonnull x) {
        THKMaterialRecommendRankResponse *response = (THKMaterialRecommendRankResponse *)x;
        NSMutableArray *datas = [NSMutableArray array];
        if (response.data.brandList.count) {
            // 热度榜
            [datas addObject:response.data.brandList];
        }
        for (THKMaterialRecommendRankGoodsRankList *list in response.data.goodsRankList) {
            // 推荐商品,数据传给子model
            for (THKMaterialRecommendRankGoodsRankListGoodsList *listItem in list.goodsList) {
                listItem.listId = list.listId;
                listItem.name = list.name;
            }
            
            [datas addObject:list.goodsList];
        }
        return datas;
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 修复埋点上报
    if (self.needExposeVisibleCell) {
        [self.collectionView reloadData];
        self.needExposeVisibleCell = NO;
    }
}

#pragma mark - Public
- (void)childViewControllerBeginRefreshingWithPara:(NSDictionary *)para{
    NSLog(@"childvc %@",para);
    NSInteger subCategoryId = [para[@"categoryId"] integerValue];;
    NSString *categoryName = para[@"categoryName"];
    if (subCategoryId != self.viewModel.subCategoryId) {
        self.viewModel.subCategoryId = subCategoryId;
        self.viewModel.categoryName = categoryName;
        [self.viewModel.requestCommand execute:@1];
    }
}

#pragma mark - Event Respone
// 点击头部更多
- (void)tapHeaderMore:(NSIndexPath *)indexPath{
    NSArray *data = self.viewModel.data[indexPath.section];
    if ([data.firstObject isKindOfClass:THKMaterialRecommendRankBrandList.class]) {
//        THKBrandRankingViewController 品牌
        
        THKMaterialRecommendRankBrandList *brand = data.firstObject;
        
        TRouter *router = [TRouter routerWithName:THKRouterPage_SelectMaterialBrandRank
                                            param:@{@"subCategoryId" : @(self.viewModel.subCategoryId)}
                                   jumpController:nil];
        [[TRouterManager sharedManager] performRouter:router];
        
        // 点击
        [self brandHeaderClickReport:brand indexPath:indexPath];
        
    }else if ([data.firstObject isKindOfClass:THKMaterialRecommendRankGoodsRankListGoodsList.class]) {
//        THKCommodityRankingViewController 商品
        
        THKMaterialRecommendRankGoodsRankListGoodsList *goods = data.firstObject;
        
        TRouter *router = [TRouter routerWithName:THKRouterPage_SelectMaterialCommodityRank
                                            param:@{@"subCategoryId" : @(self.viewModel.subCategoryId),@"listId":@(goods.listId)}
                                   jumpController:nil];
        [[TRouterManager sharedManager] performRouter:router];
        
        // 点击
        [self goodsHeaderClickReport:goods indexPath:indexPath];
    }
}

// 点击cell
- (void)tapItem:(NSIndexPath *)indexPath{
    [self tapHeaderMore:indexPath];
}

#pragma mark - Delegate
#pragma mark  UICollectionViewDataSource

- (BOOL)isFullDecorationAtIndexPath:(NSIndexPath *)indexPath{
    return [self isRankCell:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = floor((TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.layout.sectionInset) - 8*2)/3);
    NSArray *data = self.viewModel.data[indexPath.section];
    
    if ([data.firstObject isKindOfClass:THKMaterialRecommendRankBrandList.class]) {
        return CGSizeMake(width, 135);
    }else if ([data.firstObject isKindOfClass:THKMaterialRecommendRankGoodsRankListGoodsList.class]) {
        CGFloat titleH = [self head3DataHeight:indexPath width:width];
        return CGSizeMake(width, 15 + width + 8 + titleH + 5 + 14);
    }
    return CGSizeZero;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *data = self.viewModel.data[section];
    if ([data isKindOfClass:NSArray.class]) {
        return MIN(3, data.count);
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *data = self.viewModel.data[indexPath.section];
    
    if ([data.firstObject isKindOfClass:THKMaterialRecommendRankBrandList.class]) {
        // 热度榜
        NSArray <THKMaterialRecommendRankBrandList *> *brandList = data;
        THKMaterialRecommendRankBrandList *brand = brandList[indexPath.item];
        
        THKMaterialClassificationRecommendRankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendRankCell.class) forIndexPath:indexPath];
        cell.rank = indexPath.item;
        cell.imgUrl = brand.headUrl;
        [cell setTitle:brand.brandName subtitle:brand.score];
        return cell;
    }else if ([data.firstObject isKindOfClass:THKMaterialRecommendRankGoodsRankListGoodsList.class]) {
        // 品牌榜
        NSArray <THKMaterialRecommendRankGoodsRankListGoodsList *> *goodsList = data;
        THKMaterialRecommendRankGoodsRankListGoodsList *goods = goodsList[indexPath.item];
        THKMaterialClassificationRecommendNormalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendNormalCell.class) forIndexPath:indexPath];
        cell.rank = indexPath.item;
        cell.imgUrl = goods.cover;
        
        [cell setTitle:goods.cellTitle subtitle:goods.features];
        return cell;
    }else{
        return nil;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        NSArray *data = self.viewModel.data[indexPath.section];
        if ([data.firstObject isKindOfClass:THKMaterialRecommendRankBrandList.class]) {
            THKMaterialClassificationRecommendRankHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendRankHeader.class) forIndexPath:indexPath];
            
            NSArray <THKMaterialRecommendRankBrandList *> *brandList = data;
            THKMaterialRecommendRankBrandList *brand = brandList[indexPath.item];
            
            [header setTitle:[NSString stringWithFormat:@"%@品牌榜",self.viewModel.categoryName]];
            
            @TMUI_weakify(self);
            header.tapMoreBlock = ^{
                @TMUI_strongify(self);
                [self tapHeaderMore:indexPath];
            };
            
            // 曝光
            [self brandHeaderExposeReport:brand indexPath:indexPath];
            
            return header;
        }else if ([data.firstObject isKindOfClass:THKMaterialRecommendRankGoodsRankListGoodsList.class]) {
            THKMaterialClassificationRecommendNormalHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendNormalHeader.class) forIndexPath:indexPath];
            
            NSArray <THKMaterialRecommendRankGoodsRankListGoodsList *> *goodsList = data;
            THKMaterialRecommendRankGoodsRankListGoodsList *goods = goodsList[indexPath.item];
            
            [header setTitle:[NSString stringWithFormat:@"%@推荐榜",self.viewModel.categoryName] subtitle:goods.name];
            
            @TMUI_weakify(self);
            header.tapMoreBlock = ^{
                @TMUI_strongify(self);
                [self tapHeaderMore:indexPath];
            };

            // 曝光
            [self goodsHeaderExposeReport:goods indexPath:indexPath];
            
            return header;
        }
        
    } else if (kind == UICollectionElementKindSectionFooter) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendCellFooter.class) forIndexPath:indexPath];
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self tapItem:indexPath];
}

#pragma mark - Private
- (BOOL)isRankCell:(NSIndexPath *)indexPath{
    NSArray *data = self.viewModel.data[indexPath.section];
    return [data.firstObject isKindOfClass:THKMaterialRecommendRankBrandList.class];
}

- (BOOL)isGoodsCell:(NSIndexPath *)indexPath{
    NSArray *data = self.viewModel.data[indexPath.section];
    return [data.firstObject isKindOfClass:THKMaterialRecommendRankGoodsRankListGoodsList.class];
}

- (CGFloat)head3DataHeight:(NSIndexPath *)indexPath width:(CGFloat)width{
    NSArray *data = self.viewModel.data[indexPath.section];
    NSArray <THKMaterialRecommendRankGoodsRankListGoodsList *> *goodsList = data;
    if (goodsList.firstObject.titleH) {
        return goodsList.firstObject.titleH;
    }
//    THKMaterialRecommendRankGoodsRankListGoodsList *goods = goodsList[indexPath.item];
    __block CGFloat maxTitleH = 0;
    [goodsList enumerateObjectsUsingBlock:^(THKMaterialRecommendRankGoodsRankListGoodsList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < 3) {
            CGFloat titleH = [obj.cellTitle tmui_sizeForFont:UIFont(14) size:CGSizeMake(width, CGFLOAT_MAX) lineHeight:0 mode:NSLineBreakByWordWrapping].height;
            maxTitleH = MAX(maxTitleH, titleH);
        }
    }];
    maxTitleH = maxTitleH > 20 ? 40:20;
    goodsList.firstObject.titleH = maxTitleH;
    return maxTitleH;
}

#pragma mark - Getters and Setters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _layout = [[THKMaterialClassificationRecommendCellLayout alloc] init];
        _layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 80);
        _layout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 25);
        _layout.sectionInset = UIEdgeInsetsMake(0, 22, 0, 22); // item 间距
        _layout.decorationInset = UIEdgeInsetsMake(0, 10, 10, 10); // decoration 间距
//        _layout.decorationBottomMargin = 10;
//        _layout.firstDifferent = YES;
        _layout.delegate = self;
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 8;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
        _collectionView.backgroundColor = UIColorHex(#F6F8F6);
        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [self.view addSubview:_collectionView];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        // 排行榜header
        [_collectionView registerClass:THKMaterialClassificationRecommendRankHeader.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendRankHeader.class)];
        // 其他header
        [_collectionView registerClass:THKMaterialClassificationRecommendNormalHeader.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendNormalHeader.class)];
        // 通用footer
        [_collectionView registerClass:THKMaterialClassificationRecommendCellFooter.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendCellFooter.class)];
        // 排行榜cell
        [_collectionView tmui_registerNibIdentifierNSStringFromClass:THKMaterialClassificationRecommendRankCell.class];
        // 其他cell
        [_collectionView tmui_registerNibIdentifierNSStringFromClass:THKMaterialClassificationRecommendNormalCell.class];
    }
    return _collectionView;
}

#pragma mark - Supperclass

#pragma mark - NSObject

@end

@implementation THKMaterialRecommendRankVC (Godeye)

- (void)brandHeaderExposeReport:(THKMaterialRecommendRankBrandList *)model indexPath:(NSIndexPath *)indexPath{
    THKMaterialClassificationVC *parentVC =  (THKMaterialClassificationVC *)self.parentViewController;
    if (![parentVC isKindOfClass:THKMaterialClassificationVC.class] || parentVC.childVCs[parentVC.currentIndex] != self) {
        // 页面展示才曝光,来到这里说明页面已经加载了数据，但是没有显示，需要在下次进入此页面，重新上报
        self.needExposeVisibleCell = YES;
        return;
    }
    
    if (model.isExposed) {
        return;
    }
    model.isExposed = YES;
    [GECommonEventTracker reportEvent:kGEAppWidgetShow properties:({
        @{@"page_uid":self.gePageUid?:@"",
          @"widget_title":[NSString stringWithFormat:@"%@品牌榜",self.viewModel.categoryName],
          @"widget_uid":@"brand_top_btn",
        };
    })];
}

- (void)brandHeaderClickReport:(THKMaterialRecommendRankBrandList *)model indexPath:(NSIndexPath *)indexPath{
    [GECommonEventTracker reportEvent:kGEAppWidgetClick properties:({
        @{@"page_uid":self.gePageUid?:@"",
          @"widget_title":[NSString stringWithFormat:@"%@品牌榜",self.viewModel.categoryName],
          @"widget_uid":@"brand_top_btn",
        };
    })];
}

- (void)goodsHeaderExposeReport:(THKMaterialRecommendRankGoodsRankListGoodsList *)model indexPath:(NSIndexPath *)indexPath{
    THKMaterialClassificationVC *parentVC =  (THKMaterialClassificationVC *)self.parentViewController;
    if (![parentVC isKindOfClass:THKMaterialClassificationVC.class] || parentVC.childVCs[parentVC.currentIndex] != self) {
        // 页面展示才曝光
        return;
    }
    
    if (model.isExposed) {
        return;
    }
    model.isExposed = YES;
    [GECommonEventTracker reportEvent:kGEAppWidgetShow properties:({
        @{@"page_uid":self.gePageUid?:@"",
          @"widget_title":[NSString stringWithFormat:@"%@",model.name],
          @"widget_index":@(indexPath.section - 1),
          @"widget_uid":@"goods_top_btn",
        };
    })];
}

- (void)goodsHeaderClickReport:(THKMaterialRecommendRankGoodsRankListGoodsList *)model indexPath:(NSIndexPath *)indexPath{
    [GECommonEventTracker reportEvent:kGEAppWidgetClick properties:({
        @{@"page_uid":self.gePageUid?:@"",
          @"widget_title":[NSString stringWithFormat:@"%@",model.name],
          @"widget_index":@(indexPath.section - 1),
          @"widget_uid":@"goods_top_btn",
        };
    })];
}

@end
