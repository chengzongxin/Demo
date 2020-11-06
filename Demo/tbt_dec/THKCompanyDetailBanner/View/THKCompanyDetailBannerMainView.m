//
//  THKCompanyDetailBannerMainView.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "THKCompanyDetailBannerMainView.h"
#import "THKCompanyDetailBannerVideoCell.h"
#import "THKCompanyDetailBannerImageCell.h"
#import "THKCompanyDetailBannerCellProtocol.h"
#import "TDecDetailFirstModel.h"

@interface THKCompanyDetailBannerMainView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewlayout;
@property (nonatomic, copy) NSArray <TDecDetailVideoModel *>*viewModel;

@end


@implementation THKCompanyDetailBannerMainView
TMUI_PropertySyntheSize(viewModel);

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        
    }
    return self;
}

- (void)bindViewModel{
    [self.collectionView reloadData];
    
    _tapItemSubject = [RACSubject subject];
//    @weakify(self);
//    [[RACSignal rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:)] subscribeNext:^(RACTuple * _Nullable x) {
//        @strongify(self);
//        [self.tapItemSubject sendNext:x];
//    }];
}

#pragma mark - Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.frame.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell <THKCompanyDetailBannerCellProtocol>*cell;
    
    TDecDetailVideoModel *model = self.viewModel[indexPath.item];
    
    
    if (model.videoUrl.length) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKCompanyDetailBannerVideoCell class]) forIndexPath:indexPath];
        cell.url = model.videoUrl;
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKCompanyDetailBannerImageCell class]) forIndexPath:indexPath];
        cell.url = model.imgUrl;
    }
    
    NSLog(@"cell.url = %@",cell.url);
    cell.backgroundColor = [UIColor tmui_randomColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewlayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.scrollsToTop = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = NO; // 不允许上下滚动
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[THKCompanyDetailBannerVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([THKCompanyDetailBannerVideoCell class])];
        [_collectionView registerClass:[THKCompanyDetailBannerImageCell class] forCellWithReuseIdentifier:NSStringFromClass([THKCompanyDetailBannerImageCell class])];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewlayout
{
    if (!_collectionViewlayout) {
        _collectionViewlayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionViewlayout.minimumInteritemSpacing = 0;
        _collectionViewlayout.minimumLineSpacing = 0;
        _collectionViewlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionViewlayout.itemSize = self.frame.size;
    }
    return _collectionViewlayout;
}

@end
