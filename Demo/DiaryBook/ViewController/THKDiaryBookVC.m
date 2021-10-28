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
#import "THKDiaryBookBottomBar.h"
#import "THKDiaryDirectoryChildVC.h"
#import "THKDiaryBookDetailTopNaviBarView.h"
#import "THKDiaryProducer.h"

static CGFloat const kBottomBarH = 50;

@interface THKDiaryBookVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) THKDiaryBookVM *viewModel;
/// List
@property (nonatomic, strong) UITableView *tableView;
/// header
@property (nonatomic, strong) THKDiaryBookInfoView *infoView;
/// bar
@property (nonatomic, strong) THKDiaryBookBottomBar *bottomBar;
/// directory
@property (nonatomic, strong) THKDiaryDirectoryVC *directoryVC;

@property (nonatomic, strong) THKDiaryBookDetailTopNaviBarView *topBar;
/// dataSource
//@property (nonatomic, copy) NSArray *diaryList;

@property (nonatomic, strong) THKDiaryProducer *producer;

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
    self.view.backgroundColor = UIColor.whiteColor;
    
//    // 从日记本进入
//    [self loadDataWithOffsetId:0];
    
    // 从子日记进入
    [self loadDataWithDiaryId:2022012];
}

//
- (void)loadDataWithOffsetId:(NSInteger)offsetId{
    @weakify(self);
    [self.producer loadDataWithOffsetId:offsetId complete:^(NSArray * _Nonnull datas, THKDiaryProductFromType fromType, NSInteger offset) {
        @strongify(self);
        [self.tableView reloadData];
        [self.tableView scrollToRow:offset inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:NO];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)loadDataWithDiaryId:(NSInteger)diaryId{
    @weakify(self);
    [self.producer loadDataWithDiaryId:diaryId complete:^(NSArray * _Nonnull datas, THKDiaryProductFromType fromType, NSInteger offset) {
        @strongify(self);
        [self.tableView reloadData];
        [self.tableView scrollToRow:offset inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:NO];
    } failure:^(NSError * _Nonnull error) {

    }];
}

- (void)loadDataWithStageId:(NSInteger)stageId{
    @weakify(self);
    [self.producer loadDataWithStageId:stageId complete:^(NSArray * _Nonnull datas, THKDiaryProductFromType fromType, NSInteger offset) {
        @strongify(self);
        [self.tableView reloadData];
        [self.tableView scrollToRow:offset inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:NO];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

// 子视图布局
- (void)thk_addSubviews{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomBar];
    
    self.navigationItem.titleView = self.topBar;
    [self.topBar.avatarImgView.avatarImgView loadImageWithUrlStr:@"https://img1.baidu.com/it/u=3366246598,2446278796&fm=26&fmt=auto&gp=0.jpg"];
    
    CGFloat bottom = kSafeAreaBottomInset() + kBottomBarH;
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, bottom, 0);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(inset);
    }];
    
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(bottom);
    }];
}

// 绑定VM
- (void)bindViewModel {
    // setup header
    self.tableView.tableHeaderView = self.infoView;
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width);
    }];
    // set datas
    [self.infoView bindViewModel:[THKDiaryBookInfoViewModel new]];
    // update layout
    [self.tableView.tableHeaderView layoutIfNeeded];
}

#pragma mark - Public

#pragma mark - Event Respone

- (void)clickDirectory{
    @weakify(self);
    self.directoryVC = [[THKDiaryDirectoryVC alloc] initWithSponsor:self resetBlock:^(NSArray * _Nonnull dataList) {
        NSLog(@"%@",dataList);
    } commitBlock:^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        [self.directoryVC dismiss];
        [self loadDataWithStageId:indexPath.row + 1];
    }];
    [self.directoryVC show];
}

#pragma mark - Delegate
#pragma mark <UITableViewDataSource, UITableViewDelegate>

- (id<NSCopying>)cachedKeyAtIndexPath:(NSIndexPath *)indexPath {
    return @(self.producer.map[indexPath.row].diaryId).stringValue;
//    return @(indexPath.row);// 这里简单处理，认为只要长度不同，高度就不同（但实际情况下长度就算相同，高度也有可能不同，要注意）
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.producer.map.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 66;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    THKDiaryBookCellHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(THKDiaryBookCellHeaderView.class)];
    headerView.titleLabel.text = self.viewModel.sections[section];
    headerView.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    return headerView;
}

