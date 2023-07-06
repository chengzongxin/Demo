//
//  THKReferenPictureListVC.m
//  Demo
//
//  Created by Joe.cheng on 2023/7/5.
//

#import "THKReferenPictureListVC.h"
#import "THKReferenPictureListLayout.h"
#import "MJRefresh.h"
#import "THKReferenBigPictureVC.h"
#import "THKReferenPictureListCell.h"
#import "THKPushPopTransitionManager.h"

@interface THKReferenPictureListVC () <UICollectionViewDelegate,UICollectionViewDataSource,THKReferenPictureListLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) THKReferenPictureListLayout *layout;

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation THKReferenPictureListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorWhite;
    
    
    self.datas = [NSMutableArray array];
    
    for (int i = 0; i < 50; i++) {
        [self.datas addObject:@(i)];
    }
    
    [self.view addSubview:self.collectionView];
    
    
    [self addRefreshFooter];
}

- (void)addRefreshFooter{
    @weakify(self);
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.collectionView.mj_footer endRefreshing];
            for (int i = 0; i < 50; i++) {
                [self.datas addObject:@(i)];
            }
            [self.collectionView reloadData];
        });
    }];
}



#pragma mark UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.item % 10) {
        case 0:
            return CGSizeMake([self widthRatio:3], [self widthRatio:3]);
            break;
        case 1:
            return CGSizeMake([self widthRatio:2], [self widthRatio:2]);
            break;
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
            return CGSizeMake([self widthRatio:1], [self widthRatio:1]);
            break;
            
        default:
            break;
    }
    return CGSizeZero;
}

- (CGFloat)widthRatio:(NSInteger)ratio{
    NSInteger column = 3;
    CGFloat itemW = (TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.layout.sectionInset) - (column - 1) * self.layout.minimumInteritemSpacing) / 3.0;
    CGFloat addW = (ratio - 1) * self.layout.minimumLineSpacing;
    return itemW * ratio + addW;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THKReferenPictureListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(THKReferenPictureListCell.class) forIndexPath:indexPath];
    cell.backgroundColor = UIColor.tmui_randomColor;
    [cell.coverImgView loadImageWithUrlStr:@"https://test-pic.to8to.com/company/20220401/f232023c8cc7996ee47862020c5d548c.jpg"];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self pushToBigPicVC:(THKReferenPictureListCell *)[collectionView cellForItemAtIndexPath:indexPath]];
}

#pragma mark - Private
- (void)pushToBigPicVC:(THKReferenPictureListCell *)cardCell {
    THKReferenBigPictureVC *vc = [[THKReferenBigPictureVC alloc] initWithViewModel:THKReferenBigPictureVM.new];
    //加点击跳转转场动效逻辑
    if (vc && cardCell) {
        UIImageView *sourceView = cardCell.coverImgView;
        UIImage *sourceImage = cardCell.coverImgView.image;
        if (sourceView) {
//            TImmersiveBrowseDataDefaultConfig *config = vc.config;
//            NSInteger toIndex = config.currentPageIndex;
            
            THKPushPopTransitionManager *pushPopTransitionManager = [[THKPushPopTransitionManager alloc] init];
            pushPopTransitionManager.pushPopTransition = ({
                THKPushPopAsLocationToListSimulationTransition *transition = [[THKPushPopAsLocationToListSimulationTransition alloc] init];
                transition.pushFromSourceView = sourceView;
                transition.pushFromSourceImage = sourceImage;
                transition.pushFromCornerRadius = 4;
                transition.getPopToCornerRadiusBlock = ^CGFloat{
                    return 4;
                };
                @weakify(sourceView);
                transition.getPopToSourceRectBlock = ^CGRect{
                    @strongify(sourceView);
//                    if (config.currentPageIndex == toIndex) {
//                        //返回CGRectZero，pop动画会按push记录的起始作为返回的目标位置
//                        return CGRectZero;
//                    }
                    
//                    TMCardComponentBaseAbstractCell *popToCell = [self popToCellOfIdStr:config.datas[config.currentPageIndex].idStr];
//                    if (popToCell) {
//                        UIImageView *imgView = popToCell.coverImgView;
//                        CGRect rt = [imgView convertRect:imgView.bounds toView:imgView.window];
//                        if (!CGRectEqualToRect(CGRectZero, rt)) {
//                            return rt;
//                        }
//                    }
                    if (sourceView) {
                        CGRect rt = [sourceView convertRect:sourceView.bounds toView:sourceView.window];
                        if (!CGRectEqualToRect(CGRectZero, rt)) {
                            return rt;
                        }
                    }
                    
//                    if (config.currentPageIndex > toIndex) {
//                        return popToRectDownOfCurrentScreen();
//                    }else {
                        return popToRectUpOfCurrentScreen();
//                    }
                };
                //
                transition;
            });
            pushPopTransitionManager.navigationController = self.navigationController;
            vc.pushPopTransitionManager = pushPopTransitionManager;
            
        }
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getters and Setters

- (THKReferenPictureListLayout *)layout{
    if (!_layout) {
        _layout = [[THKReferenPictureListLayout alloc] init];
        _layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5); // item 间距
        _layout.minimumLineSpacing = 5;  // 两行之间间隔
        _layout.minimumInteritemSpacing = 5; // 两列之间间隔
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = UIColorHex(#DEEEFF);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_collectionView registerClass:THKReferenPictureListCell.class forCellWithReuseIdentifier:NSStringFromClass(THKReferenPictureListCell.class)];
    }
    return _collectionView;
}


@end
