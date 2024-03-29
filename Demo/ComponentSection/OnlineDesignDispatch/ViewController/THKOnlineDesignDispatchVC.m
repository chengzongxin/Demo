//
//  THKOnlineDesignVC.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignDispatchVC.h"
#import "THKOnlineDesignHeader.h"
#import "THKOnlineDesignSectionHeader.h"
#import "THKOnlineDesignSectionFooter.h"
#import "THKRecordTool.h"
#import "THKOnlineDesignSearchAreaVC.h"
#import "THKRecordAnimationView.h"
#import "THKOnlineDesignDistributeAnimationView.h"

static CGFloat const kBGCoverHeight = 252;
static CGFloat const kHeaderHeight = 100;

@interface THKOnlineDesignDispatchVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,THKOnlineDesignBaseCellDelegate>

@property (nonatomic, strong) THKOnlineDesignDispatchVM *viewModel;

@property (nonatomic, strong) UIImageView *bgImgV;

@property (nonatomic, strong) UIView *contentBgView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) THKOnlineDesignHeader *header;

@property (nonatomic, strong) THKRecordAnimationView *recordAnimationView;

@property (nonatomic, strong) THKOnlineDesignDistributeAnimationView *loadingAnimationView;

@end

@implementation THKOnlineDesignDispatchVC
@dynamic viewModel;

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorWhite;
    
    self.thk_navBar.backgroundColor = UIColorClear;
    
    [self.view addSubview:self.bgImgV];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - Public
- (void)bindViewModel{
    self.viewModel.vcLayout = self.layout;
    @weakify(self);
    [[RACObserve(self.viewModel, topImgUrl) ignore:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:x] options:0 progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.bgImgV.image = image;
                });
            }else{
                NSLog(@"%@",error);
            }
        }];
    }];
    
    RAC(self.header.titleLbl,text) = [RACObserve(self.viewModel, topContent1) ignore:nil];
    RAC(self.header.subtitleLbl,text) = [RACObserve(self.viewModel, topContent2) ignore:nil];
    
    [self.viewModel.refreshSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.view.tmui_emptyView remove];
        [self.collectionView reloadData];
    }];
    
    [self.viewModel.emptySignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [TMEmptyView showEmptyInView:self.view contentType:[x integerValue]];
    }];
    
    // 录音完成
    [THKRecordTool sharedInstance].recordFinish = ^(THKAudioDescription * _Nullable audioDesc) {
        [self stopRecordAnimation];
        
        if (audioDesc.duration < 3) {
            [TMToast toast:@"录音太短了，少于3秒"];
            [[THKRecordTool sharedInstance] deleteFilePath:audioDesc.filePath];
            return;
        }
        
        [self.viewModel.addAudioCommand execute:audioDesc];
        
    };
    
    [self.viewModel.commitCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self stopLoadingAnimation];
    }];
    
    [self.viewModel.commitCommand.errors subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        [TMToast toast:@"网络异常！请稍后再试"];
        [self stopLoadingAnimation];
    }];
    
    [self.viewModel.requestCommand execute:RACTuplePack(@(self.viewModel.status),nil)];
}

#pragma mark - Event Respone
- (void)clickCommit{
    [self.viewModel.commitCommand execute:nil];
    [self showLoadingAnimation];
}

#pragma mark - Delegate
#pragma mark - <Cell Event>
- (void)houseTypeEditClick:(UIView *)btn indexPath:(NSIndexPath *)indexPath{
    [self searchAreaBtnClick:btn];
}

- (void)searchAreaBtnClick:(UIView *)btn{
    THKOnlineDesignSearchAreaVM *vm = [[THKOnlineDesignSearchAreaVM alloc] init];
    THKOnlineDesignSearchAreaVC *vc = [[THKOnlineDesignSearchAreaVC alloc] initWithViewModel:vm];
    [self.navigationController pushViewController:vc animated:YES];
    @weakify(self);
    vc.selectHouseTypeBlock = ^(THKOnlineDesignItemHouseTypeModel * _Nonnull houseTypeMdel) {
        @strongify(self);
        [self.viewModel.selectHouseTypeCommand execute:houseTypeMdel];
        [self.navigationController popToViewController:self animated:YES];
    };
}

