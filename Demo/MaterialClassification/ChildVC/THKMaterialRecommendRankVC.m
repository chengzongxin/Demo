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

@interface THKMaterialRecommendRankVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) THKMaterialRecommendRankVM *viewModel;
@property (nonatomic, strong) THKMaterialClassificationRecommendCellLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSString *categoryName;


@end

@implementation THKMaterialRecommendRankVC
@dynamic viewModel;
#pragma mark - Lifecycle 

// 初始化
- (void)thk_initialize{
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
            // 推荐商品
            list.goodsList.firstObject.listId = list.listId;
            list.goodsList.firstObject.name = list.name;
            [datas addObject:list.goodsList];
        }
        return datas;
    }];
}


#pragma mark - Public

#warning pageContentVC 需要更新
- (void)childViewControllerBeginRefreshingWithPara:(NSDictionary *)para{
    NSLog(@"childvc %@",para);
    self.viewModel.subCategoryId = [para[@"categoryId"] integerValue];
    self.categoryName = para[@"categoryName"];
    [self.viewModel.requestCommand execute:@1];
}

#pragma mark - Event Respone
// 点击头部更多
- (void)tapHeaderMore:(NSIndexPath *)indexPath{
    Log(indexPath);
}

// 点击cell
- (void)tapItem:(NSIndexPath *)indexPath{
    Log(indexPath);
}

#pragma mark - Delegate
#pragma mark  UICollectionViewDataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = floor((TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.layout.sectionInset) - 8*2)/3);
    if (indexPath.section == 0) {
        return CGSizeMake(width, 135);
    }else{
        return CGSizeMake(width, CGCustomFloat(190));
    }
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
        cell.imgUrl = brand.logoUrl;
        [cell setTitle:brand.brandName subtitle:brand.score];
        return cell;
    }else if ([data.firstObject isKindOfClass:THKMaterialRecommendRankGoodsRankListGoodsList.class]) {
        // 品牌榜
        NSArray <THKMaterialRecommendRankGoodsRankListGoodsList *> *goodsList = data;
        THKMaterialRecommendRankGoodsRankListGoodsList *goods = goodsList[indexPath.item];
        THKMaterialClassificationRecommendNormalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendNormalCell.class) forIndexPath:indexPath];
        cell.rank = indexPath.item;
        cell.imgUrl = goods.cover;
        [cell setTitle:goods.features subtitle:goods.recommendedReason];
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
            [header setTitle:[NSString stringWithFormat:@"%@品牌榜",self.categoryName]];
            @TMUI_weakify(self);
            header.tapMoreBlock = ^{
                @TMUI_strongify(self);
                [self tapHeaderMore:indexPath];
            };
            return header;
        }else if ([data.firstObject isKindOfClass:THKMaterialRecommendRankGoodsRankListGoodsList.class]) {
            THKMaterialClassificationRecommendNormalHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendNormalHeader.class) forIndexPath:indexPath];
            
            NSArray *data = self.viewModel.data[indexPath.section];
            NSArray <THKMaterialRecommendRankGoodsRankListGoodsList *> *goodsList = data;
            THKMaterialRecommendRankGoodsRankListGoodsList *goods = goodsList[indexPath.item];
            
            [header setTitle:[NSString stringWithFormat:@"%@推荐榜",self.categoryName] subtitle:goods.name];
                                                                  
            @TMUI_weakify(self);
            header.tapMoreBlock = ^{
                @TMUI_strongify(self);
                [self tapHeaderMore:indexPath];
            };
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

#pragma mark - Getters and Setters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _layout = [[THKMaterialClassificationRecommendCellLayout alloc] init];
        _layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 80);
        _layout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 25);
        _layout.sectionInset = UIEdgeInsetsMake(0, 22, 0, 22); // item 间距
        _layout.decorationInset = UIEdgeInsetsMake(0, 10, 0, 10); // decoration 间距
        _layout.decorationBottomMargin = 10;
        _layout.firstDifferent = YES;
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 8;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
        _collectionView.backgroundColor = UIColorHex(#F6F8F6);
        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
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
