//
//  THKDecPKSrcollView.m
//  Demo
//
//  Created by Joe.cheng on 2022/12/21.
//

#import "THKDecPKSrcollView.h"


@interface THKDecPKSrcollCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *iconImgV1;

@property (nonatomic, strong) UILabel *titleLbl1;

@property (nonatomic, strong) UIImageView *iconImgV2;

@property (nonatomic, strong) UILabel *titleLbl2;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) id model;

@end

@implementation THKDecPKSrcollCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.iconImgV1];
    [self.contentView addSubview:self.titleLbl1];
    [self.contentView addSubview:self.iconImgV2];
    [self.contentView addSubview:self.titleLbl2];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.iconImgV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(42);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [self.titleLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgV1.mas_bottom).offset(5);
        make.centerX.equalTo(self.iconImgV1);
    }];
    
    [self.iconImgV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.right.mas_equalTo(-32);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [self.titleLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgV2.mas_bottom).offset(5);
        make.centerX.equalTo(self.iconImgV2);
    }];
}

- (void)setModel:(id)model{
    _model = model;
    
//    self.titleLbl.text = model.stageName;
//    self.numImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"dec_todo_%02ld_black",(long)self.indexPath.item + 1]];
}

//- (void)setSelected:(BOOL)selected{
//    [super setSelected:selected];
//
//    if (selected) {
//        self.containerView.backgroundColor = UIColorGreen;
//        self.titleLbl.textColor = UIColorWhite;
//        self.titleLbl.font = UIFontMedium(14);
//        self.numImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"dec_todo_%02ld",(long)self.indexPath.item + 1]];
//    }else{
//        self.containerView.backgroundColor = UIColorWhite;
//        self.titleLbl.textColor = UIColorPlaceholder;
//        self.titleLbl.font = UIFont(14);
//        self.numImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"dec_todo_%02ld_black",(long)self.indexPath.item + 1]];
//    }
//}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"dec_pk_cell_bg"];
        _bgImageView.cornerRadius = 8;
    }
    return _bgImageView;
}

- (UIImageView *)iconImgV1{
    if (!_iconImgV1) {
        _iconImgV1 = [[UIImageView alloc] init];
        _iconImgV1.layer.cornerRadius = 24;
        _iconImgV1.layer.masksToBounds = YES;
    }
    return _iconImgV1;
}

- (UILabel *)titleLbl1{
    if (!_titleLbl1) {
        _titleLbl1 = [[UILabel alloc] init];
        _titleLbl1.textAlignment = NSTextAlignmentCenter;
        _titleLbl1.font = UIFont(14);
        _titleLbl1.textColor = UIColorPlaceholder;
    }
    return _titleLbl1;
}

- (UIImageView *)iconImgV2{
    if (!_iconImgV2) {
        _iconImgV2 = [[UIImageView alloc] init];
        _iconImgV2.layer.cornerRadius = 24;
        _iconImgV2.layer.masksToBounds = YES;
    }
    return _iconImgV2;
}

- (UILabel *)titleLbl2{
    if (!_titleLbl2) {
        _titleLbl2 = [[UILabel alloc] init];
        _titleLbl2.textAlignment = NSTextAlignmentCenter;
        _titleLbl2.font = UIFont(14);
        _titleLbl2.textColor = UIColorPlaceholder;
    }
    return _titleLbl2;
}
@end

@interface THKDecPKSrcollView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) NSInteger selectIndex;
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
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 0, 10, 0));
    }];
}


- (void)setModel:(NSArray *)model{
    _model = model;
    
    self.selectIndex = -1;
    
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
    return CGSizeMake(UIScreen.mainScreen.bounds.size.width - 36 - 46, 100);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    THKDecPKSrcollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKDecPKSrcollCell class])
                                                                           forIndexPath:indexPath];
//    cell.indexPath = indexPath;
//    cell.model = self.model[indexPath.item];
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
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 10;
    }
    return _flowLayout;
}
@end
