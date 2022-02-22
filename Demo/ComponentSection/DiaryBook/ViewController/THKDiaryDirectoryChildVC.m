//
//  THKDiaryDirectoryChildVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/27.
//

#import "THKDiaryDirectoryChildVC.h"
#import "THKDiaryDirectoryCell.h"

@interface THKDiaryDirectoryChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation THKDiaryDirectoryChildVC

#pragma mark - Lifecycle 

// 初始化
- (void)thk_initialize{

}

// 渲染VC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titles = @[@"开工前",@"买建材",@"施工中",@"家电软装",@"入住新家"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorHex(ECEEEC);
    [self.tableView addSubview:line];
    line.layer.zPosition = -1;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(14.5);
        make.width.mas_equalTo(1);
//        make.bottom.mas_equalTo(0);
        make.bottom.equalTo(self.view.mas_bottom);
//        make.height.mas_equalTo(999);
    }];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

// 子视图布局
- (void)thk_addSubviews{

}

// 绑定VM
- (void)bindViewModel {

}

#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THKDiaryDirectoryCell *cell = (THKDiaryDirectoryCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKDiaryDirectoryCell.class) forIndexPath:indexPath];
//    cell.textLabel.text = @(indexPath.row).stringValue;
    cell.indexPath = indexPath;
    cell.titleLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [NSNotificationCenter.defaultCenter postNotificationName:@"clickDirectory" object:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:THKDiaryDirectoryCell.class forCellReuseIdentifier:NSStringFromClass(THKDiaryDirectoryCell.class)];
        _tableView.bounces = NO;
    }
    return _tableView;
}
#pragma mark - Private

#pragma mark - Getters and Setters

#pragma mark - Supperclass

#pragma mark - NSObject

@end
