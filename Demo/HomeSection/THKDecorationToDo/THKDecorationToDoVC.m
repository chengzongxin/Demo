//
//  THKDecorationToDoVC.m
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKDecorationToDoVC.h"
#import "THKDecorationToDoCell.h"
#import "THKDecorationToDoSectionHeaderView.h"

@interface THKDecorationToDoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) THKDecorationToDoVM *viewModel;

@property (nonatomic, strong) UITableView *tableView;



@end

@implementation THKDecorationToDoVC
@dynamic viewModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    
}

- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self);
    [[RACObserve(self.viewModel, sections) ignore:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self.viewModel.requestCommand execute:nil];
}



#pragma mark UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 88;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    THKDecorationToDoSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(THKDecorationToDoSectionHeaderView.class)];
    THKDecorationToDoSection *sectionModel = self.viewModel.sections[section];
    if (sectionModel.isOpen) {
        headerView.arrowBtn.tmui_image = UIImageMake(@"caret_open");
    }else{
        headerView.arrowBtn.tmui_image = UIImageMake(@"caret");
    }
    headerView.tapSection = ^(UIButton * _Nonnull btn) {
        sectionModel.isOpen = !sectionModel.isOpen;
        [tableView reloadSection:section withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.sections[section].isOpen ? self.viewModel.sections[section].items.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKDecorationToDoCell.class) forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
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
        [_tableView registerClass:THKDecorationToDoCell.class forCellReuseIdentifier:NSStringFromClass(THKDecorationToDoCell.class)];
        [_tableView registerClass:THKDecorationToDoSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(THKDecorationToDoSectionHeaderView.class)];
        
    }
    return _tableView;
}


@end
