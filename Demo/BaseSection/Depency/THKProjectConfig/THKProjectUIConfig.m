//
//  THKProjectUIConfig.m
//  HouseKeeper
//
//  Created by collen.zhang on 2020/12/9.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKProjectUIConfig.h"

@implementation THKProjectUIConfig

///导航栏标题字体
+(UIFont *)navigationBarTitleFont{
    return [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
}

///导航栏标题字体 - 黑色
+(UIColor *)navigationBarTitleColor_black{
    return THKColor_333333;
}

///导航栏标题字体 - 白色
+(UIColor *)navigationBarTitleColor_white{
    return THKColor_FFFFFF;
}

///返回图片 - 黑色
+(UIImage *)backImage_black{
    return kImgAtBundle(@"nav_back_black");
}

///返回图片 - 白色
+(UIImage *)backImage_white{
    return kImgAtBundle(@"nav_back_white");
}
@end
