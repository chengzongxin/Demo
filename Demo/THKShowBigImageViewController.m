//
//  THKShowBigImageViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/12/14.
//

#import "THKShowBigImageViewController.h"
#import "THKShadowImageView.h"
#import "THKAnimatorTransition.h"
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
    
}


+ (void)showBigImageWithImageView:(THKShadowImageView *)imageView{
    NSLog(@"%@",imageView);
    UIViewController *fromVC = (UIViewController *)imageView.nextResponder.nextResponder.nextResponder.nextResponder;
    fromVC.modalPresentationStyle = UIModalPresentationCustom;
    THKShowBigImageViewController *imageVC = [[THKShowBigImageViewController alloc] init];
    imageVC.image = imageView.contentImageView.image;
    // transition
    THKInteractiveTransition *interactiveTransition = [[THKInteractiveTransition alloc] init];
    [interactiveTransition addGestureWithVC:imageVC];
    THKAnimatorTransition *animatorTransition = [[THKAnimatorTransition alloc] init];
    animatorTransition.interactiveTransition = interactiveTransition;
    animatorTransition.image = imageView.contentImageView.image;
    animatorTransition.imgFrame = imageView.frame;
    fromVC.transitioningDelegate = animatorTransition;
    imageVC.transitioningDelegate = animatorTransition;
    imageVC.transitionAnimator = animatorTransition;
    [fromVC presentViewController:imageVC animated:YES completion:nil];
}



@end