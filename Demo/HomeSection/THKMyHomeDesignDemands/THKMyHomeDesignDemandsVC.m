//
//  THKMyHomeDesignDemandsVC.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKMyHomeDesignDemandsVC.h"
#import "THKMyHomeDesignDemandsCell.h"

@interface THKMyHomeDesignDemandsVC () <UITableViewDelegate,UITableViewDataSource,THKMyHomeDesignDemandsCellDelegate>

@property (nonatomic, strong) THKMyHomeDesignDemandsVM *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THKMyHomeDesignDemandsVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
}

- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self);
    [[RACObserve(self.viewModel, cellModels) ignore:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    UIButton *btn = [UIButton tmui_button];
    btn.tmui_text = @"commit";
    btn.backgroundColor = UIColorGreen;
    btn.frame = CGRectMake(20, 500, TMUI_SCREEN_WIDTH - 40, 44);
    [self.view addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.viewModel.editCommand execute:nil];
    }];
    
    
}


#pragma mark - Actions
- (void)editCell:(THKMyHomeDesignDemandsCell *)cell type:(THKMyHomeDesignDemandsModelType)type data:(id)data{
    [self.viewModel.editCellCommand execute:RACTuplePack(cell,@(type),data)];
}

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.cellModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THKMyHomeDesignDemandsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKMyHomeDesignDemandsCell.class) forIndexPath:indexPath];
    [cell bindWithModel:self.viewModel.cellModels[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
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
        [_tableView registerClass:THKMyHomeDesignDemandsCell.class forCellReuseIdentifier:NSStringFromClass(THKMyHomeDesignDemandsCell.class)];
    }
    return _tableView;
}

@end
