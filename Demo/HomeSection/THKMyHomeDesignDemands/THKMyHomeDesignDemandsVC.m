//
//  THKMyHomeDesignDemandsVC.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKMyHomeDesignDemandsVC.h"
#import "THKMyHomeDesignDemandsCell.h"

//typedef enum : NSUInteger {
//    <#MyEnumValueA#>,
//    <#MyEnumValueB#>,
//    <#MyEnumValueC#>,
//} <#MyEnum#>;

@interface THKMyHomeDesignDemandsVC () <UITableViewDelegate,UITableViewDataSource>

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
    
    
    [self.viewModel.configCommand.nextSignal subscribeNext:^(id  _Nullable x) {
            
    }];
    
    [self.viewModel.queryCommand.nextSignal subscribeNext:^(id  _Nullable x) {
            
    }];
    
    [self.viewModel.editCommand.nextSignal subscribeNext:^(id  _Nullable x) {
            
    }];
    
    [self.viewModel.configCommand execute:nil];
    [self.viewModel.queryCommand execute:nil];
    [self.viewModel.editCommand execute:nil];
}



#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THKMyHomeDesignDemandsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKMyHomeDesignDemandsCell.class) forIndexPath:indexPath];
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
