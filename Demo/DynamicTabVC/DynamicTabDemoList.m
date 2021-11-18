//
//  DynamicTabDemoList.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/18.
//

#import "DynamicTabDemoList.h"
#import "DynamicTabVC.h"
#import "DynamicTabLevelVC.h"

@interface DynamicTabDemoList ()

@end

@implementation DynamicTabDemoList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    GroupTV(
            Section(
                    Row.str(@"单Tab组件").fnt(18).detailStr(@"动态tab子VC").subtitleStyle.cellHeightAuto.onClick(^{
                        
                        DynamicTabVM *vm = [[DynamicTabVM alloc] init];
                        vm.isSuspend = DynamicTabStyle_Single;
                        DynamicTabVC *vc = [[DynamicTabVC alloc] initWithViewModel:vm];
                        [self.navigationController pushViewController:vc animated:YES];
                    }),
                    Row.str(@"吸顶Tab组件").fnt(18).detailStr(@"动态tab子VC").subtitleStyle.cellHeightAuto.onClick(^{
                        
                        DynamicTabVM *vm = [[DynamicTabVM alloc] init];
                        vm.isSuspend = DynamicTabStyle_Suspend;
                        DynamicTabVC *vc = [[DynamicTabVC alloc] initWithViewModel:vm];
                        [self.navigationController pushViewController:vc animated:YES];
                    }),
                    Row.str(@"嵌套吸顶Tab组件").fnt(18).detailStr(@"动态tab子VC").subtitleStyle.cellHeightAuto.onClick(^{
                        
                        DynamicTabVM *vm = [[DynamicTabVM alloc] init];
                        vm.isSuspend = DynamicTabStyle_Nested;
                        DynamicTabVC *vc = [[DynamicTabVC alloc] initWithViewModel:vm];
                        [self.navigationController pushViewController:vc animated:YES];
                    }),
                    )
            ).header(@0.01).footer(@0.01).embedIn(self.view);
}


@end
