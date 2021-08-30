//
//  THKDiaryDirectoryVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/27.
//

#import "THKDiaryDirectoryVC.h"
#import "THKDiaryDirectoryChildVC.h"
#import "THKDiraryDirectoryServiceVC.h"

#define SLIP_ORIGIN_FRAME CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH - 80, SCREEN_HEIGHT)
#define SLIP_DISTINATION_FRAME CGRectMake(0, 0, SCREEN_WIDTH - 80, SCREEN_HEIGHT)

@interface THKDiaryDirectoryVC ()

@property (copy, nonatomic) SideSlipFilterCommitBlock commitBlock;
@property (copy, nonatomic) SideSlipFilterResetBlock resetBlock;
@property (weak, nonatomic) UINavigationController *filterNavigation;
@property (strong, nonatomic) UIView *backCover;
@property (weak, nonatomic) UIViewController *sponsor;
@end

@implementation THKDiaryDirectoryVC

#pragma mark - Lifecycle 
- (instancetype)initWithSponsor:(UIViewController *)sponsor
                    resetBlock:(SideSlipFilterResetBlock)resetBlock
                    commitBlock:(SideSlipFilterCommitBlock)commitBlock {
    self = [super init];
    if (self) {
        NSAssert(sponsor.navigationController, @"ERROR: sponsor must have the navigationController");
        _sponsor = sponsor;
        _resetBlock = resetBlock;
        _commitBlock = commitBlock;
        UINavigationController *filterNavigation = [[NSClassFromString(@"UINavigationController") alloc] initWithRootViewController:self];
//        [filterNavigation setNavigationBarHidden:YES];
        filterNavigation.navigationBar.translucent = NO;
        filterNavigation.navigationBar.shadowImage = UIImage.new;
//        [self thk_hideNavShadowImageView];
        [filterNavigation.view setFrame:SLIP_ORIGIN_FRAME];
        self.filterNavigation = filterNavigation;
    }
    return self;
}
// 初始化
- (void)thk_initialize{

}

// 渲染VC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self reloadData];
//    self.contentView.bounces = NO;
}

// 子视图布局
- (void)thk_addSubviews{
    
}

// 绑定VM
- (void)bindViewModel {

}

#pragma mark - Public
- (void)show {
    [_sponsor.navigationController.view addSubview:self.backCover];
    [_sponsor.navigationController addChildViewController:self.navigationController];
    [_sponsor.navigationController.view addSubview:self.navigationController.view];
    
    [_backCover setHidden:YES];
    [UIView animateWithDuration:0.2 animations:^{
        [self.navigationController.view setFrame:SLIP_DISTINATION_FRAME];
    } completion:^(BOOL finished) {
        [self.backCover setHidden:NO];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        [self.navigationController.view setFrame:SLIP_ORIGIN_FRAME];
    } completion:^(BOOL finished) {
        [self.backCover removeFromSuperview];
        [self.navigationController.view removeFromSuperview];
        [self.navigationController removeFromParentViewController];
    }];
}


#pragma mark - Event Respone
- (void)clickBackCover:(id)sender {
    [self dismiss];
}

#pragma mark - Delegate
- (NSArray<NSString *> *)titlesForChildViewControllers{
    return @[@"目录",@"屋主相关服务"];
}

- (NSArray<UIViewController *> *)viewControllersForChildViewControllers{
    return @[THKDiaryDirectoryChildVC.new,THKDiraryDirectoryServiceVC.new];
}

- (UIColor *)contentViewBackgroundColor{
    return UIColor.clearColor;
}

//- (UIView *)viewForHeader{
//    return UIView.new;
//}
//
//- (CGFloat)heightForHeader{
//    return 44;
//}

- (void)segmentControlConfig:(THKSegmentControl *)control{
    control.indicatorView.backgroundColor = UIColorHex(22C787);
    [control setTitleFont:[UIFont systemFontOfSize:14] forState:UIControlStateNormal];
    [control setTitleFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium] forState:UIControlStateSelected];
    [control setTitleColor:UIColorHex(7E807E) forState:UIControlStateNormal];
    [control setTitleColor:UIColorHex(333333) forState:UIControlStateSelected];
    control.height = 40;
}

#pragma mark - Private

#pragma mark - Getters and Setters
- (UIView *)backCover {
    if (!_backCover) {
        _backCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_backCover setBackgroundColor:UIColor.blackColor];
        [_backCover setAlpha:0.5];
        [_backCover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackCover:)]];
    }
    return _backCover;
}
#pragma mark - Supperclass

#pragma mark - NSObject

@end
