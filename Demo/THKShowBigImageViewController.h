//
//  THKShowBigImageViewController.h
//  Demo
//
//  Created by Joe.cheng on 2020/12/14.
//

#import <UIKit/UIKit.h>
#import "THKAnimatorTransition.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKShowBigImageViewController : UIViewController


+ (void)showBigImageWithImageView:(UIImageView *)imageView transitionStyle:(THKTransitionStyle)transitionStyle;

//+ (void)showBigImageWithImageView:(THKShadowImageView *)imageView transitionStyle:(THKTransitionStyle)transitionStyle;

@property (nonatomic, strong) UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
