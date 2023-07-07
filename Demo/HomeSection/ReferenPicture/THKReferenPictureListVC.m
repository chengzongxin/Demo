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

@property (nonatomic, strong) THKReferenPictureListVM *viewModel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) THKReferenPictureListLayout *layout;

@end

@implementation THKReferenPictureListVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorWhite;
    
    [self.view addSubview:self.collectionView];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    [self.viewModel bindStatusWithView:self.view scrollView:self.collectionView];
    
    [self.viewModel addRefreshFooter];
    
    [self.viewModel.requestCommand execute:@1];
}


#pragma mark UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self itemSizeForIndexPath:indexPath];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THKReferenPictureListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(THKReferenPictureListCell.class) forIndexPath:indexPath];
//    cell.backgroundColor = UIColor.tmui_randomColor;
    [cell.coverImgView loadImageWithUrlStr:self.viewModel.data[indexPath.item]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self pushToBigPicVC:(THKReferenPictureListCell *)[collectionView cellForItemAtIndexPath:indexPath]];
}

#pragma mark - Private

- (CGSize)itemSizeForIndexPath:(NSIndexPath *)indexPath {
    // 是最后10个
    NSInteger lastCount = self.viewModel.data.count % 10;
    BOOL isLastGroup = (self.viewModel.data.count / 10 == indexPath.item / 10);
    
    if (lastCount == 0 || !isLastGroup) {
        switch (indexPath.item % 10) {
            case 0:
                return CGSizeMake([self widthRatio:3], [self heightRatio:3]);
                break;
            case 1:
                return CGSizeMake([self widthRatio:2], [self heightRatio:2]);
                break;
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
                return CGSizeMake([self widthRatio:1], [self heightRatio:1]);
                break;
        }
        return CGSizeZero;
    }else if (lastCount < 4) {
        return CGSizeMake([self widthRatio:3], [self heightRatio:3]);
    }else if (lastCount < 7) {
        switch (indexPath.item % 10) {
            case 0:
            case 4:
            case 5:
                return CGSizeMake([self widthRatio:3], [self heightRatio:3]);
                break;
            case 1:
                return CGSizeMake([self widthRatio:2], [self heightRatio:2]);
                break;
            case 2:
            case 3:
                return CGSizeMake([self widthRatio:1], [self heightRatio:1]);
                break;
        }
        return CGSizeZero;
    }else if (lastCount < 10) {
        switch (indexPath.item % 10) {
            case 0:
            case 7:
            case 8:
                return CGSizeMake([self widthRatio:3], [self heightRatio:3]);
                break;
            case 1:
                return CGSizeMake([self widthRatio:2], [self heightRatio:2]);
                break;
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
                return CGSizeMake([self widthRatio:1], [self heightRatio:1]);
                break;
                
        }
        return CGSizeZero;
    }
    return CGSizeZero;
}

- (CGFloat)widthRatio:(NSInteger)ratio{
    NSInteger column = 3;
    CGFloat itemW = (TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.layout.sectionInset) - (column - 1) * self.layout.minimumInteritemSpacing) / 3.0;
    CGFloat addW = (ratio - 1) * self.layout.minimumLineSpacing;
    return itemW * ratio + addW;
}

- (CGFloat)heightRatio:(NSInteger)ratio{
    CGFloat h = 0;
    switch (ratio) {
        case 1:
            h = 145/124.0 * [self widthRatio:ratio];
            break;
        case 2:
//            h = 292/249.0 * [self widthRatio:ratio];
            h = [self heightRatio:1] * 2 + self.layout.minimumLineSpacing;
            break;
        case 3:
            h = 280/375.0 * [self widthRatio:ratio];
            break;
        default:
            break;
    }
    return h;
}


- (void)pushToBigPicVC {
//    THKImageBrowserProVC *vc = [[THKImageBrowserProVC alloc] initWithStyle:THKImageBrowserVCStyle_Dot];
//    vc.customData = model.imgList;
//    vc.blockPraseDataImgUrl = ^NSString * _Nonnull(THKBrandEvaluationImgModel * _Nonnull data) {
//        return data.filePath ? : data.url;
//    };
//    vc.blockPraseDataThumbImgUrl = ^NSString * _Nonnull(THKBrandEvaluationImgModel * _Nonnull data) {
//        return data.thumbnailUrl;
//    };
//    vc.blockPraseDataAnimationView = ^UIView * _Nonnull(THKBrandEvaluationImgModel * _Nonnull data, NSIndexPath * _Nonnull indexPath) {
//        return [imageViews safeObjectAtIndex:indexPath.row];
//    };
//    vc.blockPraseDataAnimationOutScreen = ^BOOL(id  _Nonnull data, NSIndexPath * _Nonnull indexPath) {
//        @strongify(self)
//        UIImageView *imgView = [imageViews safeObjectAtIndex:indexPath.row];
//        CGRect rect = [imgView convertRect:imgView.bounds toView:self.view.window];
//        CGFloat offset = 0;
//        CGRect viewRect = [self.view convertRect:self.view.bounds toView:self.view.window];
//
//        if (!CGRectEqualToRect(CGRectZero, rect) && (rect.origin.y + rect.size.height) > viewRect.origin.y - offset && rect.origin.y < viewRect.origin.y + viewRect.size.height - offset) {
//            return NO;
//        }
//        return YES;
//    };
//    vc.blockWillDisplayCell = ^(TMImageData * _Nonnull data, NSIndexPath * _Nonnull indexPath, UIView *_cell) {
//        @strongify(self);
//        if (data.tag) {
//            return;
//        }
//        data.tag = 1;
//        GEWidgetResource *resource = [GEWidgetResource resourceWithWidget:_cell];
//        resource.geWidgetUid = @"view_photo";
//        [resource addEntries:@{
//            @"widget_target":@(self.viewModel.categoryId),
//            @"widget_index":[NSString stringWithFormat:@"%zd", indexPath.row]
//        }];
//        [[GEWidgetCustomEvent eventWithResource:resource eventName:@"photoView"] report];
//    };
//    vc.indexPathScrollTo = [NSIndexPath indexPathForRow:idx_ inSection:0];
//
//    [vc show];
}

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
        _layout.sectionInset = UIEdgeInsetsZero; // item 间距
        _layout.minimumLineSpacing = 2;  // 两行之间间隔
        _layout.minimumInteritemSpacing = 2; // 两列之间间隔
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = UIColor.blackColor;
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
