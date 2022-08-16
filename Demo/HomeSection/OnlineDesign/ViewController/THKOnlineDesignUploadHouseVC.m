//
//  THKOnlineDesignUploadHouseVC.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKOnlineDesignUploadHouseVC.h"

@interface THKOnlineDesignUploadHouseVC ()

@property (nonatomic, strong) THKOnlineDesignUploadHouseVM *viewModel;

@end

@implementation THKOnlineDesignUploadHouseVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.thk_title = @"添加我家信息";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
