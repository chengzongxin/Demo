//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "SectionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Button.str(@"如何选材").bgColor(@"random").xywh(100,100,100,100).addTo(self.view).onClick(^{
        Log(@"123123");
        [self.navigationController pushViewController:SectionViewController.new animated:YES];
    });
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    Log(@"xxxx");
}

@end