- (void)recordBtnTouchDown:(UIButton *)btn{
    NSString *timespace = [NSDate.date.tmui_stringWithDateFormatYMDHMS tmui_stringByReplacingPattern:@"[-: ]" withString:@""];
    NSString *fileName = [NSString stringWithFormat:@"OnlineDesign1_%@",timespace];
    [[THKRecordTool sharedInstance] startRecord:fileName];
    
    [self showRecordAnimation];
}

- (void)recordBtnTouchUp:(UIButton *)btn{
    [[THKRecordTool sharedInstance] stopRecord];
}

- (void)recordPlayClick:(UIView *)view idx:(NSUInteger)idx indexPath:(NSIndexPath *)indexPath{
    THKAudioDescription *demandDesc = self.viewModel.datas[indexPath.section].item.demandModel.demandDesc[idx];
    [[THKRecordTool sharedInstance] play:demandDesc.filePath];
}

- (void)recordCloseClick:(UIView *)view idx:(NSUInteger)idx indexPath:(NSIndexPath *)indexPath{
    [self.collectionView performBatchUpdates:^{
        [self.viewModel.deleteAudioCommand execute:@(idx)];
    } completion:^(BOOL finished) {
        THKOnlineDesignHouseDemandCell *cell = (THKOnlineDesignHouseDemandCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell bindWithModel:self.viewModel.datas[indexPath.section].item.items[indexPath.item]];
        // 不能使用刷新，触发刷新会清除textView
//        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }];
}

- (void)cancelRecordVoice:(UIButton *)btn{
    
}

- (void)upswipeCancelRecordVoice:(UIButton *)btn{
    [[THKRecordTool sharedInstance] deleteRecording];
    
    [self stopRecordAnimation];
}

- (void)downSwipeContinueRecordVoice:(UIButton *)btn{
    
}

- (void)demandInput:(TMUITextView *)view text:(NSString *)text heightChange:(BOOL)heightChange height:(CGFloat)height indexPath:(NSIndexPath *)indexPath{
    [self.viewModel updateDemandDesc:text];
}

#pragma mark - <UICollectionViewDataSource>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.bounds.size.width, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (collectionView.numberOfSections - 1 == section) {
        return CGSizeMake(self.view.bounds.size.width, 120);
    }else{
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.viewModel.datas[indexPath.section].item.itemSize;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.datas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    THKOnlineDesignSectionModel *sectionModel = self.viewModel.datas[section];
    return sectionModel.isFold ? 0 : sectionModel.item.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger type = self.viewModel.datas[indexPath.section].item.type;
    Class cls = self.viewModel.datas[indexPath.section].item.cellClass;
    NSString *cellIdentifier = NSStringFromClass(cls);
    THKOnlineDesignBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell bindWithModel:self.viewModel.datas[indexPath.section].item.items[indexPath.item]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        THKOnlineDesignSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(THKOnlineDesignSectionHeader.class) forIndexPath:indexPath];
        THKOnlineDesignSectionModel *sectionModel = self.viewModel.datas[indexPath.section];
        if (sectionModel.item.type == THKOnlineDesignItemDataType_HouseTypeModel) {
            header.numLbl.text = @"1";
        }else{
            header.numLbl.text = @(sectionModel.item.type).stringValue;
        }
        header.titleLbl.text = sectionModel.title;
        if (sectionModel.isFold) {
            header.selectString = sectionModel.item.items[sectionModel.selectIdx];
        }else{
            header.selectString = nil;
        }
        @weakify(self);
        header.editBlock = ^(UIButton * _Nonnull btn) {
            @strongify(self);
            sectionModel.isFold = NO;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        };
        return header;
    } else if (kind == UICollectionElementKindSectionFooter) {
        THKOnlineDesignSectionFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(THKOnlineDesignSectionFooter.class) forIndexPath:indexPath];
        @weakify(self);
        footer.commitClickBlock = ^(UIButton * _Nonnull btn) {
            @strongify(self);
            [self clickCommit];
        };
        return footer;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    THKOnlineDesignSectionModel *sectionModel = self.viewModel.datas[indexPath.section];
    if (sectionModel.item.type == THKOnlineDesignItemDataType_HouseStyle || sectionModel.item.type == THKOnlineDesignItemDataType_HouseBudget) {
        sectionModel.isFold = YES;
        sectionModel.selectIdx = indexPath.item;
        [collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        
        [self.viewModel.selectItem sendNext:RACTuplePack(@(sectionModel.item.type),@(indexPath.item))];
    }
    
}

