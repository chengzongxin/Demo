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
//#import "THKHalfPresentLoginVC.h"
#import "THKDecorationToDoVM+Godeye.h"
#import <ReactiveObjC.h>

#define kStageMenuH 62
#define kStageSectionHeaderH 81
#define kHeaderViewH 292

@interface THKDecorationToDoVC ()<UITableViewDelegate,UITableViewDataSource,THKDynamicTabsWrapperScrollViewDelegate,THKDynamicTabsProtocol>

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
    self.thk_navBar.titleLbl.alpha = 0;
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
        headerVM.subtitle = self.viewModel.subtitle;
        [self.headerView bindViewModel:headerVM];
    }];
    
    [[RACObserve(self.viewModel, upcomingList) ignore:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    // 登录成功
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kHomeNotRefresh object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(NSNotification * _Nullable notification) {
        @strongify(self);
        // 登录后，刷新列表
        [self.viewModel.requestCommand execute:nil];
    }];
    
    [self.viewModel.requestCommand execute:nil];
}



#pragma mark UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kStageSectionHeaderH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    THKDecorationToDoSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(THKDecorationToDoSectionHeaderView.class)];
    THKDecorationUpcomingListModel *sectionModel = self.viewModel.upcomingList[section];
    headerView.model = sectionModel;
    headerView.layer.zPosition = -1;
    @weakify(self);
    @weakify(headerView);
    headerView.tapSection = ^(UIButton * _Nonnull btn) {
        @strongify(self);
        @strongify(headerView);
        sectionModel.isOpen = !sectionModel.isOpen;
        [self.tableView reloadSection:section withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.viewModel listUnfoldClick:headerView.arrowBtn widgetTitle:sectionModel.mainName widgetTag:[NSString stringWithFormat:@"%@%@",sectionModel.serialNumber,sectionModel.stageName]];
        
        [self.viewModel saveUpcomingListCachWithMainId:sectionModel.mainId isOpen:sectionModel.isOpen];
    };
    
    if (!sectionModel.isExposeUnfoldBtn) {
        sectionModel.isExposeUnfoldBtn = YES;
        
        [self.viewModel listUnfoldShow:headerView.arrowBtn widgetTitle:sectionModel.mainName widgetTag:[NSString stringWithFormat:@"%@%@",sectionModel.serialNumber,sectionModel.stageName]];
    }
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.upcomingList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    THKDecorationUpcomingListModel *sectionModel = self.viewModel.upcomingList[section];
    return sectionModel.isOpen ? sectionModel.childList.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THKDecorationToDoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKDecorationToDoCell.class) forIndexPath:indexPath];
    THKDecorationUpcomingListModel *sectionModel = self.viewModel.upcomingList[indexPath.section];
    THKDecorationUpcomingChildListModel *model = sectionModel.childList[indexPath.item];
    cell.model = model;
    @weakify(self);
    @weakify(cell);
    @weakify(tableView);
    // 选择子项
    cell.tapSelectBlock = ^(UIButton * _Nonnull btn) {
        @strongify(self);
        @strongify(cell);
        @strongify(tableView);
//        if (![kCurrentUser isLoginStatus]) {
//            [THKHalfPresentLoginVC judgeLoginStateWithLoginedHandler:^(id obj) {
//
//            } failHandler:^(id obj) {
//            }];
//            return;
//        }
        
        void (^updateUIBlock)(BOOL,BOOL) = ^void(BOOL updateModel,BOOL fold) {
            @strongify(self);
            @strongify(tableView);
            if (updateModel) {
                // 更新模型数据
                if (model.todoStatus == 0) {
                    model.todoStatus = 1;
                    sectionModel.completedNum++;
                }else{
                    model.todoStatus = 0;
                    sectionModel.completedNum--;
                }
                [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
                
                // 同步更新sectionHeader
                THKDecorationToDoSectionHeaderView *headerView = (THKDecorationToDoSectionHeaderView *)[tableView headerViewForSection:indexPath.section];
                headerView.model = sectionModel;
            }
            
            if (fold) {
                // 折叠
                if (sectionModel.completedNum == sectionModel.totalNum) {
                    sectionModel.isOpen = NO;
                    [tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    [self.viewModel saveUpcomingListCachWithMainId:sectionModel.mainId isOpen:sectionModel.isOpen];
                }
                
            }
            
        };
        
        // 本地更新
        updateUIBlock(YES,NO);
       
        
        [self.viewModel editModelRequest:model success:^{
            // 成功折叠
            updateUIBlock(NO,YES);
        } fail:^{
            // 失败恢复
            updateUIBlock(YES,NO);
        }];
        
        [self.viewModel listCheckOffClick:cell.selectBtn widgetTitle:model.childName widgetSubtitle:sectionModel.mainName widgetTag:sectionModel.widgetTag];
    };
    // 攻略
    cell.tapStragegyBlock = ^(UILabel * _Nonnull lbl) {
        @strongify(self);
        @strongify(cell);
        if (!tmui_isNullString(model.strategyTitle)) {
            [self.viewModel listLearnMoreClick:cell.strategyLbl widgetTitle:model.strategyTitle widgetSubtitle:sectionModel.mainName widgetTag:sectionModel.widgetTag widgetIndex:0 widgetValue:model.childName widgetType:@"装修攻略"];
        }
        
        [[TRouterManager sharedManager] performRouter:[TRouter routerFromUrl:model.strategyRouting]];
    };
    // 服务工具
    cell.tapServiceBlock = ^(UILabel * _Nonnull lbl) {
        @strongify(self);
        @strongify(cell);
        if (!tmui_isNullString(model.toolTitle)) {
            [self.viewModel listLearnMoreClick:cell.serviceLbl widgetTitle:model.toolTitle widgetSubtitle:sectionModel.mainName widgetTag:sectionModel.widgetTag widgetIndex:1 widgetValue:model.childName widgetType:@"装修工具"];
        }
        
        [[TRouterManager sharedManager] performRouter:[TRouter routerFromUrl:model.toolRouting]];
    };
    
    if (!model.isExpose) {
        model.isExpose = YES;
        
        [self.viewModel listCheckOffShow:cell.selectBtn widgetTitle:model.childName widgetSubtitle:sectionModel.mainName widgetTag:sectionModel.widgetTag];
        
        if (!tmui_isNullString(model.strategyTitle)) {
            [self.viewModel listLearnMoreShow:cell.strategyLbl widgetTitle:model.strategyTitle widgetSubtitle:sectionModel.mainName widgetTag:sectionModel.widgetTag widgetIndex:0 widgetValue:model.childName widgetType:@"装修攻略"];
        }
        
        if (!tmui_isNullString(model.toolTitle)) {
            [self.viewModel listLearnMoreShow:cell.serviceLbl widgetTitle:model.toolTitle widgetSubtitle:sectionModel.mainName widgetTag:sectionModel.widgetTag widgetIndex:1 widgetValue:model.childName widgetType:@"装修工具"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.upcomingList[indexPath.section].childList[indexPath.item].cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.wrapperScrollView) {
        CGFloat minY = -self.wrapperScrollView.contentInset.top;
        CGFloat maxY = -self.wrapperScrollView.lockArea;
        CGFloat offY = self.wrapperScrollView.contentOffset.y;
        CGFloat percent = (offY - minY) / (maxY - minY);
        
        [self.thk_navBar setNavigationBarColor:UIColorWhite originTintColor:UIColorTextRegular toTintColor:UIColorTextRegular gradientPercent:percent];
        self.thk_navBar.titleLbl.alpha = percent;
        [self.headerView.stageView setGradientPercent:percent];
    }else if (scrollView == self.tableView) {
        
        if (self.isScrolling) {
            return;
        }
        
        
        int firstSection = -1;
        
        CGFloat y = scrollView.contentOffset.y;
        
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:CGPointMake(100, y)];
        if (indexPath) {
            // 有cell
            firstSection = (int)indexPath.section;
        }else{
            // 没有cell，获取section
            for (int i = 0; i < self.tableView.numberOfSections; i++) {
                CGFloat sectionY = [self.tableView rectForSection:i].origin.y;
                if (sectionY > y - kStageSectionHeaderH) {
                    firstSection = i;
                    break;
                }
            }
        }
        
        // 定位到stageList
        if (firstSection != -1) {
            THKDecorationUpcomingListModel *selectModel = [self.viewModel.upcomingList tmui_safeObjectAtIndex:firstSection];
            __block NSInteger selectIdx = NSNotFound;
            
            [self.viewModel.stageList enumerateObjectsUsingBlock:^(THKDecorationUpcomingModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.serialNumber isEqualToString:selectModel.serialNumber]) {
                    selectIdx = idx;
                    *stop = YES;
                }
            }];
            
            if (selectIdx != NSNotFound) {
                self.headerView.selectIndex = selectIdx;
            }
            
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        self.isScrolling = NO; // 还原主动执行选择的操作标志
    }
}

#pragma mark - Private
- (void)scrollToSection:(NSInteger)section{
    if (section >= self.tableView.numberOfSections) {
        return;
    }
    
    self.isScrolling = YES;
    
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

- (void)selectModel:(THKDecorationUpcomingListModel *)model{
    
}


#pragma mark - getter

- (THKDynamicTabsWrapperScrollView *)wrapperScrollView{
    if (!_wrapperScrollView) {
        _wrapperScrollView = [[THKDynamicTabsWrapperScrollView alloc] initWithFrame:self.view.bounds];
        _wrapperScrollView.contentInset = UIEdgeInsetsMake(kHeaderViewH, 0, 0, 0);
        _wrapperScrollView.lockArea = tmui_navigationBarHeight() + 10 + kStageMenuH + 10;
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, TMUI_SCREEN_HEIGHT - tmui_navigationBarHeight() - kStageMenuH) style:TMUITableViewStyleInsetGrouped];
        _tableView.tmui_insetGroupedCornerRadius = 12;
        _tableView.tmui_insetGroupedHorizontalInset = 15;
        _tableView.backgroundColor = UIColorHex(F6F8F6);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 15.0;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, _tableView.height - kStageSectionHeaderH, 0);
        [_tableView registerClass:THKDecorationToDoCell.class forCellReuseIdentifier:NSStringFromClass(THKDecorationToDoCell.class)];
        [_tableView registerClass:THKDecorationToDoSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(THKDecorationToDoSectionHeaderView.class)];
        
    }
    return _tableView;
}

