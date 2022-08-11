//
//  THKOnlineDesignVC.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignVC.h"
#import "THKOnlineDesignHeader.h"
#import "THKOnlineDesignSectionHeader.h"
#import "THKOnlineDesignCell.h"

static CGFloat const kHeaderHeight = 150.0;

@interface THKOnlineDesignVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) THKOnlineDesignVM *viewModel;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) THKOnlineDesignHeader *header;

@end

@implementation THKOnlineDesignVC
@dynamic viewModel;

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    [self.viewModel.requestCommand execute:nil];
}

#pragma mark - Public
- (void)bindViewModel{
    @weakify(self);
    [self.viewModel.requestCommand.nextSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    [self.viewModel.requestCommand.errorSignal subscribeNext:^(id  _Nullable x) {
            
    }];
}

#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat column = 4;
    CGFloat width = floor((TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.layout.sectionInset) - (self.layout.minimumInteritemSpacing)*(column - 1))/column);
    return CGSizeMake(width, 50);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.datas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.datas[section].item.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THKOnlineDesignCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(THKOnlineDesignCell.class) forIndexPath:indexPath];
    cell.backgroundColor = UIColor.tmui_randomColor;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        THKOnlineDesignSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(THKOnlineDesignSectionHeader.class) forIndexPath:indexPath];
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
        [_collectionView registerClass:THKOnlineDesignCell.class forCellWithReuseIdentifier:NSStringFromClass(THKOnlineDesignCell.class)];
        
        _collectionView.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
        [_collectionView insertSubview:self.header atIndex:0];
    }
    return _collectionView;
}

- (THKOnlineDesignHeader *)header{
    if (!_header) {
        _header = [[THKOnlineDesignHeader alloc] initWithFrame:CGRectMake(0, -kHeaderHeight, TMUI_SCREEN_WIDTH, kHeaderHeight)];
    }
    return _header;
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
