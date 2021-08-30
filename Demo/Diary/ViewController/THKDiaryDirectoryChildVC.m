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
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THKDiaryDirectoryCell *cell = (THKDiaryDirectoryCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKDiaryDirectoryCell.class) forIndexPath:indexPath];
//    cell.textLabel.text = @(indexPath.row).stringValue;
    cell.indexPath = indexPath;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    }
    return _tableView;
}
#pragma mark - Private

#pragma mark - Getters and Setters

#pragma mark - Supperclass

#pragma mark - NSObject

@end
