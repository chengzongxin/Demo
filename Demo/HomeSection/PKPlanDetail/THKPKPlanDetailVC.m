//
//  THKPKPlanDetailVC.m
//  Demo
//
//  Created by Joe.cheng on 2023/8/18.
//

#import "THKPKPlanDetailVC.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "GECollectionView.h"
#import "TMCardComponentHelper.h"

@interface THKPKPlanDetailVC ()<UICollectionViewDelegate, UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong) THKPKPlanDetailVM *viewModel;

@property (nonatomic, strong) GECollectionView *collectionView;

@end

@implementation THKPKPlanDetailVC
@dynamic viewModel;


#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)bindViewModel {
    [super bindViewModel];
    
    NSLog(@"xxxx");
}


#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark - collectionView
//- (__kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//
//    TCaseSectionModel * sectionModel = self.viewModel.arrayData[indexPath.section];
//    NSObject * content = sectionModel.contents[indexPath.row];
//    if ([content isKindOfClass:[TCaseBaseModel class]]) {
//        TCaseBaseModel * model = (TCaseBaseModel *)content;
//        NSString * identifier = [[model class] cellIdentifier];
//        TCaseBaseCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//        if ([cell isKindOfClass:[TCaseCommentCell class]]) {
//            TCaseCommentCell * commentCell = (TCaseCommentCell *)cell;
//            [commentCell.customContentView addSubview:self.commentView];
//            [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(commentCell.customContentView);
//            }];
//        } else if ([cell isKindOfClass:[TCaseContentCell class]]) {
//            TCaseContentCell *contentCell = (TCaseContentCell *)cell;
//            contentCell.describleText.textColor = [UIColor colorWithHexString:@"333333"];
//            contentCell.describleText.font = [UIFont systemFontOfSize:16];
//        }
//        cell.touchDelegate = self;
//        cell.model = model;
//        return cell;
//    } else if ([content isKindOfClass:[THKCommonUserInfoModel class]]) {
//        THKCommonUserInfoModel * model = (THKCommonUserInfoModel *)content;
//        NSString * identifier = NSStringFromClass(THKCommonUserInfoModel.class);
//        THKUGCGraphicDetailUserInfoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//        cell.userInfoModel = model;
//        return cell;
//    }
//    else if([content isKindOfClass:[THKDiaryTagCellModel class]]) {
//        THKDiaryTagCellModel * model = (THKDiaryTagCellModel *)content;
//        NSString * identifier = NSStringFromClass([THKDiaryTagCellModel class]);
//        THKDecDiaryDetailTagCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//        cell.delegate = self;
//        [cell upateDiaryDetailTagDataSource:model.tags];
//        return cell;
//    }
//    else if ([content isKindOfClass:[THKUGCDetailRankCardModel class]]) {
//        THKUGCDetailRankCardModel * model = (THKUGCDetailRankCardModel *)content;
//        NSString * identifier = NSStringFromClass(THKUGCDetailRankCardModel.class);
//        THKUGCGraphicDetailRankCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//        cell.rankModel = model.rankInfo;
//        return cell;
//    } else if ([content isKindOfClass:[THKUGCDetailMerchantCardModel class]]) {
//        THKUGCDetailMerchantCardModel * model = (THKUGCDetailMerchantCardModel *)content;
//        NSString * identifier = NSStringFromClass(THKUGCDetailMerchantCardModel.class);
//        THKUGCDetailCardListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//        cell.arrayCardData = model.brandMerchants;
//        @weakify(self);
//        cell.cardItemClickBlock = ^(NSIndexPath * _Nonnull indexPath, id  _Nonnull model) {
//            @strongify(self);
//            if (model && [model isKindOfClass:[THKUGCGraphicDetailMerchantModel class]]) {
//                THKUGCGraphicDetailMerchantModel * cardModel = model;
//                [THKUserHomeRouter jumpToVcWithTargetId:cardModel.cardId identity:THKUserIdentityType_User nav:self.navigationController];
//            }
//        };
//        
//        return cell;
//    } else if ([content isKindOfClass:[THKUGCDetailGoodCardModel class]]) {
//        THKUGCDetailGoodCardModel * model = (THKUGCDetailGoodCardModel *)content;
//        NSString * identifier = NSStringFromClass(THKUGCDetailGoodCardModel.class);
//        THKUGCDetailCardListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//        cell.arrayCardData = model.goodsData;
//        @weakify(self);
//        cell.cardItemClickBlock = ^(NSIndexPath * _Nonnull indexPath, id  _Nonnull model) {
//            @strongify(self);
//            if (model && [model isKindOfClass:[THKUGCGraphicDetailGoodsModel class]]) {
//                THKUGCGraphicDetailGoodsModel * cardModel = model;
//                [[TRouter routerFromUrl:cardModel.webUrl] perform];
//            }
//        };
//        return cell;
//    }  else  if ([content isKindOfClass:[THKUGCRankCardCellModel class]]) {
//        THKUGCRankCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKUGCRankCardCell class]) forIndexPath:indexPath];
//        THKUGCRankCardCellModel *model = (THKUGCRankCardCellModel *)content;
//        [cell updateUIElement:model];
//        return cell;
//    } else if ([content isKindOfClass:[TMCardComponentCellDataModel class]]) {
//        TMCardComponentCellDataModel * model = (TMCardComponentCellDataModel *)content;
//        UICollectionViewCell<TMCardComponentCellProtocol> *cell = [TMCardComponentHelper collectionViewCellInCollectionView:collectionView cellData:model itemIndexPath:indexPath godEyeReportDataBlock:nil];
//        return cell;
//    }
//    else if ([content isKindOfClass:[NSArray class]]) {
//        THKUGCDetailPraiseUsersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"THKUGCDetailPraiseUsersCell" forIndexPath:indexPath];
//        NSArray <THKInteractivePraiseViewUserModel *> *avatars = (NSArray *)content;
//        [cell setUsers:avatars interactiveModel:self.viewModel.interactiveModel];
//        return cell;
//    }
//    else if ([content isKindOfClass:[NSString class]] && [(NSString *)content isEqual:@"pageControl"]) {
//        if (_pageControlCell) {
//            return _pageControlCell;
//        }
//        THKUGCDetailPageControlCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"THKUGCDetailPageControlCell" forIndexPath:indexPath];
//        [cell setPhotoNum:self.viewModel.arrayHeaderImageModel.count];
//        _pageControlCell = cell;
//        return cell;
//    }
//    else if ([content isKindOfClass:[THKUGCDetailShopCardModel class]]) {
//        THKUGCDetailShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKUGCDetailShopCell class]) forIndexPath:indexPath];
//        cell.shops = [((THKUGCDetailShopCardModel *)content) shops];
//        return cell;
//    }
//    else if ([content isKindOfClass:[THKUGCDetailRecommendShopCardModel class]]) {
//        THKUGCDetailRecommendShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKUGCDetailRecommendShopCell class]) forIndexPath:indexPath];
//        cell.ugcId = self.viewModel.ugcId;
//        cell.shops = [((THKUGCDetailRecommendShopCardModel *)content) shops];
//        return cell;
//    }
//    else if ([content isKindOfClass:[THKUGCDetailCollectionModel class]]) {
//        THKUGCDetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKUGCDetailCollectionCell class]) forIndexPath:indexPath];
//        cell.title = [((THKUGCDetailCollectionModel *)content) title];
//        return cell;
//    }
//    return nil;
//}
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return self.viewModel.arrayData.count;
//}
//
//- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    TCaseSectionModel * sectionModel = self.viewModel.arrayData[section];
//    return sectionModel.contents.count;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section {
//    TCaseSectionModel * sectionModel = self.viewModel.arrayData[section];
//    NSObject * model = [sectionModel.contents firstObject];
//    if ([model isKindOfClass:[TCaseBaseModel class]]) {
//        return ((TCaseBaseModel *)model).layoutConfig.columnCount;;
//    } else if ([model isKindOfClass:[THKCommonUserInfoModel class]] || [model isKindOfClass:[THKDiaryTagCellModel class]] || [model isKindOfClass:[THKUGCDetailRankCardModel class]] || [model isKindOfClass:[THKUGCDetailShopCardModel class]] || [model isKindOfClass:[THKUGCDetailRecommendShopCardModel class]]) {
//        return 1;
//    } else if ([model isKindOfClass:[THKUGCDetailMerchantCardModel class]] || [model isKindOfClass:[THKUGCDetailGoodCardModel class]] || [model isKindOfClass:[NSArray class]] || ([model isKindOfClass:[NSString class]] && [(NSString *)model isEqual:@"pageControl"]) || [model isKindOfClass:[THKUGCDetailCollectionModel class]]) {
//        return 1;
//    } else {
//        return 2;
//    }
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    TCaseSectionModel * sectionModel = self.viewModel.arrayData[indexPath.section];
//    NSObject * model = sectionModel.contents[indexPath.row];
//    if ([model isKindOfClass:[TCaseBaseModel class]]) {
//        return ((TCaseBaseModel *)model).layoutConfig.itemSize;
//    } else if ([model isKindOfClass:[THKCommonUserInfoModel class]]) {
//        return CGSizeMake(kScreenWidth, [THKUGCGraphicDetailUserInfoCell cellHeight]);
//    } else if ([model isKindOfClass:[THKUGCDetailMerchantCardModel class]]) {
//        return CGSizeMake(kScreenWidth, ((THKUGCDetailMerchantCardModel*)model).itemHeight);
//    } else if ([model isKindOfClass:[THKUGCDetailGoodCardModel class]]) {
//        return CGSizeMake(kScreenWidth, ((THKUGCDetailGoodCardModel*)model).itemHeight);
//    } else if ([model isKindOfClass:[THKDiaryTagCellModel class]]) {
//        return CGSizeMake(kScreenWidth, ((THKDiaryTagCellModel*)model).itemHeight);
//    } else if ([model isKindOfClass:[THKUGCDetailRankCardModel class]]) {
//        return CGSizeMake(kScreenWidth, ((THKUGCDetailRankCardModel*)model).itemHeight);
//    } else if ([model isKindOfClass:[TMCardComponentCellDataModel class]]) {
//        return [TMCardComponentHelper collectionView:collectionView layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout cellData:(TMCardComponentCellDataModel *)model sectionInset:sectionModel.layoutConfig.sectionInset];
//    }
//    else if ([model isKindOfClass:[NSArray class]]) {
//        return sectionModel.layoutConfig.itemSize;}
//    else if ([model isKindOfClass:[NSString class]] && [(NSString *)model isEqual:@"pageControl"]) {
//        return CGSizeMake(kScreenWidth, 23);}
//    else if ([model isKindOfClass:[THKUGCDetailShopCardModel class]]) {
//        return CGSizeMake(kScreenWidth, (76));
//    }
//    else if ([model isKindOfClass:[THKUGCDetailRecommendShopCardModel class]]) {
//        return CGSizeMake(kScreenWidth, ([THKUGCDetailRecommendShopCell cellHeight]));
//    }
//    else if ([model isKindOfClass:[THKUGCDetailCollectionModel class]]) {
//        return CGSizeMake(kScreenWidth, ([THKUGCDetailCollectionCell cellHeight]));
//    }
//    return CGSizeZero;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    TCaseSectionModel * sectionModel = self.viewModel.arrayData[indexPath.section];
//    NSObject * content = sectionModel.contents[indexPath.row];
//    if ([content isKindOfClass:[THKCommonUserInfoModel class]]) {
//        THKCommonUserInfoModel *userModel = (THKCommonUserInfoModel *)content;
//        [THKUserHomeRouter jumpToVcWithTargetId:userModel.uid identity:userModel.authorIdentity nav:self.navigationController];
//    } else  if ([content isKindOfClass:[THKUGCRankCardCellModel class]]) {
//        
//        THKUGCRankCardCellModel *model = (THKUGCRankCardCellModel *)content;
//        TRouter *router = [TRouter routerFromUrl:model.categoryDetailUrl jumpController:self.navigationController];
//        [[TRouterManager sharedManager] performRouter:router];
//        
//        
//        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//        GEWidgetResource *resource = [GEWidgetResource resourceWithWidget:cell];
//        [resource addEntries:[self reportRankCardParamAtIndex:indexPath model:model]];
//        [[GEWidgetClickEvent eventWithResource:resource] report];
//        
//    } else if ([content isKindOfClass:[TMCardComponentCellDataModel class]]) {
//        TMCardComponentCellDataModel * model = (TMCardComponentCellDataModel *)content;
//        //同风格户型的案例
//        UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
//        if (model.content.router.length) {
//            NSDictionary *dictTemp = reportDictionaryFromReportKeyValueList(model.report);
//            GEWidgetResource    *resource = [GEWidgetResource resourceWithWidget:cell];
//            [resource addEntries:dictTemp];
//            [[GEWidgetClickEvent eventWithResource:resource] report];
//            
//            TRouter * router = [TRouter routerFromUrl:model.content.router];
//            UIViewController *vc = [[TRouterManager sharedManager] createTargetForRouter:router];
////            if ([vc isKindOfClass:[THKUGCGraphicDetailViewController class]]) {
////                [((THKUGCGraphicDetailViewController *)vc).viewModel setCardComponentCellData:model];
////                THKAnimationManager *animationManager = [[THKAnimationManager alloc] init];
////                animationManager.duration = 0.3;
////
////                THKMoveViewAnimation *ani = [[THKMoveViewAnimation alloc] init];
////                ani.pushDelegate = self;
////                ani.popDelegate = (THKUGCGraphicDetailViewController *)vc;
////                ani.indexPath = indexPath;
////                animationManager.animation = ani;
////                [self thk_pushViewControler:vc animationManager:animationManager];
////            } else {
//                [[TRouterManager sharedManager] performRouter:router];
////            }
//            
//            [self threePagesJumpBacktrace:self.navigationController.childViewControllers.lastObject];
//        }
//    } else if ([content isKindOfClass:[THKUGCDetailCollectionModel class]]) {
//        THKUGCDetailCollectionModel *model = (THKUGCDetailCollectionModel *)content;
//        
//        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//        GEWidgetResource *resource = [GEWidgetResource resourceWithWidget:cell];
//        [resource addEntries:[self reportCollectionCardParamAtIndex:indexPath model:model]];
//        [[GEWidgetClickEvent eventWithResource:resource] report];
//        
//        THKGraphicCollectionVM *vm = [[THKGraphicCollectionVM alloc] initWithParams:@{@"collectionId":@(self.viewModel.dataModel.collectionId),@"ugcId":@(self.viewModel.ugcId)}];
//        THKGraphicCollectionVC *vc = [[THKGraphicCollectionVC alloc] initWithViewModel:vm];
//        [self presentViewController:vc animated:YES completion:nil];
//    }
//}
//
///**
// 控制最多只能显示3级，否则会进入无线循环
// */
//- (void)threePagesJumpBacktrace:(UIViewController *)VC {
//    NSInteger count = self.navigationController.childViewControllers.count;
//    if (count > 3) {
//        NSInteger index = 0;
//        UIViewController * caseMainVC = nil;
//        for (; index < count; index ++) {
//            UIViewController * vc = self.navigationController.childViewControllers[index];
//            if ([vc isKindOfClass:[self class]]) {
//                caseMainVC = vc;
//                break;
//            }
//        }
//        NSMutableArray * subVCs = [[self.navigationController.childViewControllers subarrayWithRange:NSMakeRange(0, index)] mutableCopy];
//        if (caseMainVC) {
//            [subVCs safeAddObject:caseMainVC];
//        }
//        [subVCs safeAddObject:VC];
//        self.navigationController.viewControllers = subVCs;
//    }
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section {
//    TCaseSectionModel * sectionModel = self.viewModel.arrayData[section];
//    return sectionModel.sectionHeader.layoutConfig.itemSize.height;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section {
//    TCaseSectionModel * sectionModel = self.viewModel.arrayData[section];
//    return sectionModel.sectionFooter.layoutConfig.itemSize.height;
//}
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    TCaseSectionModel * sectionModel = self.viewModel.arrayData[indexPath.section];
//    if (kind == CHTCollectionElementKindSectionHeader) {
//        TCaseSectionHeader * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
//        header.titleLabel.numberOfLines = 0;
//        header.model = sectionModel.sectionHeader;
//        header.titleLabel.hidden = NO;
//        [[header viewWithTag:100] removeFromSuperview];
//        [_sharpLayer removeFromSuperlayer];
//        _sharpLayer = nil;
//        if ([header.titleLabel.text isEqualToString:@"猜你喜欢"]) {
//            header.titleLabel.backgroundColor = [UIColor clearColor];
//            header.backgroundColor = UIColorBackgroundLight;
//            
//            header.titleLabel.hidden = YES;
//            //重新添加一个label
//            if (![header viewWithTag:100]) {
//                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,74-18-22,80,22)];
//                titleLabel.tag = 100;
//                titleLabel.font = UIFontBold(18);
//                titleLabel.textColor = UIColorFromRGB(0x333333);
//                titleLabel.text = @"猜你喜欢";
//                [header addSubview:titleLabel];
//                
//                //9.21 上方加圆角
//                CAShapeLayer *layer = [CAShapeLayer layer];
//                UIBezierPath *path = [UIBezierPath bezierPath];
//                [path moveToPoint:CGPointMake(0, 0)];
//                [path addArcWithCenter:CGPointMake(12, 0) radius:12 startAngle:M_PI endAngle:0.5*M_PI clockwise:NO];
//                [path addLineToPoint:CGPointMake(kScreenWidth-12, 12)];
//                [path addArcWithCenter:CGPointMake(kScreenWidth-12, 0) radius:12 startAngle:1/2.f*M_PI endAngle:0 clockwise:NO];
//                [path addLineToPoint:CGPointMake(0, 0)];
//                [path stroke];
//                layer.path = path.CGPath;
//                layer.fillColor = [UIColor whiteColor].CGColor;
//                [header.layer addSublayer:layer];
//                _sharpLayer = layer;
//            }
//        }
//        return header;
//    } else if (kind == CHTCollectionElementKindSectionFooter) {
//        TCaseSectionFooter * footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
//        footer.model = sectionModel.sectionFooter;
//        if (sectionModel.sectionFooter.isCorner) {
//            UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, sectionModel.sectionFooter.layoutConfig.itemSize.height - 12, kScreenW, 12) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(12, 12)];
//            CAShapeLayer * layer = [CAShapeLayer layer];
//            layer.path = path.CGPath;
//            footer.layer.mask = layer;
//        } else {
//            footer.layer.mask = nil;
//        }
//        return footer;
//    }
//    
//    return [UICollectionReusableView new];
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    TCaseSectionModel * sectionModel = self.viewModel.arrayData[section];
//    return sectionModel.layoutConfig.sectionInset;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    TCaseSectionModel * sectionModel = self.viewModel.arrayData[section];
//    return sectionModel.layoutConfig.interitemSpacing;
//}

#pragma mark - Private

#pragma mark - Getters and Setters

- (GECollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout * layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.minimumColumnSpacing = 7;
        _collectionView = [[GECollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        
        [TMCardComponentHelper registCardComponentCellsInCollectionView:_collectionView];
//        [_collectionView registerNib:[UINib tmui_nibWithNibClass:[TCaseSectionHeader class]] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:@"header"];
//        [_collectionView registerNib:[UINib tmui_nibWithNibClass:[TCaseSectionFooter class]] forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
//        _collectionView.contentInset = UIEdgeInsetsMake([TCaseHeaderBannerView height], 0, 0, 0);
    }
    return _collectionView;
}

#pragma mark - Supperclass

#pragma mark - NSObject


@end
