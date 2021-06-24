//
//  THKMaterialClassificationView.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialClassificationView.h"
#import "THKMaterialClassificationViewCell.h"
#import <UIVisualEffectView+TMUI.h>
#import <UIScrollView+TMUI.h>

@interface THKMaterialClassificationEffectView : UIView
@end
@implementation THKMaterialClassificationEffectView
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{return NO;}
@end

@interface THKMaterialClassificationView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) THKMaterialClassificationEffectView *leftEffectView;
@property (nonatomic, strong) THKMaterialClassificationEffectView *rightEffectView;

//@property (nonatomic, strong) NSArray *icons;

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
    
   NSArray *array = @[@[@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202007%2F11%2F20200711184432_ic25F.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=9e96d0bcb69f82406f6ccb5db06e773d",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201712%2F15%2F20171215221023_KiYWM.thumb.700_0.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=e9c342d03d8478f6b41c7f0a5552f084",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201508%2F15%2F20150815131712_fEyPM.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=c6dd2f0386494ff4bafbc536c27d416f"],
                @[@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=623994087,1173615898&fm=26&gp=0.jpg",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic1.zhimg.com%2F50%2Fv2-71dcef82c8afb85dacd42a995f64f1b5_hd.jpg&refer=http%3A%2F%2Fpic1.zhimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=a1d0e311f83398e60371a466209abba1",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fcdn.duitang.com%2Fuploads%2Fitem%2F201408%2F24%2F20140824154253_45Hay.png&refer=http%3A%2F%2Fcdn.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=c5ffa3ef3d76b4787a6352db62015895"],
                @[@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic4.zhimg.com%2F50%2Fv2-5a63ee9cbe62d53ee36e1c99caa095d9_hd.jpg&refer=http%3A%2F%2Fpic4.zhimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=c6f75eea1d9260386bb2f20d706c0e15",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic3.zhimg.com%2F50%2Fv2-728648096894b4aa9eda8d33cdcf5f28_hd.jpg&refer=http%3A%2F%2Fpic3.zhimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=660cb729a2ee254eda8c398ffc9543e7",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fdp.gtimg.cn%2Fdiscuzpic%2F0%2Fdiscuz_x5_gamebbs_qq_com_forum_201306_19_1256219xc797y90heepdbh.jpg%2F0&refer=http%3A%2F%2Fdp.gtimg.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=98b856b6650e34ad1aa1004b8b90cffb"],
                @[@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201901%2F04%2F20190104222555_Rvvyu.thumb.700_0.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=c92a94778530e4b4542f548d626990c6",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1441836571,2166773131&fm=26&gp=0.jpg",@"https://pics4.baidu.com/feed/d000baa1cd11728bd4d98501effc13c8c3fd2c27.jpeg?token=73c8c9c6a7f8bee46641914a57098d98"],
                @[@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202007%2F03%2F20200703140553_8Fk3Y.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=153e10bd08e45dfebe0a1a220cb84aa1",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fs10.sinaimg.cn%2Fbmiddle%2F005Hq1RPgy6LxuSIxIt49%26690&refer=http%3A%2F%2Fs10.sinaimg.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=dc41901894f299e45b0aa88d91ba7bc3",@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201811%2F18%2F20181118142953_yaktg.thumb.700_0.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626937380&t=b50a0b5d471cfdbbeb946070c125906e"],];
    
    NSMutableArray *allArr = [NSMutableArray array];
    [array tmui_enumerateNestedArrayWithBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [allArr addObject:obj];
    }];
//    self.icons = allArr;
    // 添加分割线
    self.tmui_borderPosition = TMUIViewBorderPositionBottom;
    self.tmui_borderColor = UIColorHex(#F6F8F6);
    
    [self addSubview:self.collectionView];
    [self addSubview:self.leftEffectView];
    [self addSubview:self.rightEffectView];
    // 默认选中第一个
    [self selectIndex:0];
}


#pragma mark - Public
// initWithModel or bindViewModel: 方法来到这里
// MARK: 初始化,刷新数据和UI,xib,重新设置时调用
- (void)bindViewModel{

}

- (void)setSubCategoryList:(NSArray<THKMaterialRecommendRankSubCategoryList *> *)subCategoryList{
    _subCategoryList = subCategoryList;
    
    [self.collectionView reloadData];
    [self selectIndex:0];
}

- (void)selectIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
    
    self.leftEffectView.alpha = 0;
    self.rightEffectView.alpha = 1;
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
    
    [cell.imageView setImageURL:[NSURL URLWithString:imgUrl]];
//    cell.imageView.image = UIImageMake(@"com_preload_head_img");
    
    cell.titleLabel.text = self.subCategoryList[indexPath.item].categoryName;
    
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
    !self.tapItem ?: self.tapItem(indexPath.item);
    
//    THKDynamicGroupEntranceModel *entrance = self.entranceList[indexPath.item];
//    TRouter *router = [TRouter routerFromUrl:entrance.targetUrl jumpController:nil];
//    [[TRouterManager sharedManager] performRouter:router];
//    // 点击
//    [self entrancesClickReport:[collectionView cellForItemAtIndexPath:indexPath] model:entrance indexPath:indexPath];
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
    }
    return _leftEffectView;
}

- (UIView *)rightEffectView{
    if (!_rightEffectView) {
        _rightEffectView = [[THKMaterialClassificationEffectView alloc] init];
        _rightEffectView.frame = CGRectMake(self.width - CGCustomFloat(80), 0, CGCustomFloat(80), self.height);
        [_rightEffectView tmui_gradientWithColors:@[[UIColor colorWithRed:1 green:1 blue:1 alpha:0],[UIColor colorWithRed:1 green:1 blue:1 alpha:1]] gradientType:TMUIGradientTypeLeftToRight locations:@[@0.5]];
    }
    return _rightEffectView;
}


#pragma mark - Private



#pragma mark - Getter && Setter


@end
