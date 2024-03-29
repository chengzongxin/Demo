//
//  ViewController.m
//  TestIrregularView
//
//  Created by LuoKI on 2018/4/23.
//  Copyright © 2018年 LuoLi. All rights reserved.
//

#import "IrregularViewController.h"
#import "IrregularBtn.h"
#import "THKDecorationCompareImageView.h"

#define kViewWidth(View) CGRectGetWidth(View.frame)
#define kViewHeight(View) CGRectGetHeight(View.frame)

@interface IrregularViewController ()

@end

@implementation IrregularViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = UIColor.whiteColor;

    [self view1]; //右斜边梯形
    [self view2]; //平行四边形
    [self view3]; //左斜边梯形

    [self view4]; //六角形
    [self view5]; //对折形状

    [self view6]; //箭头
    
    [self compareView];
    
}

- (void)compareView{
    THKDecorationCompareImageView *view = [[THKDecorationCompareImageView alloc] initWithFrame:CGRectMake(15, 600, TMUI_SCREEN_WIDTH - 80, 100)];
    [self.view addSubview:view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        view.imgs = @[@"https://pic.to8to.com/case/20210906/c6c1023b00cb164de7c9ddb52ecaa00e.jpg!500.webp",
                      @"https://pic.to8to.com/case/1910/28/20191028_bae8696af540a8a6cbb9nkxdojvrpoe7.png!500.webp"];
    });
}


//右斜边梯形
- (void)view1
{
    //
    IrregularBtn * btn = [IrregularBtn buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 100, 120, 50);
//    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"按钮1" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
//    [btn setBackgroundImage:[UIImage imageNamed:@"timg-1.jpeg"] forState:UIControlStateNormal];
    [btn setBackgroundImageWithURL:[NSURL URLWithString:@"https://cdn.pixabay.com/photo/2020/03/31/19/20/dog-4988985_1280.jpg"] forState:UIControlStateNormal options:0];
    // 添加路径关键点array
    NSMutableArray *pointArray = [NSMutableArray array];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(0.f, 0.f))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn), 0.f))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn) *3/4, btn.frame.size.height))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(0.f, kViewHeight(btn)))];
    
    //
    btn.pointArray = [pointArray mutableCopy];
    
}


//平行四边形
- (void)view2
{
    //
    IrregularBtn * btn = [IrregularBtn buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(120, 100, 120, 50);
//    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"按钮2" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
//    [btn setBackgroundImage:[UIImage imageNamed:@"timg-2.jpeg"] forState:UIControlStateNormal];
    [btn setBackgroundImageWithURL:[NSURL URLWithString:@"https://cdn.pixabay.com/photo/2022/05/21/09/30/cat-7211080_1280.jpg"] forState:UIControlStateNormal options:0];
    
    
    // 添加路径关键点array
    NSMutableArray *pointArray = [NSMutableArray array];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(0.f, kViewHeight(btn)))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn)/4, 0.f))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn), 0.f))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn) *3/4, btn.frame.size.height))];
    
    //
    btn.pointArray = [pointArray mutableCopy];
    
}


//左斜边梯形
- (void)view3
{
    //
    IrregularBtn * btn = [IrregularBtn buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(220, 100, 120, 50);
    btn.backgroundColor = [UIColor cyanColor];
    [btn setTitle:@"按钮3" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    // 添加路径关键点array
    NSMutableArray *pointArray = [NSMutableArray array];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn)/4, 0.f))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn), 0.f))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn), btn.frame.size.height))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(0.f, kViewHeight(btn)))];
    
    //
    btn.pointArray = [pointArray mutableCopy];
}


//六角形
- (void)view4
{
    //
    IrregularBtn * btn = [IrregularBtn buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 200, 150, 150);
    btn.backgroundColor = [UIColor purpleColor];
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    // 添加路径关键点array
    float viewWidth = btn.frame.size.width;
    NSMutableArray *pointArray = [NSMutableArray array];
    
    CGPoint point1 = CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 4));
    CGPoint point2 = CGPointMake((viewWidth / 2), 0);
    CGPoint point3 = CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)),
                                 (viewWidth / 4));
    CGPoint point4 = CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)),
                                 (viewWidth / 2) + (viewWidth / 4));
    CGPoint point5 = CGPointMake((viewWidth / 2), viewWidth);
    CGPoint point6 = CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2),
                                 (viewWidth / 2) + (viewWidth / 4));
    
    [pointArray addObject:NSStringFromCGPoint(point1)];
    [pointArray addObject:NSStringFromCGPoint(point2)];
    [pointArray addObject:NSStringFromCGPoint(point3)];
    [pointArray addObject:NSStringFromCGPoint(point4)];
    [pointArray addObject:NSStringFromCGPoint(point5)];
    [pointArray addObject:NSStringFromCGPoint(point6)];
    
    //
    btn.pointArray = [pointArray mutableCopy];
    
}


//对折形状
- (void)view5
{
    //
    IrregularBtn * btn = [IrregularBtn buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(200, 200, 150, 150);
    btn.backgroundColor = [UIColor brownColor];
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    // 添加路径关键点array
    NSMutableArray *pointArray = [NSMutableArray array];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(0.f, 0.f))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn), 0.f))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(0.f, kViewHeight(btn)))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn), kViewHeight(btn)))];
    
    
    //
    btn.pointArray = [pointArray mutableCopy];
    
}

//箭头
- (void)view6 {
    
    //
    IrregularBtn * btn = [IrregularBtn buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 380, 330, 150);
    btn.backgroundColor = [UIColor magentaColor];
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    // 添加路径关键点array
    NSMutableArray *pointArray = [NSMutableArray array];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(0.f, kViewHeight(btn)/3))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn) *2/3, kViewHeight(btn)/3))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn) *2/3, 0.f))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn), kViewHeight(btn)/2))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn) *2/3, kViewHeight(btn)))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn) *2/3, kViewHeight(btn) *2/3))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(0.f, kViewHeight(btn) *2/3))];
    
    
    //
    btn.pointArray = [pointArray mutableCopy];
    
}



//
- (void)btnAction:(UIButton *)btn{
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    [btn setBackgroundColor:[UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
