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
#import "TCaseDetailTopBar.h"
#import "THKProjectUIConfig.h"

#define kHeaderViewHeight       200
#define kSectionHeaderHeight    56

@interface THKMaterialHotRankVC (Godeye)
/// 埋点 appPageCycle
- (void)appPageCycleReport;
/// cell 曝光
- (void)cellShowReport:(UICollectionViewCell *)cell model:(NSObject *)model indexPath:(NSIndexPath *)indexPath;
/// cell点击
- (void)cellClickReport:(UICollectionViewCell *)cell model:(NSObject *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface THKMaterialHotRankVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) THKMaterialHotRankVM *viewModel;
@property (nonatomic, strong) THKMaterialClassificationRecommendCellLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *collectionViewHeader;
@property (nonatomic, strong) TCaseDetailTopBar *topBar;
@end

@implementation THKMaterialHotRankVC
@dynamic viewModel;
#pragma mark - Lifecycle


// 初始化
- (void)thk_initialize{
    [self appPageCycleReport];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:UIImage.new];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//}

// 渲染VC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    // 导航栏在最顶层
    [self configNavigationBar];
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
    
    [self.viewModel.requestCommand execute:@1];
}


#pragma mark - Public
// 点击头部更多
- (void)tapHeaderMore:(NSIndexPath *)indexPath{
    [self tapSection:indexPath];
}

// 点击cell
- (void)tapItem:(NSIndexPath *)indexPath{
    [self tapSection:indexPath];
}

- (void)tapSection:(NSIndexPath *)indexPath{
    NSInteger categoryId = self.viewModel.data[indexPath.section].categoryId;
    TRouter *router = [TRouter routerWithName:THKRouterPage_SelectMaterialBrandRank
                                        param:@{@"subCategoryId" : @(categoryId)}
                               jumpController:nil];
    [[TRouterManager sharedManager] performRouter:router];
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
    NSString *imgUrl = model.headUrl;
    NSString *title = model.brandName;
    NSString *subtitle = @(model.score).stringValue;
    THKMaterialClassificationRecommendRankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendRankCell.class) forIndexPath:indexPath];
    cell.backgroundColor = UIColorHex(#F6F8F6);
    cell.rank = indexPath.item;
    cell.imgUrl = imgUrl;
    [cell setTitle:title subtitle:subtitle];
    
    // 曝光
    [self cellShowReport:cell model:self.viewModel.data indexPath:indexPath];
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
    
    // 点击
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self cellClickReport:cell model:self.viewModel.data indexPath:indexPath];
}

#pragma mark - scrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat coverH = kHeaderViewHeight - tmui_navigationBarHeight();
        CGFloat moveH = offsetY + scrollView.contentInset.top;
        
        if (moveH > coverH) {
            float titlePercent = 1;
            [self.topBar setNavigationBarColor:[UIColor whiteColor] originTintColor:[UIColor whiteColor] toTintColor:THKColor_222222 gradientPercent:titlePercent];
            self.topBar.contentSubView.hidden = NO;
        }else {
            float percent = moveH / coverH;
            [self.topBar setNavigationBarColor:[UIColor whiteColor] originTintColor:[UIColor whiteColor] toTintColor:THKColor_222222 gradientPercent:percent];
            self.topBar.contentSubView.hidden = YES;
        }
    }
}


#pragma mark - Private

- (void)configNavigationBar {
    
    self.navBarHidden = YES;
    TCaseDetailTopBar * topBar = [TCaseDetailTopBar createInstance];
    self.topBar = topBar;
    topBar.hideShareBtn = YES;
    [self.view addSubview:topBar];
    [topBar configContent:^__kindof UIView *(UIView *contentView) {
        UILabel * titleLabel = [[UILabel alloc] init];
        [contentView addSubview:titleLabel];
        titleLabel.textColor = [THKProjectUIConfig navigationBarTitleColor_white];
        titleLabel.font = [THKProjectUIConfig navigationBarTitleFont];
        titleLabel.hidden = YES;
        titleLabel.text = @"热门排行榜";
        titleLabel.tag = 888;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
            make.centerY.equalTo(contentView);
            make.leading.greaterThanOrEqualTo(contentView.mas_leading);
            make.trailing.lessThanOrEqualTo(contentView.mas_trailing);
        }];
        return titleLabel;
    }];
    
    [topBar setNavigationBarColor:[UIColor clearColor] originTintColor:UIColor.whiteColor toTintColor:UIColor.whiteColor gradientPercent:1];
}

