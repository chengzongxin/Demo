//
//  THKShowBigImageViewController.h
//  Demo
//
//  Created by Joe.cheng on 2020/12/14.
//

#import <UIKit/UIKit.h>
#import "THKShadowImageView.h"
#import "THKAnimatorTransition.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKShowBigImageViewController : UIViewController

+ (void)showBigImageWithImageView:(THKShadowImageView *)imageView transitionStyle:(THKTransitionStyle)transitionStyle;

@end

NS_ASSUME_NONNULL_END
