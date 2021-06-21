//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "THKMaterialClassificationVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Button.str(@"如何选材").bgColor(@"random").xywh(100,100,100,100).addTo(self.view).onClick(^{
        Log(@"123123");
        [self.navigationController pushViewController:THKMaterialClassificationVC.new animated:YES];
    });
    
}


@end
