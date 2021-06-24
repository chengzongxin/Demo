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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    
    Button.str(@"TEST").bgColor(@"random").xywh(100,250,100,100).addTo(self.view).onClick(^{
        Log(@"123123");
        
        [self.navigationController pushViewController:TestViewController.new animated:YES];
    });
}


@end
