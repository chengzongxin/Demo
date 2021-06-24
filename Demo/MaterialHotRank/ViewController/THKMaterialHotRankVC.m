//
//  THKMaterialHotRankVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/22.
//

#import "THKMaterialHotRankVC.h"
#import "THKMaterialHotRankVM.h"
#import "THKMaterialClassificationRecommendCellLayout.h"
#import "THKMaterialHotRankHeader.h"
#import "THKMaterialClassificationRecommendRankCell.h"
#import "THKMaterialClassificationRecommendCellFooter.h"
#import <MJRefresh.h>
@interface THKMaterialHotRankVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) THKMaterialHotRankVM *viewModel;
@property (nonatomic, strong) THKMaterialClassificationRecommendCellLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *collectionViewHeader;

@end

@implementation THKMaterialHotRankVC
@dynamic viewModel;
#pragma mark - Lifecycle 


// 初始化
- (void)thk_initialize{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:UIImage.new];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
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
        THKMaterialHotListResponse *response = (THKMaterialHotListResponse *)x;
        return response.data;
    }];
    
    [self.viewModel addRefreshHeader];
    [self.viewModel addRefreshFooter];
}


#pragma mark - Public
// 点击头部更多
- (void)tapHeaderMore:(NSIndexPath *)indexPath{
    Log(indexPath);
}

// 点击cell
- (void)tapItem:(NSIndexPath *)indexPath{
    Log(indexPath);
}
#pragma mark - Event Respone

#pragma mark - Delegate
#pragma mark UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = floor((TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.layout.sectionInset) - 8*2)/3);
    return CGSizeMake(width, 135);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.data[section].brandList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THKMaterialHotBrandModel *model = self.viewModel.data[indexPath.section].brandList[indexPath.item];
    NSString *imgUrl = model.logoUrl;
    NSString *title = model.brandName;
    NSString *subtitle = @(model.score).stringValue;
    THKMaterialClassificationRecommendRankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendRankCell.class) forIndexPath:indexPath];
    cell.backgroundColor = UIColorHex(#F6F8F6);
    cell.rank = indexPath.item;
    cell.imgUrl = imgUrl;
    [cell setTitle:title subtitle:subtitle];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        NSString *title = self.viewModel.data[indexPath.section].categoryName;
        THKMaterialHotRankHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(THKMaterialHotRankHeader.class) forIndexPath:indexPath];
        [header setTitle:title];
        @TMUI_weakify(self);
        header.tapMoreBlock = ^{
            @TMUI_strongify(self);
            [self tapHeaderMore:indexPath];
        };
        return header;
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
        _layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 56);
        _layout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 25);
        _layout.sectionInset = UIEdgeInsetsMake(0, 22, 0, 22); // item 间距
        _layout.decorationInset = UIEdgeInsetsMake(0, 10, 0, 10); // decoration 间距
        _layout.decorationBottomMargin = 10;
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 8;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
        _collectionView.backgroundColor = UIColorHex(#DEEEFF);
        _collectionView.contentInset = UIEdgeInsetsMake(200, 0, 10, 0);
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_collectionView insertSubview:self.collectionViewHeader atIndex:0];
        [self.view addSubview:_collectionView];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        // 排行榜header
        [_collectionView registerClass:THKMaterialHotRankHeader.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(THKMaterialHotRankHeader.class)];
        // 通用footer
        [_collectionView registerClass:THKMaterialClassificationRecommendCellFooter.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendCellFooter.class)];
        // 排行榜cell
        [_collectionView tmui_registerNibIdentifierNSStringFromClass:THKMaterialClassificationRecommendRankCell.class];
    }
    return _collectionView;
}


- (UIView *)collectionViewHeader{
    if (!_collectionViewHeader) {
        // 背景
        UIImage *img = UIImageMake(@"热门排行榜-背景");
        CGFloat height = self.view.width/img.size.width*img.size.height;
        _collectionViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, -200, self.view.width, height)];
        UIImageView *bgImgV = [[UIImageView alloc] initWithFrame:_collectionViewHeader.bounds];
        bgImgV.image = img;
        [_collectionViewHeader addSubview:bgImgV];
        _collectionViewHeader.layer.zPosition = -1;
        // 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = UIColorHex(#2D76CF);
        titleLabel.font = UIFontSemibold(32);
        titleLabel.text = @"热门排行榜";
        [_collectionViewHeader addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(110);
            make.left.mas_equalTo(30);
        }];
        // 皇冠图标
        UIImageView *crownIcon = [[UIImageView alloc] initWithImage:UIImageMake(@"皇冠")];
        [_collectionViewHeader addSubview:crownIcon];
        [crownIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(80);
            make.right.mas_equalTo(-18);
        }];
        
        _collectionViewHeader.userInteractionEnabled = NO;
    }
    return _collectionViewHeader;
}

#pragma mark - Supperclass

#pragma mark - NSObject

@end
