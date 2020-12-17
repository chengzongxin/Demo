//
//  THKShowBigImageViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/12/14.
//

#import "THKShowBigImageViewController.h"
#import "THKShadowImageView.h"
#import "THKAnimatorTransition.h"
#import "UIView+TMUI.h"
#import "THKShadowImageView.h"

@interface THKShowBigImageViewController ()

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) THKAnimatorTransition *transitionAnimator;


@end

@implementation THKShowBigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.blackColor;
    
    
    UIImageView *imageViewView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageViewView.image = self.image;
    imageViewView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageViewView];
    _imageView = imageViewView;
    
}

+ (void)showBigImageWithImageView:(UIImageView *)imageView transitionStyle:(THKTransitionStyle)transitionStyle{
    
    UIViewController *fromVC = imageView.tmui_viewController;
    fromVC.modalPresentationStyle = UIModalPresentationCustom;
    THKShowBigImageViewController *imageVC = [[THKShowBigImageViewController alloc] init];
    imageVC.image = imageView.image;
    // transition
    THKAnimatorTransition *animatorTransition = [[THKAnimatorTransition alloc] init];
    // 设置手势
    [animatorTransition addGestureWithVC:imageVC direction:THKTransitionGestureDirectionDown];;
    // 设置动画图片尺寸，图片
    animatorTransition.image = imageView.image;
    animatorTransition.imgFrame = [imageView convertRect:imageView.frame toView:UIApplication.sharedApplication.keyWindow];
    // 设置转场代理
    fromVC.transitioningDelegate = animatorTransition;
    fromVC.navigationController.delegate = animatorTransition;
    imageVC.transitioningDelegate = animatorTransition;
    imageVC.transitionAnimator = animatorTransition; // 强引用，避免被释放
    
    if (transitionStyle == THKTransitionStylePush) {
        [fromVC.navigationController pushViewController:imageVC animated:YES];
    }else{
        [fromVC presentViewController:imageVC animated:YES completion:nil];
    }
}


@end