#pragma mark - Private
- (void)showRecordAnimation{
    [self.recordAnimationView playInView:self.view];
}

- (void)stopRecordAnimation{
    [self.recordAnimationView stop];
}

- (void)showLoadingAnimation{
    [self.loadingAnimationView playInView:self.view];
}

- (void)stopLoadingAnimation{
    [self.loadingAnimationView stop];
}

#pragma mark - Getters and Setters

- (UIImageView *)bgImgV{
    if (!_bgImgV) {
        _bgImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"od_bg_head")];
        CGFloat bgImgH = _bgImgV.image.size.height/_bgImgV.image.size.width*TMUI_SCREEN_WIDTH;
        _bgImgV.frame = CGRectMake(0, 0, TMUI_SCREEN_WIDTH, bgImgH);
    }
    return _bgImgV;
}

- (UIView *)contentBgView{
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, -kHeaderHeight, TMUI_SCREEN_WIDTH, 2000)];
        _contentBgView.backgroundColor = UIColorHex(D8DCE2);
        _contentBgView.userInteractionEnabled = NO;
//#warning DEBUG
//        _contentBgView.hidden = YES;
    }
    return _contentBgView;
}

- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 50);
        _layout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 0);
        _layout.sectionInset = UIEdgeInsetsMake(0, 22, 0, 22); // item 间距
        _layout.minimumLineSpacing = 10;  // 两行之间间隔
        _layout.minimumInteritemSpacing = 10; // 两列之间间隔
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = UIColorClear;//
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = NO;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_collectionView registerClass:THKOnlineDesignSectionHeader.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(THKOnlineDesignSectionHeader.class)];
        [_collectionView registerClass:THKOnlineDesignSectionFooter.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(THKOnlineDesignSectionFooter.class)];
//        [_collectionView registerClass:THKOnlineDesignBaseCell.class forCellWithReuseIdentifier:NSStringFromClass(THKOnlineDesignBaseCell.class)];
        
        _collectionView.contentInset = UIEdgeInsetsMake(kHeaderHeight+kBGCoverHeight, 0, 40, 0);
        [_collectionView insertSubview:self.header atIndex:0];
        [_collectionView insertSubview:self.contentBgView atIndex:0];
        self.contentBgView.layer.zPosition = -100;
//        [_collectionView.layer insertSublayer:self.contentBgView.layer atIndex:0];
        
        @weakify(_collectionView);
        [self.viewModel.cellDict.allValues enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(_collectionView);
            [_collectionView registerClass:obj forCellWithReuseIdentifier:NSStringFromClass(obj)];
        }];
    }
    return _collectionView;
}

- (THKOnlineDesignHeader *)header{
    if (!_header) {
        _header = [[THKOnlineDesignHeader alloc] initWithFrame:CGRectMake(0, -kHeaderHeight, TMUI_SCREEN_WIDTH, kHeaderHeight)];
    }
    return _header;
}

- (THKRecordAnimationView *)recordAnimationView{
    if (!_recordAnimationView) {
        _recordAnimationView = [[THKRecordAnimationView alloc] initWithFrame:self.view.bounds];
    }
    return _recordAnimationView;
}

- (THKOnlineDesignDistributeAnimationView *)loadingAnimationView{
    if (!_loadingAnimationView) {
        _loadingAnimationView = [[THKOnlineDesignDistributeAnimationView alloc] initWithFrame:self.view.bounds];
    }
    return _loadingAnimationView;
}

#pragma mark - Supperclass

#pragma mark - NSObject


#pragma mark - NSObject
+ (BOOL)canHandleRouter:(TRouter *)router {
//    if ([router routerMatch:THKRouterPage_todoList]) {
//        return YES;
//    }
    return NO;
}

+ (id)createVCWithRouter:(TRouter *)router {
    THKOnlineDesignDispatchVM *viewModel = [[THKOnlineDesignDispatchVM alloc] init];
    return  [[self alloc] initWithViewModel:viewModel];
}

@end
