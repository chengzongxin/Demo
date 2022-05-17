//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "TMUICycleCardView.h"
@interface ViewController ()

@property (nonatomic, strong) TMUICycleCardView *cycle;

@end

@implementation ViewController

// test push
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    self.view.backgroundColor = UIColor.whiteColor;
    
    TMUICycleCardView *cycle = [[TMUICycleCardView alloc] initWithFrame:CGRectMake(100, 200, 300, 200)];
//    cycle.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:cycle];
    self.cycle = cycle;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.cycle scroll];
}



@end
