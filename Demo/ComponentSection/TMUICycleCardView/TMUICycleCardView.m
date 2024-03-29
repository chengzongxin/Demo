//
//  TMUICycleCardView.m
//  Demo
//
//  Created by Joe.cheng on 2022/5/16.
//

#import "TMUICycleCardView.h"
#import "TMUICycleCardViewLayout.h"
#import <TMUITimer.h>
@interface TMUICycleCardView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) TMUICycleCardViewLayout *layout;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) TMUITimer *timer;

@property (nonatomic, copy) TMUICycleCardViewConfigCellBlock configBlock;

@property (nonatomic, assign) Class cellClass;
@end

@implementation TMUICycleCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitalize];
    }
    return self;
}

- (void)didInitalize{
    self.autoScrollInterval = 2;
    self.horSpacing = 10;
    self.verSpacing = 4;
    [self addSubview:self.collectionView];
}

// 设置外部约束
- (CGSize)intrinsicContentSize{
    return [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize fitSize = [super sizeThatFits:size];
    return fitSize;
}

- (void)setHorSpacing:(CGFloat)horSpacing{
    _horSpacing = horSpacing;
    
    self.layout.horSpacing = horSpacing;
    
    [self.layout invalidateLayout];
}

- (void)setVerSpacing:(CGFloat)verSpacing{
    _verSpacing = verSpacing;
    
    self.layout.verSpacing = verSpacing;
    
    [self.layout invalidateLayout];
}


- (void)registerCell:(Class)cellClass{
    self.cellClass = cellClass;
    [self.collectionView registerClass:cellClass
          forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)configCell:(TMUICycleCardViewConfigCellBlock)configBlock{
    self.configBlock = configBlock;
}

- (void)setModels:(NSArray *)models{
    _models = models;
    
    _dataSource = [models mutableCopy];
    
    self.layout.count = _dataSource.count;
    
    [self.collectionView reloadData];
    
    if (self.dataSource.count > 1) {
        if (!self.timer) {
            @weakify(self);
            self.timer = [[TMUITimer alloc] initWithInterval:self.autoScrollInterval block:^{
                @strongify(self);
                [self scroll];
            }];
        }
    }else{
        [self pauseTimer];
    }
}

- (void)pauseTimer{
    if (self.timer) {
        [self.timer pauseTimer];
    }
}

- (void)resumeTimer{
    if (self.timer) {
        [self.timer resumeTimer];
    }
}

- (void)scroll{
    if (self && self.window) {
        [self scrollFirstCell];
    }
}

- (void)scrollFirstCell{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UIImage *img = [cell tmui_snapshotLayerImage];
    UIImageView *imgv = [[UIImageView alloc] initWithImage:img];
    imgv.frame = cell.frame;
    [self.collectionView addSubview:imgv];
    cell.alpha = 0;
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imgv.transform = CGAffineTransformMakeTranslation(-imgv.width, 0);
        //                cell.x = -cell.width;
    } completion:^(BOOL finished) {
        imgv.alpha = 0;
        [imgv removeFromSuperview];
    }];
    
    id model = self.dataSource.firstObject;
    [self.dataSource removeFirstObject];
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    
    [self.collectionView performBatchUpdates:^{
        [self.dataSource addObject:model];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.dataSource.count - 1 inSection:0]]];
    } completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.cellClass)
                                                                           forIndexPath:indexPath];
    if (self.configBlock) {
        self.configBlock(cell, indexPath, self.dataSource[indexPath.item]);
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Getter && Setter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    
    return _collectionView;
}

- (TMUICycleCardViewLayout *)layout {
    if (!_layout) {
        _layout = [[TMUICycleCardViewLayout alloc] init];
        _layout.horSpacing = self.horSpacing;
        _layout.verSpacing = self.verSpacing;
    }
    return _layout;
}


@end
