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
#import "THKOSSViewController.h"

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
    
    Button.str(@"OSS").bgColor(@"random").xywh(250,250,100,100).addTo(self.view).onClick(^{
        Log(@"123123");
        THKOSSViewController *vc = [[THKOSSViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
    NSString *tag = @"#123入住新家#  ";
    NSString *str = @"13:39 👍🏾👍🏾\n\n😬😬😬\n\n哈哈哈哈哈哈哈哈哈哈哈哈哈哈👍🏾👍🏾👍🏾👍🏾👍🏾👍🏾";
    
    THKExpandLabel *label = THKExpandLabel.new;
    
    label.numberOfLines = 0;
    label.lineGap = 6;
    label.maxWidth = TMUI_SCREEN_WIDTH - 100;
    label.preferFont = UIFont(16);
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(50);
        make.top.mas_equalTo(400);
    }];
    @weakify(label);
    label.unfoldClick = ^{
        @strongify(label);
        NSLog(@"%@",label.text);
    };
//    label.tagStr = @"入住新家";
//    label.contentStr = str;
//    [label setTagStr:@"#123入住新家#  " contentStr:str];
    [label setTagStr:nil
         tagAttrDict:@{NSForegroundColorAttributeName:THKColor_999999,NSFontAttributeName:UIFontMedium(16)}
          contentStr:str
     contentAttrDict:@{NSForegroundColorAttributeName:UIColorHex(#1A1C1A),NSFontAttributeName:UIFont(16)}];
}

@end
