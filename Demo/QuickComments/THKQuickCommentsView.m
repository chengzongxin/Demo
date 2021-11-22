//
//  THKQuickCommentsView.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/22.
//

#import "THKQuickCommentsView.h"

#define kQuickCommentsFont UIFont(10)

@interface THKQuickCommentsCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *textLbl;

@end

@implementation THKQuickCommentsCell

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self thk_setupView];
    }
    return self;
}

- (void)thk_setupView {
    [self.contentView addSubview:self.textLbl];
    
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UILabel *)textLbl{
    if (!_textLbl) {
        _textLbl = [[UILabel alloc] init];
        _textLbl.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        _textLbl.textAlignment = NSTextAlignmentCenter;
        _textLbl.textColor = UIColor.whiteColor;
        _textLbl.font = kQuickCommentsFont;
        _textLbl.layer.cornerRadius = 9;
        _textLbl.layer.masksToBounds = YES;
    }
    return _textLbl;
}

@end

@interface THKQuickCommentsView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) THKQuickCommentsViewModel *viewModel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation THKQuickCommentsView
@dynamic viewModel;

- (void)thk_setupViews{
    self.backgroundColor = [UIColor.tmui_randomColor colorWithAlphaComponent:0.3];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}



- (void)bindViewModel{
    // 重设外部约束
    
//    [self invalidateIntrinsicContentSize];
    
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
    return self.viewModel.comments.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *comment = self.viewModel.comments[indexPath.item];
    CGFloat width = [comment tmui_widthForFont:kQuickCommentsFont] + 10;
    return CGSizeMake(width, 20);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THKQuickCommentsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKQuickCommentsCell class])
                                                                           forIndexPath:indexPath];
    NSString *comment = self.viewModel.comments[indexPath.item];
    cell.textLbl.text = comment;
    cell.backgroundColor = UIColor.tmui_randomColor;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *comment = self.viewModel.comments[indexPath.item];
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
        [_collectionView registerClass:[THKQuickCommentsCell class]
            forCellWithReuseIdentifier:NSStringFromClass([THKQuickCommentsCell class])];
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
