//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "THKValuePointIntroductionVC.h"
#import "THKOpenWXProgramAlertView.h"
#import "THKCalculateQuotationView.h"
#import "IrregularViewController.h"
#import "FLDefaultRadarChartViewController.h"
#import "THKDecPKView.h"
#import "TIMCompanyPKRoomDetailRequest.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) THKDecPKView *pkView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    
    [self.view addSubview:self.tableView];
    
    TIMCompanyPKRoomDetailRequest *request = [TIMCompanyPKRoomDetailRequest new];
    [request sendSuccess:^(TIMCompanyPKRoomDetailResponse * _Nonnull response) {
        [self addView:response.data];
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)addView:(THKDecPKModel *)model{
    
    THKDecPKView *view = [[THKDecPKView alloc] init];
    THKDecPKViewModel *viewModel = [[THKDecPKViewModel alloc] initWithModel:model];
    [view bindViewModel:viewModel];
//    [self.view addSubview:view];
    [self.tableView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TMUI_SCREEN_WIDTH - 40);
        make.top.mas_equalTo(-584);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(584);
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(584, 0, 0, 0);
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
    
    self.pkView = view;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self push];
//}


- (void)push{
    [self.navigationController pushViewController:FLDefaultRadarChartViewController.new animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 0) {
//        NSLog(@"fold-%f",scrollView.contentOffset.y);
        self.pkView.fold = YES;
        
        [self.pkView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(scrollView.contentOffset.y + tmui_navigationBarHeight() + 20);
        }];
    }else{
//        NSLog(@"unfold-%f",scrollView.contentOffset.y);
        self.pkView.fold = NO;
        
        
        [self.pkView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-584);
        }];
    }
    
}

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}


@end
