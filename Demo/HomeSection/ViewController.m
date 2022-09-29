//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "THKValuePointIntroductionVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorWhite;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self push];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self push];
}

- (void)push{
    THKValuePointIntroductionVM *vm = [THKValuePointIntroductionVM new];
    
    THKValuePointImg *img1 = [THKValuePointImg createImgWith:@"https://cdn.pixabay.com/photo/2020/03/31/19/20/dog-4988985_1280.jpg" width:6000 height:4000];
    THKValuePointImg *img2 = [THKValuePointImg createImgWith:@"https://cdn.pixabay.com/photo/2022/05/21/09/30/cat-7211080_1280.jpg" width:6000 height:8000];
    THKValuePointImg *img3 = [THKValuePointImg createImgWith:@"https://media.istockphoto.com/photos/little-kitten-sitting-on-a-street-near-the-car-wheel-picture-id1337794362" width:6000 height:6000];
    
    vm.imgs = @[img1,img2,img3];
    
    THKValuePointIntroductionVC *vc = [[THKValuePointIntroductionVC alloc] initWithViewModel:vm];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 定时输入

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self showInputing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)dealloc{
    NSLog(@"delloc %@",self);
}

- (void)showInputing{
    self.thk_title = @"正在输入中...";
    
    [self performSelector:@selector(cancelInput) afterDelay:5];
}

- (void)cancelInput{
    
    self.thk_title = @"";
    
    [self performSelector:@selector(showInputing) afterDelay:2];
}

@end
