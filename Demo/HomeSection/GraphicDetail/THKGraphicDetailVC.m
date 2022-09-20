//
//  THKGraphicDetailVC.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import "THKGraphicDetailVC.h"

@interface THKGraphicDetailVC ()

@property (nonatomic, strong) THKGraphicDetailVM *viewModel;

@end

@implementation THKGraphicDetailVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)bindViewModel{
    [super bindViewModel];
    
//    1011138
//    1011136
//    这两个id有数据
    [self.viewModel.requestCommand execute:@1011138];
    
}



@end
