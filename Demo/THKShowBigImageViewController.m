//
//  THKShowBigImageViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/12/14.
//

#import "THKShowBigImageViewController.h"
#import "THKShadowImageView.h"
#import "THKTransitionAnimator.h"
@interface THKShowBigImageViewController ()

@property (nonatomic, strong) UIImageView *imageView;


//@property (nonatomic, weak) UIViewController *preVC;

@property (nonatomic, strong) THKTransitionAnimator *transitionAnimator;

//@property (nonatomic, assign) CGFloat percent;

@end

@implementation THKShowBigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blackColor;
}


+ (void)showBigImageWithImageView:(THKShadowImageView *)imageView{
    NSLog(@"%@",imageView);
    UIViewController *fromVC = (UIViewController *)imageView.nextResponder.nextResponder.nextResponder.nextResponder;
    fromVC.modalPresentationStyle = UIModalPresentationCustom;
    THKShowBigImageViewController *imageVC = [[THKShowBigImageViewController alloc] init];
    // transition
    THKInteractiveTransition *interactiveTransition = [[THKInteractiveTransition alloc] init];
    [interactiveTransition addGestureWithVC:imageVC];
    THKTransitionAnimator *transitionAnimator = [[THKTransitionAnimator alloc] init];
    transitionAnimator.interactiveTransition = interactiveTransition;
    transitionAnimator.image = imageView.contentImageView.image;
    transitionAnimator.imgFrame = imageView.frame;
    fromVC.transitioningDelegate = transitionAnimator;
    imageVC.transitioningDelegate = transitionAnimator;
    [fromVC presentViewController:imageVC animated:YES completion:nil];
    imageVC.transitionAnimator = transitionAnimator;
    
    UIImageView *imageViewView = [[UIImageView alloc] initWithFrame:imageVC.view.bounds];
    imageViewView.image = imageView.contentImageView.image;
    imageViewView.contentMode = UIViewContentModeScaleAspectFit;
    [imageVC.view addSubview:imageViewView];
}



@end
