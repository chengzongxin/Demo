//
//  THKMyHomeDesignDemandsVC.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKMyHomeDesignDemandsVC.h"
#import "THKMyHomeDesignDemandsCell.h"
#import "THKMyHouseHeaderView.h"
#import "THKMyHomeDesignDemandsSendView.h"
#import "THKMyHomeDesignRequirementCell.h"
@interface THKMyHomeDesignDemandsVC () <UITableViewDelegate,UITableViewDataSource,THKMyHomeDesignDemandsCellDelegate>

@property (nonatomic, strong) THKMyHomeDesignDemandsVM *viewModel;

@property (nonatomic, strong) UITableView *tableView;


//IM-我的家-头部
@property (nonatomic, strong)   THKMyHouseHeaderView *headerView;

//IM-我的家，背景图
@property (nonatomic, strong)   UIImageView *bgImageView;


//IM-我的家，发送的UI
@property (nonatomic, strong)   THKMyHomeDesignDemandsSendView *sendView;

@end

@implementation THKMyHomeDesignDemandsVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.thk_navBar.backgroundColor = UIColor.clearColor;
    self.view.backgroundColor = THKColor_Sub_EmptyAreaBackgroundColor;
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(320);
    }];
    //IM
    [self.view addSubview:self.sendView];
//    [self footView].hidden = YES;
    
//    self.bgImageView.hidden = YES;
    CGFloat top = kTNavigationBarHeight();
    [self.view addSubview:self.tableView];
    
    CGFloat bottom = 48 + 16;
    if (kSafeAreaBottomInset() > 0) {
        bottom += 34;
    }else{
        bottom += 24;
    }
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(top);
        make.bottom.mas_equalTo(-bottom);
    }];
    CGFloat height = [THKMyHouseHeaderView viewHeight];
    [self.sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(0);
        make.top.equalTo(self.tableView.mas_top).mas_equalTo(height);
    }];
    
    [self addHeadView];
}

-(void)addHeadView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-32, [THKMyHouseHeaderView viewHeight])];
    [view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    [self.headerView setViewTopRadius];
    self.tableView.tableHeaderView = view;
}

- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self);
    [[RACObserve(self.viewModel, cellModels) ignore:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
//    UIButton *btn = [UIButton tmui_button];
//    btn.tmui_text = @"commit";
//    btn.backgroundColor = UIColorGreen;
//    btn.frame = CGRectMake(20, 500, TMUI_SCREEN_WIDTH - 40, 44);
//    [self.view addSubview:btn];
//    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        @strongify(self);
//        [self.viewModel.editCommand execute:nil];
//    }];
    
    
    
    self.sendView.sendButton.rac_command = self.viewModel.editCommand;
    
//    [self.sendView.sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Actions
- (void)editCell:(THKMyHomeDesignDemandsCell *)cell type:(THKMyHomeDesignDemandsModelType)type data:(id)data{
    [self.viewModel.editCellCommand execute:RACTuplePack(cell,@(type),data)];
}

//-(void)sendAction:(UIButton*)button{
//    [self.viewModel.editCommand execute:nil];
//}

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.cellModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THKMyHomeDesignDemandsModel *model = self.viewModel.cellModels[indexPath.row];
    if (model.type == THKMyHomeDesignDemandsModelType_SpecialDemand) {
        THKMyHomeDesignRequirementCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKMyHomeDesignDemandsCell.class) forIndexPath:indexPath];
        [cell bindWithModel:self.viewModel.cellModels[indexPath.row]];
        cell.delegate = self;
        return cell;
    }else{
        THKMyHomeDesignDemandsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKMyHomeDesignDemandsCell.class) forIndexPath:indexPath];
        [cell bindWithModel:self.viewModel.cellModels[indexPath.row]];
        cell.delegate = self;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.estimatedRowHeight = 52;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView tmui_registerCellWithClass:THKMyHomeDesignDemandsCell.class];
        [_tableView tmui_registerCellWithClass:THKMyHomeDesignRequirementCell.class];
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
    }
    return _tableView;
}

-(THKMyHouseHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[THKMyHouseHeaderView alloc] init];
    }
    return _headerView;
}
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"im_mycollection_head_bg_icon"]];
    }
    return _bgImageView;
}

- (THKMyHomeDesignDemandsSendView *)sendView{
    if (!_sendView) {
        _sendView = [[THKMyHomeDesignDemandsSendView alloc] init];
        _sendView.backgroundColor = UIColor.whiteColor;
    }
    return _sendView;
}

@end
