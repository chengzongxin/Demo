//
//  DynamicTabVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/17.
//

#import "DynamicTabVC.h"

@interface DynamicTabVC ()
@property (nonatomic, strong, readwrite) DynamicTabVM *viewModel;
@end

@implementation DynamicTabVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
}

@end
