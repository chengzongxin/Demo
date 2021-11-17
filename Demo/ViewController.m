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
#import "DynamicTabVC.h"

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
        DynamicTabVM *vm = [[DynamicTabVM alloc] init];
        DynamicTabVC *vc = [[DynamicTabVC alloc] initWithViewModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
    
}

- (void)expandLabel{
    
    NSString *tag = @"#123入住新家#  \n\n";
    NSString *str = @"    \n\n\n\n   13:39 👍🏾👍🏾\n\n😬😬😬\n\n哈哈哈哈哈哈哈哈哈哈哈哈哈哈👍🏾👍🏾👍🏾👍🏾👍🏾👍🏾    \n\n\n\n\n\n   ";
    
    THKExpandLabel *label = THKExpandLabel.new;
    label.backgroundColor = UIColor.tmui_randomColor;
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
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self doCurrentApiRequestTest];
//
//            for (int i = 0; i < 20; i++) {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self doCurrentApiRequestTest];
//                });
//
//            }
//
//        });
    
}

- (void)doCurrentApiRequestTest {
#if DEBUG
    
//    Class cls = THKDynamicGroupEntranceRequest.class;
//    void (^customReqInfosBlock)(__kindof THKBaseRequest *req) = ^(__kindof THKBaseRequest *req) {
//        ((THKDynamicGroupEntranceRequest*)req).wholeCode = kDynamicTabsWholeCodeCaseList;
//    };
//    if (cls) {
//        THKBaseRequest *req = [[cls alloc] init];
//        customReqInfosBlock(req);
//        [req.rac_requestSignal subscribeNext:^(THKResponse *x) {
//            NSLog(@"response: %@", x);
//        } error:^(NSError * _Nullable error) {
//            NSLog(@"err: %@", error);
//        }];
//    }
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

//    NSString *css1 = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.baidu1.com"] encoding:NSUTF8StringEncoding error:nil];
//
//    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
//    NSLog(@"1111111方法耗时: %f ms", endTime * 1000.0);
//    startTime = CFAbsoluteTimeGetCurrent();
    
    NSString *urlString1 = [NSString stringWithFormat:@"https://appapi.to8to.com/social/article/detail?id=%ld", (long)1007115];
         //处理字符
         urlString1 = [urlString1 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
         //创建URL
         NSURL *url1 = [NSURL URLWithString:urlString1];
         //2.创建请求类
         NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
         //3.创建会话
         //delegateQueue 表示协议方法在哪个线程中执行
         NSURLSession *session1 = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil  delegateQueue:[NSOperationQueue mainQueue]];
         //4.根据会话创建任务
//        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        NSURLSessionDataTask *dataTask1 = [session1 dataTaskWithRequest:request1 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //        NSDictionary *secondDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    ////        NSLog(@"666666-----%@", secondDictionary);
    //
    //        NSString *content = [[secondDictionary objectForKey:@"data"] objectForKey:@"content"];
    //

            CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
            NSLog(@"--666666-----------方法耗时: %f ms", endTime * 1000.0);

            NSLog(@"666666------方法111: %@", error);

        }];
         //5.启动任务
         [dataTask1 resume];


    
#endif
}

@end
