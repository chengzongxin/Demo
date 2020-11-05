//
//  THKCompanyDetailBannerRollingView.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "THKCompanyDetailBannerRollingView.h"
#import "TDecDetailFirstModel.h"
#import "THKCompanyDetailBannerRollingCell.h"
@interface THKCompanyDetailBannerRollingView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewlayout;
@property (nonatomic, copy) NSArray <TDecDetailVideoModel *>*viewModel;
@end

@implementation THKCompanyDetailBannerRollingView
TMUI_PropertySyntheSize(viewModel);

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorRGBA(0, 0, 0, 0.4);
        self.layer.cornerRadius = 8;
        [self addSubview:self.collectionView];
        
    }
    return self;
}

- (void)bindViewModel{
    [self.collectionView reloadData];
}



#pragma mark - Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.frame.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THKCompanyDetailBannerRollingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKCompanyDetailBannerRollingCell class]) forIndexPath:indexPath];
        
//    cell.backgroundColor = [UIColor tmui_randomColor];
    return cell;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewlayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.scrollsToTop = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[THKCompanyDetailBannerRollingCell class] forCellWithReuseIdentifier:NSStringFromClass([THKCompanyDetailBannerRollingCell class])];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewlayout
{
    if (!_collectionViewlayout) {
        _collectionViewlayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionViewlayout.minimumInteritemSpacing = 0;
        _collectionViewlayout.minimumLineSpacing = 0;
        _collectionViewlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionViewlayout.itemSize = self.frame.size;
    }
    return _collectionViewlayout;
}

@end
