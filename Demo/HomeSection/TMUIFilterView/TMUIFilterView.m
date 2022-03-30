//
//  TMUIFilterView.m
//  Demo
//
//  Created by Joe.cheng on 2022/2/25.
//

#import "TMUIFilterView.h"
#import "TMUIFilterSectionHeader.h"
#import "TMUIFilterCell.h"

static UIEdgeInsets itemPadding = {0,15,0,15};
static CGFloat itemH = 36;

@interface TMUIFilterView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;


@end

@implementation TMUIFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitalize];
        [self setupviews];
    }
    return self;
}

- (void)didInitalize{
    _topInset = NavigationContentTop;
    _column = 3;
    self.frame = CGRectMake(0, self.topInset, TMUI_SCREEN_WIDTH, TMUI_SCREEN_HEIGHT - self.topInset);
    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    self.userInteractionEnabled = YES;
    @weakify(self);
    [self tmui_addSingerTapWithBlock:^{
        @strongify(self);
        [self dismiss];
    }];
    self.selectColor = UIColorHex(22C77D);
}

- (void)setupviews{
//    [self addSubview:self.contentView];
    [self addSubview:self.collectionView];
    
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self);
//        make.height.mas_equalTo(0);
//    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(TMUI_SCREEN_HEIGHT);
    }];
}

#pragma mark - Public
- (void)show{
    UIViewController *topVC = UIViewController.new.tmui_topViewController;
    [topVC.view addSubview:self];
    // Perform animations
    CGFloat contentH = self.collectionView.contentSize.height + UIEdgeInsetsGetVerticalValue(self.collectionView.contentInset);
    
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-contentH);
        make.height.mas_equalTo(contentH);
    }];
    
    
    [self layoutIfNeeded];
    
    
    [_collectionView tmui_cornerDirect:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:16];
    
    dispatch_block_t animations = ^{
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
        }];
        
        [self layoutIfNeeded];
    };
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:1.f initialSpringVelocity:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:nil];
}

- (void)dismiss{
    CGFloat contentH = self.collectionView.contentSize.height + UIEdgeInsetsGetVerticalValue(self.collectionView.contentInset);
    dispatch_block_t animations = ^{
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-contentH);
        }];
        
        [self layoutIfNeeded];
    };
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:animations completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setModels:(NSArray<TMUIFilterModel *> *)models{
    _models = models;
    [self.collectionView reloadData];
    [self layoutIfNeeded];
//    CGSize size = [self.collectionView sizeThatFits:CGSizeMake(TMUI_SCREEN_WIDTH, CGFLOAT_MAX)];
//    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(size.height);
//    }];
}

- (void)setTopInset:(CGFloat)topInset{
    _topInset = topInset;
    self.frame = CGRectMake(0, self.topInset, TMUI_SCREEN_WIDTH, TMUI_SCREEN_HEIGHT - self.topInset);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.models.count;
}

#pragma mark headers
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.width, 72);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        TMUIFilterSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(TMUIFilterSectionHeader.class) forIndexPath:indexPath];
        header.title = self.models[indexPath.section].title;
        header.subtitle = self.models[indexPath.section].subtitle;
        return header;
    } else if (kind == UICollectionElementKindSectionFooter) {
        return nil;
    }
    
    return nil;
}

#pragma mark items

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger i = self.models[section].items.count;
    return i;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = [self itemSize];
    return size;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMUIFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TMUIFilterCell class])
                                                                           forIndexPath:indexPath];
    cell.btn.tmui_text = self.models[indexPath.section].items[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    NSLog(@"%@",indexPath);
}

#pragma mark - Private
- (CGSize)itemSize{
    CGFloat width = floor((TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.flowLayout.sectionInset) - (self.flowLayout.minimumInteritemSpacing * self.column - 1))/self.column);
    return CGSizeMake(width, itemH);
}

#pragma mark - Getter && Setter
//
//- (UIView *)contentView{
//    if (!_contentView) {
//        _contentView = [[UIView alloc] init];
//        _contentView.backgroundColor = UIColor.whiteColor;
//    }
//    return _contentView;
//}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        _collectionView.cornerRadius = 16;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        [_collectionView registerClass:TMUIFilterSectionHeader.class
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(TMUIFilterSectionHeader.class)];
        [_collectionView registerClass:[TMUIFilterCell class]
            forCellWithReuseIdentifier:NSStringFromClass([TMUIFilterCell class])];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing = 9;
        _flowLayout.minimumLineSpacing = 8;
        _flowLayout.sectionInset = itemPadding;
    }
    return _flowLayout;
}

#pragma mark - Super



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


@end
