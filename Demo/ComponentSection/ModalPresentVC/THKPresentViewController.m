//
//  THKPresentViewController.m
//  Demo
//
//  Created by Joe.cheng on 2023/7/6.
//

#import "THKPresentViewController.h"
#import "BTCoverVerticalTransition.h"

@interface THKPresentViewController ()

@property (nonatomic, strong) BTCoverVerticalTransition *aniamtion;

@end

@implementation THKPresentViewController


- (instancetype)init{
    self = [super init];
    if (self) {
        _aniamtion = [[BTCoverVerticalTransition alloc]initPresentViewController:self withRragDismissEnabal:YES];
        self.transitioningDelegate = _aniamtion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:1];
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
}

- (IBAction)sliderAction:(UISlider *)sender {
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, sender.value);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    // 适配屏幕，横竖屏
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact ? 270 : 420);
}


/// 屏幕旋转时调用的方法
/// @param newCollection 新的方向
/// @param coordinator 动画协调器
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

- (void)dealloc{
    NSLog(@"!!~~");
}

@end
