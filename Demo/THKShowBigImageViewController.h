//
//  THKShowBigImageViewController.h
//  Demo
//
//  Created by Joe.cheng on 2020/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKShowBigImageViewController : UIViewController

+ (void)showBigImageWithImageView:(UIImageView *)imageView;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) CGRect imgFrame;

@end

NS_ASSUME_NONNULL_END
