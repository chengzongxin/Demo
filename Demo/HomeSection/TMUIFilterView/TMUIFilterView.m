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

@property (nonatomic, strong) UIView *contentView;

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
    self.column = 3;
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
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
        make.top.left.right.height.mas_equalTo(0);
    }];
}

#pragma mark - Public
- (void)show{
    UIViewController *topVC = UIViewController.new.tmui_topViewController;
    [topVC.view addSubview:self];
    // Perform animations
    CGFloat contentH = 500;
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-contentH);
        make.height.mas_equalTo(contentH);
    }];
    
    
    [self layoutIfNeeded];
    
    dispatch_block_t animations = ^{
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
        }];
        
        [self layoutIfNeeded];
    };
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:1.f initialSpringVelocity:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:nil];
}

- (void)dismiss{
    CGFloat duration = self.disableAnimate ? 0 : .5;
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);// 改成0会不显示动画
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1;
        self.transform = CGAffineTransformIdentity;//
    }];
}

- (void)setModels:(NSArray<TMUIFilterModel *> *)models{
    _models = models;
    [self.collectionView reloadData];
}

- (void)setTopInset:(CGFloat)topInset{
    self.y = topInset;
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
    cell.backgroundColor = UIColor.tmui_randomColor;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",indexPath);
}

#pragma mark - Private
- (CGSize)itemSize{
    CGFloat width = floor((TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.flowLayout.sectionInset) - (self.flowLayout.minimumInteritemSpacing * self.column - 1))/self.column);
    return CGSizeMake(width, itemH);
}

#pragma mark - Getter && Setter

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
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
