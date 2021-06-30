//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "THKMaterialClassificationVC.h"
#import "THKMaterialClassificationViewModel.h"
#import "THKMaterialHotRankVC.h"
#import "THKMaterialHotRankVM.h"
#import "TestViewController.h"
#import "THKMaterialTitleRankView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor.blueColor colorWithAlphaComponent:0.3];
    
    Button.str(@"如何选材").bgColor(@"random").xywh(100,100,100,100).addTo(self.view).onClick(^{
        Log(@"123123");
        THKMaterialClassificationViewModel *vm = [[THKMaterialClassificationViewModel alloc] init];
        vm.subCategoryId = 1;
        THKMaterialClassificationVC *vc = [[THKMaterialClassificationVC alloc] initWithViewModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
    Button.str(@"热门排行榜").bgColor(@"random").xywh(250,100,100,100).addTo(self.view).onClick(^{
        Log(@"123123");
        THKMaterialHotRankVM *vm = [[THKMaterialHotRankVM alloc] init];
        THKMaterialHotRankVC *vc = [[THKMaterialHotRankVC alloc] initWithViewModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
//    Button.str(@"TEST").bgColor(@"random").xywh(100,250,100,100).addTo(self.view).onClick(^{
//        Log(@"123123");
//
//        [self.navigationController pushViewController:TestViewController.new animated:YES];
//    });
    
    THKMaterialTitleRankView *rankView = [[THKMaterialTitleRankView alloc] initWithStyle:THKMaterialTitleRankViewStyleBlue titleFont:UIFont(24)];
    [self.view addSubview:rankView];
    [rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(300);
        make.left.mas_equalTo(25);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    [rankView setText:@"O(∩_∩)O哈哈~1"];
    
    THKMaterialTitleRankView *rankView2 = [[THKMaterialTitleRankView alloc] initWithStyle:THKMaterialTitleRankViewStyleBlue titleFont:UIFont(20)];
    [self.view addSubview:rankView2];
    [rankView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(400);
        make.left.mas_equalTo(25);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(35);
    }];
    
    [rankView2 setText:@"O(∩_∩)O哈哈~2"];
    
    THKMaterialTitleRankView *rankView3 = [[THKMaterialTitleRankView alloc] initWithStyle:THKMaterialTitleRankViewStyleGold titleFont:UIFont(14)];
    [self.view addSubview:rankView3];
    [rankView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(500);
        make.left.mas_equalTo(25);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(26);
    }];
    
    [rankView3 setText:@"O(∩_∩)O哈哈~3"];
    
    THKMaterialTitleRankView *rankView4 = [[THKMaterialTitleRankView alloc] initWithStyle:THKMaterialTitleRankViewStyleGold titleFont:UIFont(10)];
    [self.view addSubview:rankView4];
    [rankView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(600);
        make.left.mas_equalTo(25);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
    }];
    
    [rankView4 setText:@"O(∩_∩)O哈哈~4"];
    
    
    
    
    THKMaterialTitleRankView *rankView5 = [[THKMaterialTitleRankView alloc] initWithStyle:THKMaterialTitleRankViewStyleBlue_NoCrown titleFont:UIFont(24)];
    [self.view addSubview:rankView5];
    [rankView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(300);
        make.left.mas_equalTo(325);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    [rankView5 setText:@"O(∩_∩)O哈哈~5"];
    
    THKMaterialTitleRankView *rankView6 = [[THKMaterialTitleRankView alloc] initWithStyle:THKMaterialTitleRankViewStyleBlue_NoCrown titleFont:UIFont(20)];
    [self.view addSubview:rankView6];
    [rankView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(400);
        make.left.mas_equalTo(225);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(35);
    }];
    
    [rankView6 setText:@"O(∩_∩)O哈哈~6"];
    
    THKMaterialTitleRankView *rankView7 = [[THKMaterialTitleRankView alloc] initWithStyle:THKMaterialTitleRankViewStyleGold_NoCrown titleFont:UIFont(14)];
    [self.view addSubview:rankView7];
    [rankView7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(500);
        make.left.mas_equalTo(225);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(26);
    }];
    
    [rankView7 setText:@"O(∩_∩)O哈哈~7"];
    
    THKMaterialTitleRankView *rankView8 = [[THKMaterialTitleRankView alloc] initWithStyle:THKMaterialTitleRankViewStyleGold_NoCrown titleFont:UIFont(10)];
    [self.view addSubview:rankView8];
    [rankView8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(600);
        make.left.mas_equalTo(225);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
    }];
    
    [rankView8 setText:@"O(∩_∩)O哈哈~8"];
    
}


@end
