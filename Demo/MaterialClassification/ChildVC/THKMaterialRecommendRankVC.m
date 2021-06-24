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
    @weakify(self);
    [self.viewModel bindWithView:self.view scrollView:self.collectionView appenBlock:^NSArray * _Nonnull(THKResponse * _Nonnull x) {
        @strongify(self);
        THKMaterialHotListResponse *response = (THKMaterialHotListResponse *)x;
        return ([self.viewModel.requestCommand.inputValue integerValue] == 1) ? response.data : nil;
    }];
    
    [self.viewModel addRefreshFooter];
}


#pragma mark - Public

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
    return self.viewModel.headerTitles.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.titles[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *imgUrl = self.viewModel.icons[indexPath.section][indexPath.item];;
    NSString *title = self.viewModel.titles[indexPath.section][indexPath.item];
    NSString *subtitle = self.viewModel.subtitles[indexPath.section][indexPath.item];
    if (indexPath.section == 0) {
        THKMaterialClassificationRecommendRankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendRankCell.class) forIndexPath:indexPath];
        cell.rank = indexPath.item;
        cell.imgUrl = imgUrl;
        [cell setTitle:title subtitle:subtitle];
        return cell;
    }else{
        THKMaterialClassificationRecommendNormalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendNormalCell.class) forIndexPath:indexPath];
        cell.rank = indexPath.item;
        cell.imgUrl = imgUrl;
        [cell setTitle:title subtitle:subtitle];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        NSString *title = self.viewModel.headerTitles[indexPath.section].firstObject;
        NSString *subtitle = self.viewModel.headerTitles[indexPath.section].lastObject;
        if (indexPath.section == 0) {
            THKMaterialClassificationRecommendRankHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendRankHeader.class) forIndexPath:indexPath];
            [header setTitle:title];
            @TMUI_weakify(self);
            header.tapMoreBlock = ^{
                @TMUI_strongify(self);
                [self tapHeaderMore:indexPath];
            };
            return header;
        }else{
            THKMaterialClassificationRecommendNormalHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(THKMaterialClassificationRecommendNormalHeader.class) forIndexPath:indexPath];
            [header setTitle:title subtitle:subtitle];
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
