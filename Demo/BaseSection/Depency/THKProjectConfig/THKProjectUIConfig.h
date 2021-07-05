//
//  THKProjectUIConfig.h
//  HouseKeeper
//
//  Created by collen.zhang on 2020/12/9.
//  Copyright © 2020 binxun. All rights reserved.
//  项目的配置

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKProjectUIConfig : NSObject

///导航栏标题字体
+(UIFont *)navigationBarTitleFont;

///导航栏标题字体 - 黑色
+(UIColor *)navigationBarTitleColor_black;

///导航栏标题字体 - 白色
+(UIColor *)navigationBarTitleColor_white;

///返回图片 - 黑色
+(UIImage *)backImage_black;

///返回图片 - 白色
+(UIImage *)backImage_white;

@end

NS_ASSUME_NONNULL_END