int preLoad = 5;
float beginOffset = 0;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    beginOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    @weakify(self);
    THKDiaryProductComplete _completion = ^(NSArray * _Nonnull datas, THKDiaryProductFromType fromType, NSInteger offset) {
        @strongify(self);
        [self.tableView reloadData];
    };
    
    if (scrollView.contentOffset.y > beginOffset) {
        NSInteger idx = self.tableView.indexPathsForVisibleRows.lastObject.row;
        [self.producer scrollLoadData:idx isDown:YES complete:_completion failure:^(NSError * _Nonnull error) {
            
        }];
    }else{
        NSInteger idx = self.tableView.indexPathsForVisibleRows.firstObject.row;
        [self.producer scrollLoadData:idx isDown:NO complete:_completion failure:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == [tableView numberOfSections] - 1) {
//        THKDiaryBookLastCell *cell = (THKDiaryBookLastCell *)[self tmui_tableView:tableView cellWithIdentifier:NSStringFromClass(THKDiaryBookLastCell.class)];
//        CGRect rect = [self.topBar.avatarImgView tmui_convertRect:self.topBar.avatarImgView.frame toViewOrWindow:self.navigationController.view];
//
//        cell.animateEndPoint = CGRectGetCenter(rect);
//        Log(cell.animateStartPoint);
//        @weakify(self);
//        cell.animationStartBlock = ^{
//            @strongify(self);
//            [self.topBar recivedUrgeUpdate];
//        };
//        return cell;
//    }else{
        THKDiaryBookCell *cell = (THKDiaryBookCell *)[self tmui_tableView:tableView cellWithIdentifier:NSStringFromClass(THKDiaryBookCell.class)];
        THKDiaryBookCellVM *cellVM = [[THKDiaryBookCellVM alloc] initWithModel:self.producer.map[indexPath.row].content];
        [cell bindViewModel:cellVM];
    [cell setIndexPath:indexPath];
        return cell;
//    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<NSCopying> cachedKey = [self cachedKeyAtIndexPath:indexPath];
    NSString *identifier = NSStringFromClass(THKDiaryBookCell.class);
    return [tableView tmui_heightForCellWithIdentifier:identifier cacheByKey:cachedKey configuration:^(id<THKDiaryBookCellBindVM> cell) {
        THKDiaryBookCellVM *cellVM = [[THKDiaryBookCellVM alloc] initWithModel:self.producer.map[indexPath.row].content];
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
        _tableView.contentInset =UIEdgeInsetsMake(0, 0, 400, 0); // 底部多余20
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:THKDiaryBookCellHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(THKDiaryBookCellHeaderView.class)];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [_tableView registerClass:THKDiaryBookCell.class forCellReuseIdentifier:NSStringFromClass(THKDiaryBookCell.class)];
        [_tableView registerClass:THKDiaryBookLastCell.class forCellReuseIdentifier:NSStringFromClass(THKDiaryBookLastCell.class)];
    }
    return _tableView;
}

- (THKDiaryProducer *)producer{
    if (!_producer) {
        _producer = [[THKDiaryProducer alloc] init];
        _producer.diaryBookId = 7007277;
    }
    return _producer;
}

- (THKDiaryBookInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[THKDiaryBookInfoView alloc] init];
    }
    return _infoView;
}

- (THKDiaryBookBottomBar *)bottomBar{
    if (!_bottomBar) {
        _bottomBar = [THKDiaryBookBottomBar tmui_instantiateFromNib];
        @weakify(self);
        _bottomBar.clickDirectory = ^{
            @strongify(self);
            [self clickDirectory];
        };
    }
    return _bottomBar;
}

- (THKDiaryBookDetailTopNaviBarView *)topBar{
    if (!_topBar) {
        _topBar = [[THKDiaryBookDetailTopNaviBarView alloc] init];
        _topBar.backgroundColor = UIColor.whiteColor;
//        _topBar.backBtn.tmui_image = UIImageMake(@"nav_back_black");
        _topBar.nickNameLbl.textColor = UIColorHex(1A1C1A);
    }
    return _topBar;
}

#pragma mark - Supperclass

#pragma mark - NSObject

@end
