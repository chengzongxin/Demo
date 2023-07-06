//
//  THKGraphicCollectionVC.m
//  Demo
//
//  Created by Joe.cheng on 2023/7/6.
//

#import "THKGraphicCollectionVC.h"
#import "THKStateMechanismsViewModel.h"
#import "THKGraphicCollectionCell.h"

@interface THKGraphicCollectionVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong, readwrite) THKGraphicCollectionVM *viewModel;

@property (nonatomic, strong, readwrite) UILabel *titleLbl;

@property (nonatomic, strong, readwrite) UILabel *briefIntroductionLbl;

@property (nonatomic, strong, readwrite) UITableView *tableView;

@end

@implementation THKGraphicCollectionVC
@dynamic viewModel;

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.titleLbl];
    [self.view addSubview:self.briefIntroductionLbl];
    [self.view addSubview:self.tableView];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.equalTo(self.view);
    }];
    [self.briefIntroductionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(2);
        make.centerX.equalTo(self.view);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(66);
        make.left.bottom.right.mas_equalTo(0);
    }];
}


#pragma mark - Public
- (void)bindViewModel {
    [super bindViewModel];
    
    RAC(self.titleLbl,text) = [RACObserve(self.viewModel, titleStr) ignore:nil];
    RAC(self.briefIntroductionLbl,text) = [RACObserve(self.viewModel, briefStr) ignore:nil];
    
    [self.viewModel bindStatusWithView:self.view scrollView:self.tableView];
    
    [self.viewModel addRefreshFooter];
    
    [self.viewModel.requestCommand execute:@1];
}

#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THKGraphicCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKGraphicCollectionCell.class) forIndexPath:indexPath];
    cell.model = self.viewModel.data[indexPath.item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}

#pragma mark - Private

#pragma mark - Getters and Setters


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.font = UIFontMedium(16);
        _titleLbl.textColor = UIColorDark;
    }
    return _titleLbl;
}

- (UILabel *)briefIntroductionLbl{
    if (!_briefIntroductionLbl) {
        _briefIntroductionLbl = [[UILabel alloc] init];
        _briefIntroductionLbl.textAlignment = NSTextAlignmentCenter;
        _briefIntroductionLbl.font = UIFont(12);
        _briefIntroductionLbl.textColor = UIColorPlaceholder;
    }
    return _briefIntroductionLbl;
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
        [_tableView registerClass:THKGraphicCollectionCell.class forCellReuseIdentifier:NSStringFromClass(THKGraphicCollectionCell.class)];
    }
    return _tableView;
}

#pragma mark - Supperclass

- (CGFloat)viewHeight{
    return TMUI_SCREEN_HEIGHT * 0.65;
}

#pragma mark - NSObject

@end
