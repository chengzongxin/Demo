//
//  THKOnlineDesignHouseListVC.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import "THKOnlineDesignHouseTypeListVC.h"
#import "THKOnlineDesignHouseTypeListCell.h"
#import "THKOnlineDesignModel.h"
#import "THKOnlineDesignUploadNoHouseTypeView.h"
#import "THKOnlineDesignUploadHouseVC.h"

@interface THKOnlineDesignHouseTypeListVC () <UICollectionViewDelegate,UICollectionViewDataSource,TMUISearchBarDelegate>

@property (nonatomic, strong) THKOnlineDesignHouseTypeListVM *viewModel;

@property (nonatomic, strong) TMUISearchBar *searchBar;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) THKOnlineDesignUploadNoHouseTypeView *noHouseView;

@end

@implementation THKOnlineDesignHouseTypeListVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.thk_title = @"请选择户型";
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.collectionView];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(THKNavBarHeight + 20);
        make.left.right.equalTo(self.view).inset(20);
        make.height.mas_equalTo(46);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(20);
        make.left.right.equalTo(self.view).inset(0);
        make.bottom.mas_equalTo(0);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.collectionView.numberOfSections && ([self.collectionView numberOfItemsInSection:0] > 12)) {
            
            [self.view addSubview:self.noHouseView];
            [self.noHouseView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view).inset(20);
                make.bottom.mas_equalTo(-88);
                make.height.mas_equalTo(75);
            }];
        }else{
            [self.collectionView addSubview:self.noHouseView];
            self.noHouseView.frame = CGRectMake(20, self.collectionView.contentSize.height, TMUI_SCREEN_WIDTH - 40, 75);
        }
    });
    
    
}

- (void)bindViewModel{
    [super bindViewModel];
    
    [self.viewModel bindWithView:self.view scrollView:self.collectionView appenBlock:^NSArray * _Nonnull(THKResponse * _Nonnull x) {
        THKOnlineDesignSearchHouseResponse *response = (THKOnlineDesignSearchHouseResponse *)x;
        return response.data.items;
    }];
    
    [self.viewModel addRefreshHeader];
    [self.viewModel addRefreshFooter];
    
    [self.viewModel.requestCommand execute:@1];
}


#pragma mark UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat column = 2;
    CGFloat width = floor((TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.layout.sectionInset) - (self.layout.minimumInteritemSpacing)*(column - 1))/column);
    return CGSizeMake(width, width + 45);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THKOnlineDesignHouseTypeListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(THKOnlineDesignHouseTypeListCell.class) forIndexPath:indexPath];
    THKOnlineDesignHouseListItemModel *model = self.viewModel.data[indexPath.row];
    cell.model = model;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class) forIndexPath:indexPath];
        return header;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class) forIndexPath:indexPath];
        return footer;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectHouseTypeBlock) {
        THKOnlineDesignHouseListItemModel *model = self.viewModel.data[indexPath.row];
        THKOnlineDesignItemHouseTypeModel *data = [THKOnlineDesignItemHouseTypeModel new];
        data.picUrl = model.image;
        data.houseArea = model.community_name;
        data.houseType = model.structure;
        data.buildArea = model.building_area;
        self.selectHouseTypeBlock(data);
    }
}

#pragma mark - Private
- (void)pushUploadVC{
    THKOnlineDesignUploadHouseVM *vm = [[THKOnlineDesignUploadHouseVM alloc] init];
    THKOnlineDesignUploadHouseVC *vc = [[THKOnlineDesignUploadHouseVC alloc] initWithViewModel:vm];
    [self.navigationController pushViewController:vc animated:YES];
    vc.selectHouseTypeBlock = self.selectHouseTypeBlock;
}

#pragma mark - Getters and Setters
- (TMUISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[TMUISearchBar alloc] initWithStyle:TMUISearchBarStyle_City];
        _searchBar.isCanInput = NO;
        _searchBar.text = self.viewModel.wd;
        @weakify(self);
        _searchBar.textBegin = ^(UITextField * _Nonnull textField) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:NO];
        };
    }
    return _searchBar;
}

- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 0);
        _layout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 0);
        _layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20); // item 间距
        _layout.minimumLineSpacing = 15;  // 两行之间间隔
        _layout.minimumInteritemSpacing = 15; // 两列之间间隔
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
//        _collectionView.backgroundColor = UIColorHex(#DEEEFF);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 160, 0);
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class)];
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class)];
        [_collectionView registerClass:THKOnlineDesignHouseTypeListCell.class forCellWithReuseIdentifier:NSStringFromClass(THKOnlineDesignHouseTypeListCell.class)];
    }
    return _collectionView;
}


- (THKOnlineDesignUploadNoHouseTypeView *)noHouseView{
    if (!_noHouseView) {
        _noHouseView = [THKOnlineDesignUploadNoHouseTypeView new];
        @weakify(self);
        _noHouseView.clickUploadBlock = ^{
            @strongify(self);
            [self pushUploadVC];
        };
    }
    return _noHouseView;
}

@end
