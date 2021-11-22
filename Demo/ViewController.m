//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "THKMaterialClassificationVC.h"
#import "THKMaterialClassificationVM.h"
#import "THKMaterialHotRankVC.h"
#import "THKMaterialHotRankVM.h"
#import "THKDiaryBookVC.h"
#import "THKExpandLabel.h"
#import "DynamicTabDemoList.h"
#import "THKQuickCommentsView.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}

- (void)test{
    
    
    Button.str(@"如何选材").bgColor(@"random").xywh(100,100,100,100).addTo(self.view).onClick(^{
        Log(@"123123");
        TRouter *router = [TRouter routerWithName:THKRouterPage_SelectMaterialCategoryDetail
                                            param:@{@"mainCategoryId" : @4}
                                   jumpController:self];
        [[TRouterManager sharedManager] performRouter:router];
    });
    
    Button.str(@"热门排行榜").bgColor(@"random").xywh(250,100,100,100).addTo(self.view).onClick(^{
        Log(@"123123");
        THKMaterialHotRankVM *vm = [[THKMaterialHotRankVM alloc] init];
        THKMaterialHotRankVC *vc = [[THKMaterialHotRankVC alloc] initWithViewModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
    // File: ani@3x.gif
//    UIImage *image = [YYImage imageNamed:@"718.apng"];
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] init];
    [imageView setImageURL:[NSURL URLWithString:@"http://pic.to8to.com/infofed/20210701/d8377a0ac76c9c965d1fe3ca8295e27a.webp"]];
    [self.view addSubview:imageView];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(100);
        make.width.height.mas_equalTo(100);
    }];
    
    
    Button.str(@"日记本").bgColor(@"random").xywh(100,250,100,100).addTo(self.view).onClick(^{
        Log(@"123123");
        THKDiaryBookVM *vm = [[THKDiaryBookVM alloc] init];
        THKDiaryBookVC *vc = [[THKDiaryBookVC alloc] initWithViewModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
    Button.str(@"Tab组件").bgColor(@"random").xywh(250,250,100,100).addTo(self.view).onClick(^{
        DynamicTabDemoList *vc = [[DynamicTabDemoList alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
    [self comment];
}

- (void)comment{
    THKQuickCommentsView *view = [[THKQuickCommentsView alloc] init];
    
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(20);
        make.top.equalTo(@500);
        make.height.equalTo(@30);
    }];
    
    THKQuickCommentsViewModel *vm = [[THKQuickCommentsViewModel alloc] init];
    vm.comments = @[@"房间路发😆多少",@"🔥 房开发多少",@"😋房间发多少",@"房上路发多少😆",@"路发多少",@"开上多少",@"房间大发多少",@"房间多少",@"房路发少"];
    [view bindViewModel:vm];
    
    view.tapItem = ^(NSString * _Nonnull text) {
        NSLog(@"%@",text);
    };
}


@end
