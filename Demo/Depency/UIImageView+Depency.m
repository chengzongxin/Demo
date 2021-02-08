//
//  UIImageView+Depency.m
//  Demo
//
//  Created by Joe.cheng on 2021/2/8.
//

#import "UIImageView+Depency.h"
#import <YYKit.h>
@implementation UIImageView (Depency)

- (void)loadImageWithUrlStr:(NSString *)urlStr placeHolderImage:(UIImage *)img_holder{
    [self setImageWithURL:[NSURL URLWithString:urlStr] placeholder:img_holder];
}
@end