- (THKDecorationToDoHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[THKDecorationToDoHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, -kHeaderViewH, TMUI_SCREEN_WIDTH, kHeaderViewH);
        @weakify(self);
        _headerView.tapItem = ^(NSInteger index) {
            @strongify(self);
            [self scrollToSection:index];
            
            THKDecorationUpcomingModel *model = self.viewModel.stageList[index];
            if (!model.isExposeStageCard) {
                [self.viewModel stageCardClick:nil widgetTitle:model.widgetTag];
                model.isExposeStageCard = YES;
            }
            
        };
        _headerView.exposeItem = ^(NSInteger index) {
            @strongify(self);
            THKDecorationUpcomingModel *model = self.viewModel.stageList[index];
            [self.viewModel stageCardShow:nil widgetTitle:model.widgetTag];
        };
    }
    return _headerView;
}


- (UIScrollView *)contentScrollView{
    return _tableView;
}

#pragma mark - NSObject
+ (BOOL)canHandleRouter:(TRouter *)router {
//    if ([router routerMatch:THKRouterPage_todoList]) {
//        return YES;
//    }
    return NO;
}

+ (id)createVCWithRouter:(TRouter *)router {
    THKDecorationToDoVM *viewModel = [[THKDecorationToDoVM alloc] init];
    return  [[self alloc] initWithViewModel:viewModel];
}

@end
