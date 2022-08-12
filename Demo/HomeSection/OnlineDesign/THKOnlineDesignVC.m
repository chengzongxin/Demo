//
//  THKOnlineDesignVC.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignVC.h"
#import "THKOnlineDesignHeader.h"
#import "THKOnlineDesignSectionHeader.h"
#import "THKOnlineDesignBaseCell.h"
#import "THKOnlineDesignHouseTypeCell.h"
#import "THKOnlineDesignHouseNameCell.h"
#import "THKOnlineDesignHouseStyleCell.h"
#import "THKOnlineDesignHouseBudgetCell.h"
#import "THKOnlineDesignHouseDemandCell.h"
#import "THKRecordTool.h"

static CGFloat const kHeaderHeight = 150.0;

@interface THKOnlineDesignVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,THKOnlineDesignBaseCellDelegate>

@property (nonatomic, strong) THKOnlineDesignVM *viewModel;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) THKOnlineDesignHeader *header;

@property (nonatomic, strong) TMUIOrderedDictionary *cellDict;

@end

@implementation THKOnlineDesignVC
@dynamic viewModel;

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - Public
- (void)bindViewModel{
    @weakify(self);
    [self.viewModel.refreshSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.view.tmui_emptyView remove];
        [self.collectionView reloadData];
    }];
    
    [self.viewModel.emptySignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [TMEmptyView showEmptyInView:self.view contentType:[x integerValue]];
    }];
    
    [THKRecordTool sharedInstance].recordFinish = ^(NSString *filePath) {
        // 录音完成
        [self.viewModel.addAudioCommand execute:filePath];
//        [[THKRecordTool sharedInstance] play:filePath];
    };
    
    
    [self.viewModel.requestCommand execute:nil];
}

#pragma mark - Event Respone

#pragma mark - Delegate

- (void)clickRecordBtn:(UIButton *)btn{
    NSLog(@"%@",btn);
}

- (void)recordBtnTouchDown:(UIButton *)btn{
    NSLog(@"recordBtnTouchDown - %@",btn);
    NSString *timespace = [NSDate.date.tmui_stringWithDateFormatYMDHMS tmui_stringByReplacingPattern:@"[-: ]" withString:@""];
    NSString *fileName = [NSString stringWithFormat:@"OnlineDesign1_%@",timespace];
    [[THKRecordTool sharedInstance] startRecord:fileName];
}

- (void)recordBtnTouchUp:(UIButton *)btn{
    NSLog(@"recordBtnTouchDUp - %@",btn);
    [[THKRecordTool sharedInstance] stopRecord];
}

#pragma mark UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        case 1:
            return CGSizeMake(TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.layout.sectionInset), 50);
            break;
        case 2:
        case 3:
            {
                CGFloat column = 4;
                CGFloat width = floor((TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.layout.sectionInset) - (self.layout.minimumInteritemSpacing)*(column - 1))/column);
                return CGSizeMake(width, 50);
            }
            break;
        case 4:
        {
            NSArray *demans = self.viewModel.datas[indexPath.section].item.items[indexPath.item];
            return CGSizeMake(TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.layout.sectionInset), 22 * demans.count + 44 + 20);
        }
            break;
        default:
            break;
    }
    return CGSizeZero;
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.datas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.datas[section].item.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger type = self.viewModel.datas[indexPath.section].item.type;
    Class cls = self.cellDict[@(type)];
    NSString *cellIdentifier = NSStringFromClass(cls);
    THKOnlineDesignBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell bindWithModel:self.viewModel.datas[indexPath.section].item.items[indexPath.item]];
    cell.backgroundColor = UIColor.tmui_randomColor;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        THKOnlineDesignSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(THKOnlineDesignSectionHeader.class) forIndexPath:indexPath];
        header.titleLbl.text = self.viewModel.datas[indexPath.section].title;
        return header;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class) forIndexPath:indexPath];
        return footer;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark - Private


#pragma mark - Getters and Setters

- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 50);
        _layout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 25);
        _layout.sectionInset = UIEdgeInsetsMake(10, 22, 10, 22); // item 间距
        _layout.minimumLineSpacing = 10;  // 两行之间间隔
        _layout.minimumInteritemSpacing = 10; // 两列之间间隔
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = UIColorHex(#DEEEFF);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_collectionView registerClass:THKOnlineDesignSectionHeader.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(THKOnlineDesignSectionHeader.class)];
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class)];
//        [_collectionView registerClass:THKOnlineDesignBaseCell.class forCellWithReuseIdentifier:NSStringFromClass(THKOnlineDesignBaseCell.class)];
        
        _collectionView.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
        [_collectionView insertSubview:self.header atIndex:0];
        
        @weakify(_collectionView);
        [self.cellDict.allValues enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

- (TMUIOrderedDictionary *)cellDict{
    if (!_cellDict) {
        _cellDict = [[TMUIOrderedDictionary alloc] initWithKeysAndObjects:
                     @0,THKOnlineDesignBaseCell.class,
                     @1,THKOnlineDesignHouseTypeCell.class,
                     @2,THKOnlineDesignHouseNameCell.class,
                     @3,THKOnlineDesignHouseStyleCell.class,
                     @4,THKOnlineDesignHouseBudgetCell.class,
                     @5,THKOnlineDesignHouseDemandCell.class,
        nil];
    }
    return _cellDict;
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
    THKOnlineDesignVM *viewModel = [[THKOnlineDesignVM alloc] init];
    return  [[self alloc] initWithViewModel:viewModel];
}

@end
