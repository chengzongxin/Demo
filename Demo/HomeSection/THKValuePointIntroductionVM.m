//
//  THKValuePointIntroductionVM.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/29.
//

#import "THKValuePointIntroductionVM.h"

@implementation THKValuePointImg

+ (instancetype)createImgWith:(NSString *)imgUrl width:(CGFloat)width height:(CGFloat)height{
    THKValuePointImg *img = [THKValuePointImg new];
    img.imgUrl = imgUrl;
    img.width = width;
    img.height = height;
    return img;
}

@end

@implementation THKValuePointIntroductionVM

@end
