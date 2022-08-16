//
//  THKOnlineDesignSearchAreaVC.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import "THKOnlineDesignSearchAreaVC.h"
#import "THKOnlineDesignSearchAreaContentView.h"
#import "THKOnlineDesignSearchAreaHotView.h"
#import "THKOnlineDesignSearchAreaListView.h"
#import "THKOnlineDesignSearchHouseListView.h"
#import "THKOnlineDesignHouseTypeListVC.h"
#import "THKOnlineDesignUploadHouseTypeView.h"
#import "THKOnlineDesignUploadHouseVC.h"

typedef enum : NSUInteger {
    THKOnlineDesignSearchAreaContentType_Hot,
    THKOnlineDesignSearchAreaContentType_AreaList,
    THKOnlineDesignSearchAreaContentType_HouseList,
} THKOnlineDesignSearchAreaContentType;

@interface THKOnlineDesignSearchAreaVC ()<TMUISearchBarDelegate>

@property (nonatomic, strong) THKOnlineDesignSearchAreaVM *viewModel;

@property (nonatomic, strong) TMUISearchBar *searchBar;

@property (nonatomic, assign) THKOnlineDesignSearchAreaContentType contentType;

@property (nonatomic, strong) THKOnlineDesignSearchAreaContentView *contentView;

@property (nonatomic, strong) THKOnlineDesignSearchAreaHotView *hotView;

@property (nonatomic, strong) THKOnlineDesignSearchAreaListView *areaView;

@property (nonatomic, strong) THKOnlineDesignSearchHouseListView *houseView;

@end

@implementation THKOnlineDesignSearchAreaVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorWhite;
    
    self.thk_title = @"请输入小区名称";
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.contentView];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(THKNavBarHeight + 20);
        make.left.right.equalTo(self.view).inset(20);
        make.height.mas_equalTo(46);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(20);
        make.left.right.equalTo(self.view).inset(0);
        make.bottom.mas_equalTo(0);
    }];
    
    self.contentType = THKOnlineDesignSearchAreaContentType_Hot;
}

- (void)bindViewModel{
    @weakify(self);
    [self.viewModel.requestCommand.nextSignal subscribeNext:^(THKOnlineDesignSearchAreaResponse *  _Nullable x) {
        @strongify(self);
        self.areaView.keyWord = self.searchBar.text;
        self.areaView.items = x.data.items;
    }];
}

- (void)searchBarTextChange:(TMUISearchBar *)searchBar textField:(UITextField *)textField{
    if (textField.text.length == 0) {
        self.contentType = THKOnlineDesignSearchAreaContentType_Hot;
    }else{
        self.contentType = THKOnlineDesignSearchAreaContentType_AreaList;
        [self.viewModel.requestCommand execute:RACTuplePack(textField.text,@(1130))];
    }
}


- (void)setContentType:(THKOnlineDesignSearchAreaContentType)contentType{
    _contentType = contentType;
    
    if (contentType == THKOnlineDesignSearchAreaContentType_Hot) {
        [self setupContentView:self.hotView];
    }else if (contentType == THKOnlineDesignSearchAreaContentType_AreaList) {
        [self setupContentView:self.areaView];
    }else if (contentType == THKOnlineDesignSearchAreaContentType_HouseList) {
        [self setupContentView:self.houseView];
    }
}

- (void)setupContentView:(UIView *)contentTypeView{
    [self.contentView removeAllSubviews];
    [self.contentView addSubview:contentTypeView];
    [contentTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)clickUpload{
    THKOnlineDesignUploadHouseVM *vm = [[THKOnlineDesignUploadHouseVM alloc] init];
    THKOnlineDesignUploadHouseVC *vc = [[THKOnlineDesignUploadHouseVC alloc] initWithViewModel:vm];
    [self.navigationController pushViewController:vc animated:YES];
    vc.selectHouseTypeBlock = self.selectHouseTypeBlock;
}

- (void)pushHouseListVC:(NSString *)wd{
    THKOnlineDesignHouseTypeListVM *vm = [[THKOnlineDesignHouseTypeListVM alloc] init];
    vm.wd = wd;
    THKOnlineDesignHouseTypeListVC *vc = [[THKOnlineDesignHouseTypeListVC alloc] initWithViewModel:vm];
    [self.navigationController pushViewController:vc animated:YES];
    vc.selectHouseTypeBlock = self.selectHouseTypeBlock;
}

- (TMUISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[TMUISearchBar alloc] initWithStyle:TMUISearchBarStyle_City];
        _searchBar.delegate = self;
        THKOnlineDesignUploadHouseTypeView *inputAccessoryView = [[THKOnlineDesignUploadHouseTypeView alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, 40)];
        @weakify(self);
        inputAccessoryView.clickUploadBlock = ^{
            @strongify(self);
            [self clickUpload];
        };
        _searchBar.textField.inputAccessoryView = inputAccessoryView;
        _searchBar.currentCity = @"深圳";
    }
    return _searchBar;
}

- (THKOnlineDesignSearchAreaContentView *)contentView{
    if (!_contentView) {
        _contentView = [[THKOnlineDesignSearchAreaContentView alloc] init];
    }
    return _contentView;
}

- (THKOnlineDesignSearchAreaHotView *)hotView{
    if (!_hotView) {
        _hotView = [[THKOnlineDesignSearchAreaHotView alloc] init];
        _hotView.areaList = @[@"东野圭吾", @"三体", @"爱", @"红楼梦", @"理智与情感", @"读书热榜", @"免费榜"];
        @weakify(self);
        _hotView.tapItem = ^(NSInteger idx) {
            @strongify(self);
            [self pushHouseListVC:self.hotView.areaList[idx]];
        };
        _hotView.clickUploadBlock = ^{
            @strongify(self);
            [self clickUpload];
        };
    }
    return _hotView;
}

- (THKOnlineDesignSearchAreaListView *)areaView{
    if (!_areaView) {
        _areaView = [[THKOnlineDesignSearchAreaListView alloc] init];
        @weakify(self);
        _areaView.tapItem = ^(NSInteger idx) {
            @strongify(self);
            [self pushHouseListVC:self.areaView.items[idx].community_name];
        };
    }
    return _areaView;
}

- (THKOnlineDesignSearchHouseListView *)houseView{
    if (!_houseView) {
        _houseView = [[THKOnlineDesignSearchHouseListView alloc] init];
    }
    return _houseView;
}

@end
