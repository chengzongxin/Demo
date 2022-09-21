//
//  THKGraphicDetailVC.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import "THKGraphicDetailVC.h"
#import "THKGraphicDetailSectionHeaderView.h"
#import "THKGraphicDetailCell.h"
#import "THKGraphicDetailModel.h"
#import "THKDynamicTabsWrapperScrollView.h"
#import "THKGraphicDetailHeaderView.h"
#import "THKGraphicDetailStageView.h"
#import "THKGraphicDetailSpaceView.h"

#define kHeaderViewH 292
#define kStageMenuH 62
#define kStageSectionHeaderH 52

@interface THKGraphicDetailVC ()<UITableViewDelegate,UITableViewDataSource,THKDynamicTabsWrapperScrollViewDelegate,THKDynamicTabsProtocol>

@property (nonatomic, strong) THKGraphicDetailVM *viewModel;

@property (nonatomic, strong) THKDynamicTabsWrapperScrollView *wrapperScrollView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) THKGraphicDetailStageView *stageView;

@property (nonatomic, strong) THKGraphicDetailHeaderView *headerView;

@property (nonatomic, strong) THKGraphicDetailSpaceView *spaceView;

@end

@implementation THKGraphicDetailVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.thk_title = @"";
    
    [self.view addSubview:self.wrapperScrollView];
    [self.wrapperScrollView addSubview:self.headerView];
    [self.wrapperScrollView addSubview:self.stageView];
    [self.wrapperScrollView addSubview:self.tableView];
    
    [self.headerView addSubview:self.spaceView];
    [self.spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(66);
    }];
    
}

- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self);
    [[RACObserve(self.viewModel, contentList) ignore:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
//        THKDecorationToDoHeaderViewModel *headerVM = [[THKDecorationToDoHeaderViewModel alloc] initWithModel:x];
//        headerVM.subtitle = self.viewModel.subtitle;
//        [self.headerView bindViewModel:headerVM];
        self.stageView.model = x;
        [self.tableView reloadData];
    }];
    
    [[RACObserve(self.viewModel, imgInfo) ignore:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        self.spaceView.model = x;
    }];
    
//    1011138
//    1011136
//    这两个id有数据
    [self.viewModel.requestCommand execute:@1011136];
}



#pragma mark UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kStageSectionHeaderH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    THKGraphicDetailSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(THKGraphicDetailSectionHeaderView.class)];
    headerView.text = self.viewModel.contentList[section].anchor;
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.contentList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THKGraphicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKGraphicDetailCell.class) forIndexPath:indexPath];
    cell.model = self.viewModel.contentList[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


#pragma mark - Private
- (void)scrollToSection:(NSInteger)section{
    if (section >= self.tableView.numberOfSections) {
        return;
    }
    
//    self.isScrolling = YES;
    
    CGPoint point = [self.tableView rectForHeaderInSection:section].origin;
    if (self.wrapperScrollView.pin) {
        [self.tableView setContentOffset:point animated:YES];
    }else{
        [self.wrapperScrollView setContentOffset:CGPointZero animated:YES];
        // 这里要先设置，吸顶pin，否则内部会阻拦手动滑动事件
        [self.wrapperScrollView tmui_setValue:@1 forKey:@"pin"];
        [self.tableView setContentOffset:point animated:NO];
    }
}

- (THKDynamicTabsWrapperScrollView *)wrapperScrollView{
    if (!_wrapperScrollView) {
        CGRect frame = self.view.bounds;
        frame.origin.y = tmui_navigationBarHeight();
        frame.size.height -= frame.origin.y;
        _wrapperScrollView = [[THKDynamicTabsWrapperScrollView alloc] initWithFrame:frame];
        _wrapperScrollView.contentInset = UIEdgeInsetsMake(kHeaderViewH+kStageMenuH, 0, 0, 0);
        _wrapperScrollView.lockArea = kStageMenuH;
        _wrapperScrollView.delegate = self;
        _wrapperScrollView.contentSize = CGSizeMake(TMUI_SCREEN_WIDTH, kHeaderViewH + self.view.height);
        if (@available(iOS 11.0, *)) {
            _wrapperScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _wrapperScrollView;
}

- (THKGraphicDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[THKGraphicDetailHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, -kHeaderViewH-kStageMenuH, TMUI_SCREEN_WIDTH, kHeaderViewH);
        _headerView.backgroundColor = UIColorGrayDarken;
    }
    return _headerView;
}

- (THKGraphicDetailStageView *)stageView{
    if (!_stageView) {
        _stageView = [[THKGraphicDetailStageView alloc] init];
        _stageView.frame = CGRectMake(0, -kStageMenuH, TMUI_SCREEN_WIDTH, kStageMenuH);
        @weakify(self);
        _stageView.tapItem = ^(NSInteger index) {
            @strongify(self);
            [self scrollToSection:index];
        };
    }
    return _stageView;
}

- (THKGraphicDetailSpaceView *)spaceView{
    if (!_spaceView) {
        _spaceView = [[THKGraphicDetailSpaceView alloc] init];
    }
    return _spaceView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame = self.view.bounds;
        frame.size.height = frame.size.height - tmui_navigationBarHeight() - kStageMenuH;
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:THKGraphicDetailCell.class forCellReuseIdentifier:NSStringFromClass(THKGraphicDetailCell.class)];
        [_tableView registerClass:THKGraphicDetailSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(THKGraphicDetailSectionHeaderView.class)];
    }
    return _tableView;
}

- (UIScrollView *)contentScrollView{
    return _tableView;
}

@end
