//
//  THKMaterialClassificationView.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialClassificationView.h"
#import "THKMaterialClassificationViewCell.h"
#import <UIVisualEffectView+TMUI.h>

@interface THKMaterialClassificationEffectView : UIVisualEffectView
@end
@implementation THKMaterialClassificationEffectView
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{return NO;}
@end

@interface THKMaterialClassificationView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) THKMaterialClassificationEffectView *effectView;

@end

@implementation THKMaterialClassificationView
#pragma mark - Life Cycle
- (void)dealloc{
    NSLog(@"%@ did dealloc",self);
}


/// xib创建
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self didiniailze];
    }
    return self;
}

/// init or initWithFrame创建
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self didiniailze];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)didiniailze{
    [self addSubview:self.collectionView];
    
    [self addSubview:self.effectView];
    // 默认选中第一个
    [self selectIndex:0];
}


#pragma mark - Public
// initWithModel or bindViewModel: 方法来到这里
// MARK: 初始化,刷新数据和UI,xib,重新设置时调用
- (void)bindViewModel{

}

- (void)selectIndex:(NSInteger)index{
//    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
//    cell.selected = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.entranceList.count;
    return 15;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THKMaterialClassificationViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKMaterialClassificationViewCell class])
                                                                           forIndexPath:indexPath];
    
    cell.imageView.image = UIImageMake(@"com_preload_head_img");
    cell.titleLabel.text = @"冰箱";
    
//    THKDynamicGroupEntranceModel *entrance = self.entranceList[indexPath.item];
//
//    [cell.imageView loadImageWithUrlStr:entrance.imgUrl];
//    cell.titleLabel.text = entrance.title;
//
//    // 曝光
//    [self entrancesShowReport:cell model:entrance indexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    THKDynamicGroupEntranceModel *entrance = self.entranceList[indexPath.item];
//    TRouter *router = [TRouter routerFromUrl:entrance.targetUrl jumpController:nil];
//    [[TRouterManager sharedManager] performRouter:router];
//    // 点击
//    [self entrancesClickReport:[collectionView cellForItemAtIndexPath:indexPath] model:entrance indexPath:indexPath];
}


#pragma mark - Private

- (CGFloat)itemWidth{
    return TMUI_SCREEN_WIDTH/5;
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
        _collectionView.contentInset = UIEdgeInsetsMake(0, 11, 0, 11);
        [_collectionView registerClass:[THKMaterialClassificationViewCell class]
            forCellWithReuseIdentifier:NSStringFromClass([THKMaterialClassificationViewCell class])];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 14;
        _flowLayout.itemSize = CGSizeMake(CGCustomFloat(70), self.height - CGCustomFloat(20));
    }
    
    return _flowLayout;
}

- (THKMaterialClassificationEffectView *)effectView{
    if (!_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[THKMaterialClassificationEffectView alloc] initWithEffect:blur];
        _effectView.frame = CGRectMake(self.width - CGCustomFloat(30), 0, CGCustomFloat(30), self.height);
        _effectView.tmui_foregroundColor = UIColor.whiteColor;
        _effectView.alpha = 0.5;
    }
    return _effectView;
}


#pragma mark - Private



#pragma mark - Getter && Setter


@end
