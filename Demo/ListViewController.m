//
//  ListViewController.m
//  Demo
//
//  Created by Joe.cheng on 2021/2/8.
//

#import "ListViewController.h"
#import "ListCell.h"
@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
}



#pragma mark UITableViewDelegate UITableViewDataSource

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.grayColor;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(ListCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(ListCell.class)];
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ListCell.class) forIndexPath:indexPath];
    
    if (indexPath.row % 2) {
        THKAvatarViewModel *vm7 = [[THKAvatarViewModel alloc] initWithAvatarUrl:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2458338947,591929039&fm=26&gp=0.jpg" identityType:10];
        [cell.avatar bindViewModel:vm7];
        
        [vm7.onTapSubject subscribeNext:^(id  _Nullable x) {
            NSLog(@"vm7 %@",x);
        }];
        
        THKIdentityViewModel *i0 = [[THKIdentityViewModel alloc] initWithType:12 subType:0 style:THKIdentityStyle_IconText];
        [cell.identityIconText bindViewModel:i0];
        [i0.onTapSubject subscribeNext:^(id  _Nullable x) {
            NSLog(@"i0 %@",x);
        }];
        
        [cell.identity bindViewModel:[[THKIdentityViewModel alloc] initWithType:11 subType:0 style:THKIdentityStyle_Icon]];
        
    }else{
        THKAvatarViewModel *vm7_1 = [[THKAvatarViewModel alloc] initWithAvatarUrl:@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3927348840,3579255094&fm=11&gp=0.jpg" identityType:11];
        [cell.avatar bindViewModel:vm7_1];
        
        [vm7_1.onTapSubject subscribeNext:^(id  _Nullable x) {
            NSLog(@"vm7_1 %@",x);
        }];
        
        THKIdentityViewModel *i0_1 = [[THKIdentityViewModel alloc] initWithType:10 subType:0 style:THKIdentityStyle_IconText];
        [cell.identityIconText bindViewModel:i0_1];
        [i0_1.onTapSubject subscribeNext:^(id  _Nullable x) {
            NSLog(@"i0_1 %@",x);
        }];
        
        [cell.identity bindViewModel:[[THKIdentityViewModel alloc] initWithType:13 subType:0 style:THKIdentityStyle_Icon]];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
