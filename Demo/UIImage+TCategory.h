//
//  UIImage+TCategory.h
//  TBasicLib
//
//  Created by kevin.huang on 14-6-27.
//  Copyright (c) 2014年 binxun. All rights reserved.
//  几种常用的获取图片方法

#import <UIKit/UIKit.h>

typedef enum:NSInteger {
    CDirectory_cach = 0,
    CDirectory_doc = 1,
} CDirectory;

@interface UIImage (TCategory)

// 根据imageName获取mainBundle的图片
+ (UIImage *)imgAtBundleWithName:(NSString *)imageName;
// 根据imageName获取名为strBundleName的Bundle里的图片
+ (UIImage *)imgAtBundleName:(NSString *)strBundleName fileName:(NSString *)imageName;
+ (UIImage *)imgAtBundle:(NSBundle *)bundle name:(NSString *)imageName;
// 根据imageName获取名为kTBasicLibResourceBundleName的Bundle里的图片
+ (UIImage *)imgAtBasicLibBundleWithName:(NSString *)imageName;

// 根据url获取图片 有缓存则直接返回，获取完成要进行缓存 缓存在cach目录
+ (UIImage *)imgFromCachWithUrl:(NSString *)url;

+ (UIImage *)imgFromCachWithUrl:(NSString *)url isSych:(BOOL)isSynch;
// 根据url获取图片 有缓存则直接返回，获取完成要进行缓存 direc为缓存目录
+ (UIImage *)imgWithUrlStr:(NSString *)urlStr cachDirectory:(CDirectory)direc;

+ (UIImage *)imgWithUrlStr:(NSString *)urlStr cachDirectory:(CDirectory)direc isSych:(BOOL)isSynch;

/**
 *  根据指定的颜色和大小生成图片
 *
 *  @param color 颜色
 *  @param size  大小
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

// 设置图片透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

/**
 *  获取当前图片的均色，原理是将图片绘制到1px*1px的矩形内，再从当前区域取色，得到图片的均色。
 *  @return 代表图片平均颜色的UIColor对象
 */
- (UIColor *)imageWithAverageColor;

@end

// 本地图片
NS_INLINE UIImage *kImgAtBundle(NSString *imageName) {
    return [UIImage imgAtBundleWithName:imageName];
}
