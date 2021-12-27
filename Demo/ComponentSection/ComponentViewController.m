//
//  ComponentViewController.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/27.
//

#import "ComponentViewController.h"
#import "THKExpandLabelViewController.h"
@interface ComponentViewController ()

@end

@implementation ComponentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GroupTV(
            Section(
                    Row.str(@"展开Label").fnt(18).detailStr(@"展开Label组件").subtitleStyle.cellHeightAuto.onClick(^{
                        THKExpandLabelViewController *vc = [[THKExpandLabelViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }),
                    Row.str(@"九宫格").fnt(18).detailStr(@"九宫格组件").subtitleStyle.cellHeightAuto.onClick(^{
                        
                    }),
                    )
            ).header(@0.01).footer(@0.01).embedIn(self.view);
}

@end
