//
//  UIImageView+Depency.h
//  Demo
//
//  Created by Joe.cheng on 2021/2/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Depency)
- (void)loadImageWithUrlStr:(NSString *)urlStr
           placeHolderImage:(UIImage *)img_holder;
@end

NS_ASSUME_NONNULL_END