#pragma mark - Getters and Setters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _layout = [[THKMaterialClassificationRecommendCellLayout alloc] init];
        _layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, kSectionHeaderHeight);
        _layout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 25);
        _layout.sectionInset = UIEdgeInsetsMake(0, 22, 0, 22); // item 间距
        _layout.decorationInset = UIEdgeInsetsMake(0, 10, 10, 10); // decoration 间距
//        _layout.decorationBottomMargin = 10;
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 8;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
        _collectionView.backgroundColor = UIColorHex(#DEEEFF);
        _collectionView.contentInset = UIEdgeInsetsMake(kHeaderViewHeight, 0, 10, 0);
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
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
        UIImage *img = UIImageMake(@"bg_hot_list");
        CGFloat height = self.view.width/img.size.width*img.size.height;
        _collectionViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, -kHeaderViewHeight, self.view.width, height)];
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
            make.top.mas_equalTo(121);
            make.left.mas_equalTo(30);
        }];
        // 皇冠图标
        UIImageView *crownIcon = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_materialHome_crown")];
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
+ (BOOL)canHandleRouter:(TRouter *)router {
    if ([router routerMatch:THKRouterPage_SelectMaterialHotRank]) {
        return YES;
    }
    return NO;
}

+ (id)createVCWithRouter:(TRouter *)router {
    THKMaterialHotRankVM *vm = [[THKMaterialHotRankVM alloc] init];
    THKMaterialHotRankVC *vc = [[THKMaterialHotRankVC alloc] initWithViewModel:vm];
    return vc;
}

@end


@implementation THKMaterialHotRankVC (Godeye)


/// 埋点 appPageCycle
- (void)appPageCycleReport{
//    self.gePageLevelPath = @"如何选材|热门榜单页|";
//    self.gePageName = @"热门榜单页";
}

- (void)cellShowReport:(UICollectionViewCell *)cell model:(NSArray <THKMaterialHotListModel *> *)model indexPath:(NSIndexPath *)indexPath{
    THKMaterialHotListModel *section = model[indexPath.section];
    THKMaterialHotBrandModel *item = section.brandList[indexPath.item];
    if (item.isExposed) {
        return;
    }
    item.isExposed = YES;
//    GEWidgetResource *resource = [GEWidgetResource resourceWithWidget:cell];
//    [resource addEntries:@{@"widget_title":item.brandName?:@"",
//                           @"widget_uid":@"hot_top_list",
//                           @"widget_index":@(indexPath.section),
//                           @"widget_class":section.categoryName?:@"",
//    }];
//    [[GEWidgetExposeEvent eventWithResource:resource] report];
}

- (void)cellClickReport:(UICollectionViewCell *)cell model:(NSArray <THKMaterialHotListModel *> *)model indexPath:(NSIndexPath *)indexPath{
    THKMaterialHotListModel *section = model[indexPath.section];
    THKMaterialHotBrandModel *item = section.brandList[indexPath.item];
//    GEWidgetResource *resource = [GEWidgetResource resourceWithWidget:cell];
//    [resource addEntries:@{@"widget_title":item.brandName?:@"",
//                           @"widget_uid":@"hot_top_list",
//                           @"widget_index":@(indexPath.section),
//                           @"widget_class":section.categoryName?:@"",
//    }];
//    [[GEWidgetClickEvent eventWithResource:resource] report];
}


@end
