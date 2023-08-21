//
//  DynamicTabChildVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/17.
//

#import "DynamicTabChildVC.h"
#import <MJRefresh.h>
#import "TestViewController.h"
#import "THKDynamicTabsProtocol.h"
#import "THKDynamicTabsManager.h"
@interface DynamicTabChildVC ()<UITableViewDelegate,UITableViewDataSource,THKDynamicTabsManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger count;

@end

@implementation DynamicTabChildVC
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    self.navigationController.navigationBar.hidden = NO;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _count = 30;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
//    self.tableView.tmui_isAddRefreshControl = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            self.count = 30;
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            self.count += 30;
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        });
    }];
//    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(20, 200, self.view.width - 40, 100)];
//    self.bottomView.backgroundColor = [UIColor redColor];
//
//    [self.view addSubview:self.bottomView];
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(20);
//        make.right.mas_equalTo(-20);
//        make.bottom.mas_equalTo(-40);
//        make.height.mas_equalTo(100);
//    }];
}

// 遵守wrapper滑动协议联动，这里回调的是最终值，不受交互偏移影响
- (void)wrapperScrollViewDidScroll:(THKDynamicTabsWrapperScrollView *)wrapperScrollView{
//    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(-40 + wrapperScrollView.contentOffset.y);
//    }];
}
#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",indexPath);
    [self.navigationController pushViewController:TestViewController.new animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}


#pragma mark - Page Delegate

//- (__kindof UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index{
//    return self.tableView;
//}
//
//- (UIScrollView *)contentScrollView{
//    return self.tableView;
//}
//
//- (void)tabbarDidRepeatSelect{
//    
//}

+ (BOOL)canHandleRouter:(TRouter *)router{
    if ([router routerMatch:THKRouterPage_HomeRecommendNew]) {
        return YES;
    }
    return NO;
}

+ (id)createVCWithRouter:(TRouter *)router{
    return [[self alloc] init];
}

@end
