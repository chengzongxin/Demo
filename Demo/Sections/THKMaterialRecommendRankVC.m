//
//  THKMaterialRecommendRankVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialRecommendRankVC.h"
#import "THKMaterialClassificationViewCellLayout.h"
#import "THKMaterialClassificationViewCellHeader.h"
#import "THKMaterialClassificationViewCellFooter.h"
@interface THKMaterialRecommendRankVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) THKMaterialClassificationViewCellLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation THKMaterialRecommendRankVC

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


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        THKMaterialClassificationViewCellHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.imgView.image = UIImageMake(@"商品卡片头部");
        header.imgView.hidden = (indexPath.section == 0);
        return header;
        
    } else if (kind == UICollectionElementKindSectionFooter) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    }
    
    return nil;
}


// 子视图布局
- (void)thk_addSubviews{

}

// 绑定VM
- (void)bindViewModel {

}


#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 50;
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(50, 50, 50, 50);
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = floor((TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.layout.sectionInset) - 8*2)/3);
    if (indexPath.section == 0) {
        return CGSizeMake(width, 135);
    }else{
        return CGSizeMake(width, 190);
    }
}

#pragma mark - Private

#pragma mark - Getters and Setters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _layout = [[THKMaterialClassificationViewCellLayout alloc] init];
        _layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 80);
        _layout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 25);
        _layout.sectionInset = UIEdgeInsetsMake(0, 22, 0, 22);
        _layout.decorationInset = UIEdgeInsetsMake(0, 10, 0, 10);
        CGFloat width = floor((TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(_layout.sectionInset) - 8*2)/3);
        _layout.itemSize = CGSizeMake(width, 135);
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 8;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
        _collectionView.backgroundColor = UIColorHex(#F6F8F6);
        [self.view addSubview:_collectionView];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[THKMaterialClassificationViewCellHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [_collectionView registerClass:[THKMaterialClassificationViewCellFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    }
    return _collectionView;
}

#pragma mark - Supperclass

#pragma mark - NSObject

@end
