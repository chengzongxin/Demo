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
    _imageView = imageViewView;
    
}

+ (void)showBigImageWithImageView:(THKShadowImageView *)imageView transitionStyle:(THKTransitionStyle)transitionStyle{
    NSLog(@"%@",imageView);
    UIViewController *fromVC = (UIViewController *)imageView.nextResponder.nextResponder.nextResponder.nextResponder;
    fromVC.modalPresentationStyle = UIModalPresentationCustom;
    THKShowBigImageViewController *imageVC = [[THKShowBigImageViewController alloc] init];
    imageVC.image = imageView.contentImageView.image;
    // transition
    THKAnimatorTransition *animatorTransition = [[THKAnimatorTransition alloc] init];
    [animatorTransition addGestureWithVC:imageVC direction:THKTransitionGestureDirectionDown];;
    animatorTransition.image = imageView.contentImageView.image;
    animatorTransition.imgFrame = imageView.frame;
    fromVC.transitioningDelegate = animatorTransition;
    fromVC.navigationController.delegate = animatorTransition;
    imageVC.transitioningDelegate = animatorTransition;
//    imageVC.navigationController.delegate = animatorTransition;
    imageVC.transitionAnimator = animatorTransition;
    
    if (transitionStyle == THKTransitionStylePush) {
        [fromVC.navigationController pushViewController:imageVC animated:YES];
    }else{
        [fromVC presentViewController:imageVC animated:YES completion:nil];
    }
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"%s",__func__);
//}

@end
