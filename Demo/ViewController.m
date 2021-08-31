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
#import "ExpandLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    
    NSString *str = @"dfsfdshhfesf sddsfkjd lkfdsj lfjh sdjkfhk egf hsjfg dhs fghdsfg ewhj dfgjshf jdshfg hdsf gdsfdsfd asdhjk dhkajs gkfds fhkjsdfhesalfhdlskafjlaskdfj ldksaf jldsafafdsafewafsa fds fadsf das fdas fdsaf dsaf dsaf dsafeawfdewafefrg 12313123213 sdad";
    
    ExpandLabel *label = ExpandLabel.new;
    
    label.numberOfLines = 3;
    label.lineSpacing = 10;
    label.maxWidth = TMUI_SCREEN_WIDTH;
    label.preferFont = UIFont(20);
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(600);
    }];
    @weakify(label);
    label.unfoldClick = ^{
        @strongify(label);
        NSLog(@"%@",label.text);
    };
//    label.tagStr = @"入住新家";
//    label.contentStr = str;
    [label setTagStr:@"入住新家" contentStr:str];
    
//    label.attributedText = [NSAttributedString tmui_attributedStringWithString:str font:UIFont(20) color:UIColor.redColor];
}

@end
