//
//  THKLeftViewController.m
//  Demo
//
//  Created by Joe.cheng on 2023/7/6.
//

#import "THKLeftViewController.h"
#import "BTCoverHorizontalTransition.h"

@interface THKLeftViewController ()

@property (nonatomic, strong) BTCoverHorizontalTransition *aniamtion;

@end

@implementation THKLeftViewController


- (instancetype)init{
    self = [super init];
    if (self) {
        _aniamtion = [[BTCoverHorizontalTransition alloc]initPresentViewController:self withRragDismissEnabal:YES];
        self.transitioningDelegate = _aniamtion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor.yellowColor colorWithAlphaComponent:1];
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
}

- (void)dealloc{
    NSLog(@"%@ is %@",NSStringFromClass(self.class),NSStringFromSelector(_cmd));
}


- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    // 适配屏幕，横竖屏
    self.preferredContentSize = CGSizeMake(traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact ? 600 : 300, self.view.bounds.size.height);
}


/// 屏幕旋转时调用的方法
/// @param newCollection 新的方向
/// @param coordinator 动画协调器
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

@end
