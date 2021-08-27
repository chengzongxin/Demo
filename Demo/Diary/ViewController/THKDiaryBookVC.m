//
//  THKDiaryBookVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/24.
//

#import "THKDiaryBookVC.h"
#import "THKDiaryBookInfoView.h"
#import "THKDiaryBookCell.h"
#import "THKDiaryBookCellVM.h"
#import "THKDiaryBookCellHeaderView.h"
#import "THKDiaryBookLastCell.h"

//static NSString * const kCellIdentifier = @"cell";

@interface THKDiaryBookVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) THKDiaryBookVM *viewModel;
/// List
@property (nonatomic, strong) UITableView *tableView;
/// header
@property (nonatomic, strong) THKDiaryBookInfoView *infoView;
/// dataSource
//@property (nonatomic, copy) NSArray *diaryList;

@end

@implementation THKDiaryBookVC
@dynamic viewModel;
#pragma mark - Lifecycle 

// 初始化
- (void)thk_initialize{

}

// 渲染VC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self thk_hideNavShadowImageView];
    self.view.backgroundColor = UIColor.whiteColor;
}

// 子视图布局
- (void)thk_addSubviews{
    [self.view addSubview:self.tableView];
}

// 绑定VM
- (void)bindViewModel {
//    self.diaryList = self.viewModel.sections;
    // setup header
    [self.infoView bindViewModel:[THKDiaryBookInfoViewModel new]];
    self.tableView.tableHeaderView = self.infoView;
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    //        self.headerLable.text = @"测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本";
    
    [self.tableView.tableHeaderView layoutIfNeeded];
    self.tableView.tableHeaderView = self.infoView;
    [self.tableView reloadData];
}

#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate
#pragma mark <UITableViewDataSource, UITableViewDelegate>

- (id<NSCopying>)cachedKeyAtIndexPath:(NSIndexPath *)indexPath {
    return @(indexPath.section);// 这里简单处理，认为只要长度不同，高度就不同（但实际情况下长度就算相同，高度也有可能不同，要注意）
}


- (UITableViewCell *)tmui_tableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:NSStringFromClass(THKDiaryBookCell.class)]) {
        THKDiaryBookCell *cell = (THKDiaryBookCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[THKDiaryBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(THKDiaryBookCell.class)];
        }
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([identifier isEqualToString:NSStringFromClass(THKDiaryBookLastCell.class)]) {
        THKDiaryBookLastCell *cell = (THKDiaryBookLastCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[THKDiaryBookLastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(THKDiaryBookLastCell.class)];
        }
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 66;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    THKDiaryBookCellHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(THKDiaryBookCellHeaderView.class)];
    headerView.titleLabel.text = self.viewModel.sections[section];
    headerView.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
//    headerView.position = section == 0 ? THKDiaryIndexPosition_Top : THKDiaryIndexPosition_Mid;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [tableView numberOfSections] - 1) {
        THKDiaryBookLastCell *cell = (THKDiaryBookLastCell *)[self tmui_tableView:tableView cellWithIdentifier:NSStringFromClass(THKDiaryBookLastCell.class)];
        return cell;
    }else{
        THKDiaryBookCell *cell = (THKDiaryBookCell *)[self tmui_tableView:tableView cellWithIdentifier:NSStringFromClass(THKDiaryBookCell.class)];
        THKDiaryBookCellVM *cellVM = [[THKDiaryBookCellVM alloc] initWithModel:self.viewModel.rows[indexPath.section]];
        [cell bindViewModel:cellVM];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<NSCopying> cachedKey = [self cachedKeyAtIndexPath:indexPath];
    NSString *identifier = indexPath.section == [tableView numberOfSections] - 1 ? NSStringFromClass(THKDiaryBookLastCell.class) : NSStringFromClass(THKDiaryBookCell.class);
    return [tableView tmui_heightForCellWithIdentifier:identifier cacheByKey:cachedKey configuration:^(id<THKDiaryBookCellBindVM> cell) {
        THKDiaryBookCellVM *cellVM = [[THKDiaryBookCellVM alloc] initWithModel:self.viewModel.rows[indexPath.section]];
        [cell bindViewModel:cellVM];
    }];
}
#pragma mark - Private

#pragma mark - Getters and Setters


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
        [_tableView registerClass:THKDiaryBookCellHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(THKDiaryBookCellHeaderView.class)];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [_tableView registerClass:THKDiaryBookCell.class forCellReuseIdentifier:NSStringFromClass(THKDiaryBookCell.class)];
        [_tableView registerClass:THKDiaryBookLastCell.class forCellReuseIdentifier:NSStringFromClass(THKDiaryBookLastCell.class)];
    }
    return _tableView;
}

- (THKDiaryBookInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[THKDiaryBookInfoView alloc] init];
    }
    return _infoView;
}

#pragma mark - Supperclass

#pragma mark - NSObject

@end
