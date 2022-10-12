//
//  THKCalculateQuotationSelectButtonView.m
//  Demo
//
//  Created by 程宗鑫 on 2022/10/12.
//

#import "THKCalculateQuotationSelectButtonView.h"

#define kCalQuaSelectFont UIFontSemibold(15)


@interface THKCalculateQuotationSelectButtonCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *textLbl;

@property (nonatomic, strong) UIButton *iconBtn;

@end

@implementation THKCalculateQuotationSelectButtonCell

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self thk_setupView];
    }
    return self;
}

- (void)thk_setupView {
    self.contentView.cornerRadius = 8;
    self.contentView.backgroundColor = UIColorBackgroundLight;
    [self.contentView addSubview:self.textLbl];
    [self.contentView addSubview:self.iconBtn];
    self.iconBtn.hidden = YES;
    
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (selected) {
        self.textLbl.textColor = UIColorDark;
        self.textLbl.font = kCalQuaSelectFont;
        self.contentView.backgroundColor = UIColorWhite;
        self.textLbl.borderColor = UIColorGreen;
        self.textLbl.borderWidth = 1.5;
        self.iconBtn.hidden = NO;
    }else{
        self.textLbl.textColor = UIColorDark;
        self.textLbl.font = UIFont(15);
        self.contentView.backgroundColor = UIColorBackgroundLight;
        self.textLbl.borderColor = UIColorClear;
        self.textLbl.borderWidth = 0;
        self.iconBtn.hidden = YES;
    }
}

- (UILabel *)textLbl{
    if (!_textLbl) {
        _textLbl = [[UILabel alloc] init];
        _textLbl.textAlignment = NSTextAlignmentCenter;
        _textLbl.font = UIFont(15);
        _textLbl.textColor = UIColorDark;
        _textLbl.font = kCalQuaSelectFont;
        _textLbl.layer.cornerRadius = 8;
        _textLbl.layer.masksToBounds = YES;
    }
    return _textLbl;
}

- (UIButton *)iconBtn{
    if (!_iconBtn) {
        _iconBtn = [UIButton tmui_button];
        _iconBtn.backgroundColor = UIColorGreen;
        _iconBtn.tmui_image = UIImageMake(@"cal_quota_select");
    }
    return _iconBtn;
}

@end

@interface THKCalculateQuotationSelectButtonView ()<UICollectionViewDataSource,UICollectionViewDelegate>

//@property (nonatomic, strong) THKQuickCommentsViewModel *viewModel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;


@end

@implementation THKCalculateQuotationSelectButtonView
@dynamic viewModel;



- (void)thk_setupViews{
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setDatas:(NSArray *)datas{
    _datas = datas;
    
    [self.collectionView reloadData];
    
    [self layoutIfNeeded];
    
    if (self.collectionView.numberOfSections > 0 && [self.collectionView numberOfItemsInSection:0] > 0) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (void)bindViewModel{
    // 重设外部约束
    
    [self.collectionView reloadData];
}
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *comment = self.datas[indexPath.item];
    CGFloat width = [comment tmui_widthForFont:kCalQuaSelectFont] + 28 * 2;
    return CGSizeMake(width, 36);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THKCalculateQuotationSelectButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKCalculateQuotationSelectButtonCell class])
                                                                           forIndexPath:indexPath];
    NSString *comment = self.datas[indexPath.item];
    cell.textLbl.text = comment;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *comment = self.datas[indexPath.item];
    !_tapItem?:_tapItem(comment);
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
        [_collectionView registerClass:[THKCalculateQuotationSelectButtonCell class]
            forCellWithReuseIdentifier:NSStringFromClass([THKCalculateQuotationSelectButtonCell class])];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumInteritemSpacing = 10;
        _flowLayout.minimumLineSpacing = 10;
    }
    return _flowLayout;
}


@end
