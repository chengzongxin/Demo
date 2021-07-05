//
//  THKMaterialClassificationView.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialClassificationHeaderView.h"
#import "THKMaterialClassificationViewCell.h"
#import <UIVisualEffectView+TMUI.h>
#import <UIScrollView+TMUI.h>

@interface THKMaterialClassificationEffectView : UIView
@end
@implementation THKMaterialClassificationEffectView
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{return NO;}
@end

@interface THKMaterialClassificationHeaderView (Godeye)
/// cell 曝光
- (void)cellShowReport:(UICollectionViewCell *)cell model:(NSObject *)model indexPath:(NSIndexPath *)indexPath;
/// cell点击
- (void)cellClickReport:(UICollectionViewCell *)cell model:(NSObject *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface THKMaterialClassificationHeaderView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) THKMaterialClassificationEffectView *leftEffectView;
@property (nonatomic, strong) THKMaterialClassificationEffectView *rightEffectView;

@end

@implementation THKMaterialClassificationHeaderView
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
    // 添加分割线
    self.tmui_borderPosition = TMUIViewBorderPositionBottom;
    self.tmui_borderColor = UIColorHex(#F6F8F6);
    
    [self addSubview:self.collectionView];
    [self addSubview:self.leftEffectView];
    [self addSubview:self.rightEffectView];
    // 默认选中第一个
}


#pragma mark - Public
// initWithModel or bindViewModel: 方法来到这里
// MARK: 初始化,刷新数据和UI,xib,重新设置时调用
- (void)bindViewModel{

}

- (void)setSubCategoryList:(NSArray<THKMaterialRecommendRankSubCategoryList *> *)subCategoryList{
    _subCategoryList = subCategoryList;
    
    [self.collectionView reloadData];
    
    if (subCategoryList.count == 0) {
        return;
    }
    
//    [self selectIndex:0];
    __block NSInteger selectIndex = 0;
    
    [subCategoryList enumerateObjectsUsingBlock:^(THKMaterialRecommendRankSubCategoryList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.categoryId == self.subCategoryId) {
            selectIndex = idx;
            *stop = YES;
        }
    }];
    
    [self selectIndex:selectIndex];
    
}

- (void)selectIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.entranceList.count;
    return self.subCategoryList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THKMaterialClassificationViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKMaterialClassificationViewCell class])
                                                                           forIndexPath:indexPath];
    
    NSString *imgUrl = self.subCategoryList[indexPath.item].cover;
    
    [cell.imageView loadImageWithUrlStr:imgUrl];
//    cell.imageView.image = UIImageMake(@"com_preload_head_img");
    
    cell.titleLabel.text = self.subCategoryList[indexPath.item].categoryName;
    
//    THKDynamicGroupEntranceModel *entrance = self.entranceList[indexPath.item];
//
//    [cell.imageView loadImageWithUrlStr:entrance.imgUrl];
//    cell.titleLabel.text = entrance.title;
//
//    // 曝光
    [self cellShowReport:cell model:self.subCategoryList indexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    !self.tapItem ?: self.tapItem(indexPath.item);
    
//    THKDynamicGroupEntranceModel *entrance = self.entranceList[indexPath.item];
//    TRouter *router = [TRouter routerFromUrl:entrance.targetUrl jumpController:nil];
//    [[TRouterManager sharedManager] performRouter:router];
    // 点击
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self cellClickReport:cell model:self.subCategoryList indexPath:indexPath];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger item = [self.collectionView numberOfItemsInSection:0] - 1;
    if (item < 0) {
        return;
    }
    
    CGFloat lProgress = (scrollView.contentOffset.x - 80)/80;
    CGFloat rProgress = (scrollView.contentSize.width - scrollView.contentOffset.x - scrollView.width)/80;
    
    if (lProgress > 1) {
        lProgress = 1;
    }
    if (rProgress > 1) {
        rProgress = 1;
    }
    if (lProgress < 0) {
        lProgress = 0;
    }
    if (rProgress < 0) {
        rProgress = 0;
    }
    
    self.leftEffectView.alpha = lProgress;
    self.rightEffectView.alpha = rProgress;
    
//    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
//    BOOL isFirstVisible = [self.collectionView tmui_itemVisibleAtIndexPath:firstIndexPath];
//    BOOL isLastVisible = [self.collectionView tmui_itemVisibleAtIndexPath:lastIndexPath];
//    self.leftEffectView.alpha = !isFirstVisible;
//    self.rightEffectView.alpha = !isLastVisible;
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

- (UIView *)leftEffectView{
    if (!_leftEffectView) {
        _leftEffectView = [[THKMaterialClassificationEffectView alloc] init];
        _leftEffectView.frame = CGRectMake(0, 0, CGCustomFloat(80), self.height);
        [_leftEffectView tmui_gradientWithColors:@[[UIColor colorWithRed:1 green:1 blue:1 alpha:1],[UIColor colorWithRed:1 green:1 blue:1 alpha:0]] gradientType:TMUIGradientTypeLeftToRight locations:@[@0.1]];
        _leftEffectView.alpha = 0;
    }
    return _leftEffectView;
}

- (UIView *)rightEffectView{
    if (!_rightEffectView) {
        _rightEffectView = [[THKMaterialClassificationEffectView alloc] init];
        _rightEffectView.frame = CGRectMake(self.width - CGCustomFloat(80), 0, CGCustomFloat(80), self.height);
        [_rightEffectView tmui_gradientWithColors:@[[UIColor colorWithRed:1 green:1 blue:1 alpha:0],[UIColor colorWithRed:1 green:1 blue:1 alpha:1]] gradientType:TMUIGradientTypeLeftToRight locations:@[@0.5]];
        _leftEffectView.alpha = 0;
    }
    return _rightEffectView;
}


#pragma mark - Private



#pragma mark - Getter && Setter


@end


@implementation THKMaterialClassificationHeaderView (Godeye)

- (void)cellShowReport:(UICollectionViewCell *)cell model:(NSArray <THKMaterialRecommendRankSubCategoryList *> *)model indexPath:(NSIndexPath *)indexPath{
//    THKMaterialRecommendRankSubCategoryList *item = model[indexPath.item];
//    if (item.isExposed) {
//        return;
//    }
//    item.isExposed = YES;
//    GEWidgetResource *resource = [GEWidgetResource resourceWithWidget:cell];
//    [resource addEntries:@{@"widget_title":item.categoryName?:@"",
//                           @"widget_uid":@"top_sub_type_btn",
//                           @"widget_index":@(indexPath.item),
//    }];
//    [[GEWidgetExposeEvent eventWithResource:resource] report];
}

- (void)cellClickReport:(UICollectionViewCell *)cell model:(NSArray <THKMaterialRecommendRankSubCategoryList *> *)model indexPath:(NSIndexPath *)indexPath{
//    THKMaterialRecommendRankSubCategoryList *item = model[indexPath.item];
//    GEWidgetResource *resource = [GEWidgetResource resourceWithWidget:cell];
//    [resource addEntries:@{@"widget_title":item.categoryName?:@"",
//                           @"widget_uid":@"top_sub_type_btn",
//                           @"widget_index":@(indexPath.item),
//    }];
//    [[GEWidgetClickEvent eventWithResource:resource] report];
}


@end
