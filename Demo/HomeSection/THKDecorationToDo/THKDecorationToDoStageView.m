//
//  THKDecorationToDoStageView.m
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKDecorationToDoStageView.h"

@interface THKDecorationToDoStageCell : UICollectionViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *numImgV;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) THKDecorationUpcomingModel *model;

@end

@implementation THKDecorationToDoStageCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.containerView];
    [self.contentView addSubview:self.numImgV];
    [self.containerView addSubview:self.titleLbl];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.numImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-9);
    }];
}

- (void)setModel:(THKDecorationUpcomingModel *)model{
    _model = model;
    
    self.titleLbl.text = model.stageName;
    self.numImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"dec_todo_%02ld_black",(long)self.indexPath.item + 1]];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (selected) {
        self.containerView.backgroundColor = UIColorMain;
        self.titleLbl.textColor = UIColorWhite;
        self.titleLbl.font = UIFontMedium(14);
        self.numImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"dec_todo_%02ld",(long)self.indexPath.item + 1]];
    }else{
        self.containerView.backgroundColor = UIColorWhite;
        self.titleLbl.textColor = UIColorPlaceholder;
        self.titleLbl.font = UIFont(14);
        self.numImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"dec_todo_%02ld_black",(long)self.indexPath.item + 1]];
    }
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = UIColorWhite;
        _containerView.cornerRadius = 12;
    }
    return _containerView;
}

- (UIImageView *)numImgV{
    if (!_numImgV) {
        _numImgV = [[UIImageView alloc] init];
    }
    return _numImgV;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.font = UIFont(14);
        _titleLbl.textColor = UIColorPlaceholder;
    }
    return _titleLbl;
}

@end

@interface THKDecorationToDoStageView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation THKDecorationToDoStageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectIndex = -1;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
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

- (void)setModel:(NSArray<THKDecorationUpcomingModel *> *)model{
    _model = model;
    
    [self.collectionView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.selectIndex = 0;
    });
    
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
    return CGSizeMake(92, 62);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    THKDecorationToDoStageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKDecorationToDoStageCell class])
                                                                           forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.model = self.model[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    !_tapItem?:_tapItem(indexPath.item);
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
        _collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        [_collectionView registerClass:[THKDecorationToDoStageCell class]
            forCellWithReuseIdentifier:NSStringFromClass([THKDecorationToDoStageCell class])];
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
