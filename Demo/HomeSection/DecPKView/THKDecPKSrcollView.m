//
//  THKDecPKSrcollView.m
//  Demo
//
//  Created by Joe.cheng on 2022/12/21.
//

#import "THKDecPKSrcollView.h"
#import "THKDecPKSrcollCell.h"

@interface THKDecPKSrcollView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

//@property (nonatomic, assign) NSInteger selectIndex;


//标记滑动前的页数
@property (nonatomic, assign) NSInteger draggingStartPage;

@end

@implementation THKDecPKSrcollView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


- (void)setModel:(NSArray *)model{
    _model = model;
    
    if (model.count == 0) {
        return;
    }
    
//    self.selectIndex = -1;
    
    [self.collectionView reloadData];
    
    
    if (self.didScrollToDecs) {
        self.didScrollToDecs(self.model.firstObject);
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.selectIndex = 0;
//
//    });
    
}

/// 若要显示第idx索引位置的卡片，需要设置的offset.x值
- (CGFloat)offsetXOfItemAtIndex:(NSInteger)idx {
    if (idx == 0) {
        return 0;
    }
    return self.flowLayout.sectionInset.left + (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing) * idx - self.flowLayout.minimumLineSpacing;
}
#pragma mark - ScrollViewDelegate

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset offsetPage:(NSInteger)offsetPage {
    NSInteger page = [self pageAt:offset.x] + offsetPage;
    if (self.model.count > 0) {
        page = MAX(page, 0);
        page = MIN(page, self.model.count - 1);
    }
    CGFloat targetX = [self offsetXOfItemAtIndex:page];
    targetX = MIN(targetX, self.collectionView.contentSize.width - self.collectionView.bounds.size.width);
    // 滑动到第一个或者最后一个额外增加contentInset的边距
    if (page == 0) {
        targetX -= self.collectionView.contentInset.left;
    }else if (page == [self.collectionView numberOfItemsInSection:0] - 1) {
        targetX += self.collectionView.contentInset.right;
    }
    return CGPointMake(targetX, offset.y);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset offsetPage:0];
    //将要滑到的页数
    NSInteger toPage = [self pageAt:targetOffset.x];
    //当‘将滑动的页数’没变，并且手指速度很快直接滑动旁边格子（否则会滑回原来位置发生抖动）
    if (velocity.x != 0 && fabs(velocity.x) < 1.5 && self.draggingStartPage == toPage) {
        targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset offsetPage:(velocity.x > 0 ? 1: -1)];
    }
    
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.draggingStartPage = [self pageAt:self.collectionView.contentOffset.x];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = [self pageAt:self.collectionView.contentOffset.x];
    if (self.model.count > 0) {
        page = MIN(page, self.model.count - 1);
    }
//    self.viewModel.callbackBlock(@(page));
    if (self.didScrollToDecs) {
        self.didScrollToDecs(self.model[page]);
    }
    
}

- (NSInteger)pageAt:(CGFloat)contentOffsetX {
    CGFloat pageWidth = self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing;
    return roundf((contentOffsetX - self.flowLayout.sectionInset.left) / pageWidth);
}


//- (void)setSelectIndex:(NSInteger)selectIndex{
//    if (_selectIndex == selectIndex) {
//        return;
//    }
//    _selectIndex = selectIndex;
//    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:selectIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
//}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.flowLayout.itemSize;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    THKDecPKSrcollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKDecPKSrcollCell class])
                                                                           forIndexPath:indexPath];
//    cell.indexPath = indexPath;
    cell.model = self.model[indexPath.item];
//    !_exposeItem?:_exposeItem(indexPath.item);
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    !_tapItem?:_tapItem(indexPath.item);
}

#pragma mark - Getter && Setter


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);
        [_collectionView registerClass:[THKDecPKSrcollCell class]
            forCellWithReuseIdentifier:NSStringFromClass([THKDecPKSrcollCell class])];
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width - 36 - 46, 100);
    }
    return _flowLayout;
}
@end
