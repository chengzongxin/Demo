//
//  THKDecorationToDoVC.m
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKDecorationToDoVC.h"
#import "THKDecorationToDoCell.h"
#import "THKDecorationToDoSectionHeaderView.h"
#import "THKDecorationToDoHeaderView.h"
#import "THKDynamicTabsWrapperScrollView.h"
#import "THKPageBGScrollView.h"
#import "THKDynamicTabsProtocol.h"

#define kStageMenuH 80
#define kStageSectionHeaderH 88
#define kHeaderViewH 300

@interface THKDecorationToDoVC ()<UITableViewDelegate,UITableViewDataSource,THKDynamicTabsProtocol>

@property (nonatomic, strong) THKDecorationToDoVM *viewModel;

@property (nonatomic, strong) THKDynamicTabsWrapperScrollView *wrapperScrollView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) THKDecorationToDoHeaderView *headerView;

@property (nonatomic, assign) BOOL isScrolling;



@end

@implementation THKDecorationToDoVC
@dynamic viewModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.thk_title = @"装修待办";
    self.thk_navBar.backgroundColor = UIColorClear;
    self.view.backgroundColor = UIColorWhite;
    
    [self.view addSubview:self.wrapperScrollView];
    [self.wrapperScrollView addSubview:self.tableView];
    [self.wrapperScrollView addSubview:self.headerView];
    
    
}

- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self);
    [[RACObserve(self.viewModel, stageList) ignore:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        THKDecorationToDoHeaderViewModel *headerVM = [[THKDecorationToDoHeaderViewModel alloc] initWithModel:x];
        [self.headerView bindViewModel:headerVM];
    }];
    
    [[RACObserve(self.viewModel, upcomingList) ignore:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self.viewModel.requestCommand execute:nil];
    
//    [self.viewModel.stageCommand execute:nil];
//    [self.viewModel.listCommand execute:nil];
}



#pragma mark UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 88;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    THKDecorationToDoSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(THKDecorationToDoSectionHeaderView.class)];
    THKDecorationUpcomingListModel *sectionModel = self.viewModel.upcomingList[section];
    headerView.model = sectionModel;
    
    headerView.tapSection = ^(UIButton * _Nonnull btn) {
        sectionModel.isOpen = !sectionModel.isOpen;
        [tableView reloadSection:section withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.upcomingList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.upcomingList[section].isOpen ? self.viewModel.upcomingList[section].childList.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THKDecorationToDoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKDecorationToDoCell.class) forIndexPath:indexPath];
    THKDecorationUpcomingChildListModel *model =self.viewModel.upcomingList[indexPath.section].childList[indexPath.item];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%@",self.tableView.indexPathsForVisibleRows);
//    if (self.tableView.indexPathsForVisibleRows.count) {
//        self.headerView.selectIndex = self.tableView.indexPathsForVisibleRows.firstObject.section;
//    }
    if (self.isScrolling) {
        return;
    }
    
    CGFloat y = scrollView.contentOffset.y;
    int firstSection = -1;
    for (int i = 0; i < self.tableView.numberOfSections; i++) {
        CGFloat sectionY = [self.tableView rectForSection:i].origin.y;
        if (sectionY > y - kStageMenuH / 2) {
            firstSection = i;
            break;
        }
    }
    
    if (firstSection != -1) {
        self.headerView.selectIndex = firstSection;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        self.isScrolling = NO; // 还原主动执行选择的操作标志
    }
}

#pragma mark - Private
- (void)scrollToSection:(NSInteger)section{
    self.isScrolling = YES;
//    [UIView beginAnimations:@"myAnimationId" context:nil];
//    // Set duration here
//    [UIView setAnimationDuration:0.2];
//    [CATransaction begin];
//    [CATransaction setCompletionBlock:complete];
//
//    [tableView beginUpdates];
//    // my table changes
//    scrollBlock();
//    [tableView endUpdates];
//
//    [CATransaction commit];
//    [UIView commitAnimations];
    
    CGPoint point = [self.tableView rectForHeaderInSection:section].origin;
    if (self.wrapperScrollView.pin) {
        
//        [UIView animateWithDuration:0.25 animations:^{
                    
            [self.tableView setContentOffset:point animated:YES];
//                } completion:^(BOOL finished) {
//
//                    self.isScrolling = NO;
//                }];
        
    }else{
        [self.wrapperScrollView setContentOffset:CGPointZero animated:YES];
        // 这里要先设置，吸顶pin，否则内部会阻拦手动滑动事件
        [self.wrapperScrollView tmui_setValue:@1 forKey:@"pin"];
        [self.tableView setContentOffset:point animated:NO];
    }
}

#pragma mark - getter

- (THKDynamicTabsWrapperScrollView *)wrapperScrollView{
    if (!_wrapperScrollView) {
        _wrapperScrollView = [[THKDynamicTabsWrapperScrollView alloc] initWithFrame:self.view.bounds];
        _wrapperScrollView.contentInset = UIEdgeInsetsMake(kHeaderViewH, 0, 0, 0);
        _wrapperScrollView.lockArea = tmui_navigationBarHeight() + kStageMenuH;
        _wrapperScrollView.contentSize = CGSizeMake(TMUI_SCREEN_WIDTH, kHeaderViewH + self.view.height);
        if (@available(iOS 11.0, *)) {
            _wrapperScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _wrapperScrollView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, TMUI_SCREEN_HEIGHT - tmui_navigationBarHeight() - kStageMenuH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, _tableView.height - kStageSectionHeaderH, 0);
        [_tableView registerClass:THKDecorationToDoCell.class forCellReuseIdentifier:NSStringFromClass(THKDecorationToDoCell.class)];
        [_tableView registerClass:THKDecorationToDoSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(THKDecorationToDoSectionHeaderView.class)];
        
    }
    return _tableView;
}

- (THKDecorationToDoHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[THKDecorationToDoHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, -kHeaderViewH, TMUI_SCREEN_WIDTH, kHeaderViewH);
        _headerView.backgroundColor = UIColor.orangeColor;
        @weakify(self);
        _headerView.tapItem = ^(NSInteger index) {
            @strongify(self);
            [self scrollToSection:index];
        };
    }
    return _headerView;
}


- (UIScrollView *)contentScrollView{
    return _tableView;
}

@end
