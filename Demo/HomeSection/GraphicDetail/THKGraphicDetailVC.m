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
#define kStageSectionHeaderH 81

@interface THKGraphicDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) THKGraphicDetailVM *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THKGraphicDetailVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)bindViewModel{
    [super bindViewModel];
    
//    1011138
//    1011136
//    这两个id有数据
    [self.viewModel.requestCommand execute:@1011138];
    
    [self.viewModel.requestCommand.nextSignal subscribeNext:^(THKMeituDetailv2Response *  _Nullable x) {
        NSLog(@"%@",x);
    }];
}



#pragma mark UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kStageSectionHeaderH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    THKGraphicDetailSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(THKGraphicDetailSectionHeaderView.class)];
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THKGraphicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKGraphicDetailCell.class) forIndexPath:indexPath];
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
//    if (self.wrapperScrollView.pin) {
        [self.tableView setContentOffset:point animated:YES];
//    }else{
//        [self.wrapperScrollView setContentOffset:CGPointZero animated:YES];
//        // 这里要先设置，吸顶pin，否则内部会阻拦手动滑动事件
//        [self.wrapperScrollView tmui_setValue:@1 forKey:@"pin"];
//        [self.tableView setContentOffset:point animated:NO];
//    }
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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


@end
