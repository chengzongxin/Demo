//
//  THKGraphicDetailStageView.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import "THKGraphicDetailStageView.h"
#import "THKGraphicDetailStageCell.h"

@interface THKGraphicDetailStageView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation THKGraphicDetailStageView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self addSubview:self.effectView];
    [self addSubview:self.collectionView];
    
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 0, 10, 0));
    }];
}

//- (void)bindViewModel{
//    // 重设外部约束
//
//    [self invalidateIntrinsicContentSize];
//
//    [self.collectionView reloadData];
//}
//
//// 设置外部约束
//- (CGSize)intrinsicContentSize{
//    return [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//}
//
//- (CGSize)sizeThatFits:(CGSize)size{
//    CGSize fitSize = [super sizeThatFits:size];
//    return fitSize;
//}

- (void)setModel:(NSArray<THKGraphicDetailContentListItem *> *)model{
    _model = model;
    
    _selectIndex = 0;
    
    [self.collectionView reloadData];
    
    if (self.selectIndex < [self.collectionView numberOfItemsInSection:0]) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
    
}

- (void)setGradientPercent:(CGFloat)percent{
    self.effectView.alpha = percent;
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    if (_selectIndex == selectIndex) {
        return;
    }
    _selectIndex = selectIndex;
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:selectIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    THKGraphicDetailContentListItem *model = self.model[indexPath.item];
    CGFloat width = [model.anchor tmui_sizeWithFont:UIFont(14) width:CGFLOAT_MAX].width + 12 * 2;
    return CGSizeMake(width, 28);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    THKGraphicDetailStageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKGraphicDetailStageCell class])
                                                                           forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.model = self.model[indexPath.item];
    !_exposeItem?:_exposeItem(indexPath.item);
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    !_tapItem?:_tapItem(indexPath.item);
}

#pragma mark - Getter && Setter
- (UIVisualEffectView *)effectView{
    if (!_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectView.tmui_foregroundColor = UIColorHex(F6F8F6);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, 82)];
        [view tmui_gradientWithColors:@[UIColorHex(FFFFFF),[UIColorHex(F6F8F6) colorWithAlphaComponent:0]] gradientType:TMUIGradientTypeTopToBottom locations:@[@0.3]];
        [_effectView.contentView addSubview:view];
        _effectView.alpha = 0.0;
    }
    return _effectView;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        [_collectionView registerClass:[THKGraphicDetailStageCell class]
            forCellWithReuseIdentifier:NSStringFromClass([THKGraphicDetailStageCell class])];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 12;
    }
    return _flowLayout;
}

@end
