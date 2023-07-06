//
//  THKPresentViewController.m
//  Demo
//
//  Created by Joe.cheng on 2023/7/6.
//

#import "THKPresentViewController.h"
#import "BTCoverVerticalTransition.h"
#import "BTTransitionAnimationDelegate.h"

@interface THKPresentViewController ()<BTTransitionAnimationDelegate>

@property (nonatomic, strong) BTCoverVerticalTransition *aniamtion;

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation THKPresentViewController

/// init时会调用
- (instancetype)init{
    self = [super init];
    if (self) {
        [self thk_initialize];
    }
    return self;
}


/// initWithVM时会调用，这里需要重写，因为父类会重新设置弹出样式，导致无法半屏
/// - Parameter viewModel: vm
- (instancetype)initWithViewModel:(THKViewModel *)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        [self thk_initialize];
    }
    return self;
}

- (void)thk_initialize {
    [super thk_initialize];
    
    _aniamtion = [[BTCoverVerticalTransition alloc]initPresentViewController:self withRragDismissEnabal:YES];
    self.transitioningDelegate = _aniamtion;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
    [self.view tmui_cornerDirect:UIRectCornerTopLeft|UIRectCornerTopRight radius:12];
    
    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    // 适配屏幕，横竖屏
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact ? 270 : (self.viewHeight?:TMUI_SCREEN_HEIGHT * 0.8));
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


- (void)setModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle {
    [super setModalPresentationStyle:modalPresentationStyle];
}

#pragma mark - Event Respone

- (void)clickCloseBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
    !_backBlock?:_backBlock();
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton tmui_button];
        _closeBtn.tmui_image = UIImageMake(@"present_close_black");
        [_closeBtn tmui_addTarget:self action:@selector(clickCloseBtn)];
    }
    return _closeBtn;
}

@end
