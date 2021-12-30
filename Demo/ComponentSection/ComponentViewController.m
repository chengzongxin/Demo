//
//  ComponentViewController.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/27.
//

#import "ComponentViewController.h"
#import "THKExpandLabelViewController.h"
#import "THKComboViewController.h"
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
                    Row.str(@"连击").fnt(18).detailStr(@"连击动效").subtitleStyle.cellHeightAuto.onClick(^{
                        THKComboViewController *vc = [[THKComboViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }),
                    )
            ).header(@0.01).footer(@0.01).embedIn(self.view);
}

@end
