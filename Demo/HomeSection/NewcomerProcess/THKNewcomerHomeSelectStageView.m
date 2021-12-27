//
//  THKNewcomerHomeSelectStageView.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/6.
//

#import "THKNewcomerHomeSelectStageView.h"
#import "THKNewcomerHomeSelectStageHeaderView.h"
static CGFloat const kSectionHeaderHeight = 54.0f;

@interface THKNewcomerStageModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;

@end

@implementation THKNewcomerStageModel
@end

@interface THKNewcomerHomeSelectStageView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong, readwrite) THKNewcomerHomeSelectStageViewModel *viewModel;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray  <THKNewcomerStageModel *>*dataSource;
@property (nonatomic, strong) NSIndexPath *autoScrollIndexPath;

@end

@implementation THKNewcomerHomeSelectStageView
@dynamic viewModel;

- (void)thk_setupViews{
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(100, 0, 0, 0));
    }];
    
}



// 绑定VM
- (void)bindViewModel {
    
    NSArray *titles = @[@"你的装修阶段",@"你的装修阶段1",@"你的装修阶段2"];
    NSArray *contents = @[@"准备装修",@"80m2",@"三居"];
    
    NSMutableArray *models = [NSMutableArray array];
    for (int i = 0; i<titles.count; i++) {
        THKNewcomerStageModel *model = [[THKNewcomerStageModel alloc] init];
        model.title = titles[i];
        model.content = contents[i];
        [models addObject:model];
    }
    
    _dataSource = models;
    
    [self.tableView reloadData];
}

#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {return kSectionHeaderHeight;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterSection:(NSInteger)section {return 0.0f;}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    THKNewcomerHomeSelectStageHeaderView *sectionView = [[THKNewcomerHomeSelectStageHeaderView alloc] init];
    sectionView.titleLabel.text = _dataSource[section].title;
    sectionView.contentLabel.text = _dataSource[section].content;
    @weakify(self);
    sectionView.tapItem = ^(UIButton * _Nonnull btn) {
        @strongify(self);
        [self openSection:section];
    };
    return sectionView;
}

- (void)openSection:(NSInteger)section{
//    THKDirectorySectionModel *sectionModel = [_arrayData objectAtIndex:section];
//    sectionModel.isUnfold = !sectionModel.isUnfold;
//    if (sectionModel.isUnfold == NO) {
//        // 关闭的时候，如果上面有很多数据，tableview会消失，这里在关闭时不进行动画
//        [self.tableView reloadData];
//    }else{
//    }
    [self.tableView reloadSection:section withRowAnimation:UITableViewRowAnimationAutomatic];
}

//- (void)openSectioin:(THKDirectorySectionModel *)sectionModel{
//    sectionModel.isUnfold = !sectionModel.isUnfold;
//    [self.tableView reloadData];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
//    THKDirectorySectionModel *sectionModel = [_arrayData objectAtIndex:indexPath.section];
//    THKDirectoryRowModel *rowModel = sectionModel.rows[indexPath.row];
//    cell.titleLabel.text = rowModel.content;
//    [cell setSelected:rowModel.isCurrent animated:YES];
//    if (rowModel.isDirectoryExpose == NO) {
//        rowModel.isDirectoryExpose = YES;
//        // 曝光
//        [self.viewModel cellShowReport:rowModel.content label:cell.titleLabel widgetType:sectionModel.firstStageName];
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    THKDirectorySectionModel *sectionModel = [_arrayData objectAtIndex:indexPath.section];
//    THKDirectoryRowModel *rowModel = sectionModel.rows[indexPath.row];
//    !_clickBlock ?: _clickBlock([NSIndexPath indexPathForRow:rowModel.index inSection:0]);
//    // 点击
//    THKDiaryDirectoryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [self.viewModel cellClickReport:rowModel.content label:cell.titleLabel widgetType:sectionModel.firstStageName];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - Private

#pragma mark - Getters and Setters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.viewController.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

#pragma mark - Supperclass

#pragma mark - NSObject

@end
