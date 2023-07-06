//
//  THKReferenPictureListVC.m
//  Demo
//
//  Created by Joe.cheng on 2023/7/5.
//

#import "THKReferenPictureListVC.h"
#import "THKReferenPictureListLayout.h"
#import "MJRefresh.h"

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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
    cell.backgroundColor = UIColor.tmui_randomColor;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark - Private

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
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
    }
    return _collectionView;
}


@end
