//
//  UIImage+TCategory.m
//  TBasicLib
//
//  Created by kevin.huang on 14-6-27.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import "UIImage+TCategory.h"

#ifdef DEBUG
#define CGContextInspectContext(context) [UIImage inspectContextIfInvalidatedInDebugMode:context]
#else
#define CGContextInspectContext(context) if(![UIImage inspectContextIfInvalidatedInReleaseMode:context]){return nil;}
#endif

@implementation UIImage (TCategory)

+ (NSString *)fullImgNameWithName:(NSString *)imageName {
    if (![imageName isKindOfClass:[NSString class]] || imageName.length<1) {
        return @"";
    }
    if ([imageName rangeOfString:@"."].length>0) {
        return imageName;
    }
    if (0) {
        if ([[UIScreen mainScreen]respondsToSelector:@selector(scale)] && [[UIScreen mainScreen]scale] == 2) {
            return [NSString stringWithFormat:@"%@@2x.png",imageName];
        }else{
            return [NSString stringWithFormat:@"%@.png",imageName];
        }
    } else {
        NSInteger scale = (NSInteger)[[UIScreen mainScreen]scale];
        if (scale<2) {//iphone端不考虑1x的图片
            scale = 2;
        }
        return [NSString stringWithFormat:@"%@@%@x.png",imageName,@(scale)];
    }
}

+ (UIImage *)imgAtBundleWithName:(NSString *)imageName {
    if (![imageName isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString *imgPath = [[NSBundle mainBundle]pathForResource:[self fullImgNameWithName:imageName] ofType:@""];
    UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
    
    // 使用Images Assets 时候使用imageNamed方法
    if (!img) {
        img = [UIImage imageNamed:imageName];
    }
    
    if (!img && imageName.length>0) {
        if ([[UIScreen mainScreen]scale]>2) {//没有3x图片使用2x图片代替
            imgPath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@@2x.png",imageName] ofType:@""];
            img = [UIImage imageWithContentsOfFile:imgPath];
            return img;
        }
//        THKErrorLog([NSString stringWithFormat:@"no img for imageName:%@ imgPath:%@",imageName,imgPath]);
    }
    return img;
}

//+ (UIImage *)imgAtBundleName:(NSString *)strBundleName fileName:(NSString *)imageName {
//    if (![imageName isKindOfClass:[NSString class]] || imageName.length<1) {
//        return nil;
//    }
//    // [bundle pathForResource:[NSString stringWithFormat:@"%@@2x",imageName] ofType:@"png"];
//    NSString *imgPath = [TCommonAction pathForResourceWithBundleName:strBundleName
//                                                            fileName:[self fullImgNameWithName:imageName]];
//    UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
//    if (!img && imageName.length>0) {
//        if ([[UIScreen mainScreen]scale]>2) {// 没有3x图片使用2x图片代替
//            imgPath = [TCommonAction pathForResourceWithBundleName:strBundleName
//                                                          fileName:[NSString stringWithFormat:@"%@@2x.png",imageName]];
//            img = [UIImage imageWithContentsOfFile:imgPath];
//            return img;
//        }
//        THKErrorLog([NSString stringWithFormat:@"no img for imageName:%@ imgPath:%@",imageName,imgPath]);
//    }
//    return img;
//}

+ (UIImage *)imgAtBundle:(NSBundle *)bundle name:(NSString *)imageName {
    if (![imageName isKindOfClass:[NSString class]] || imageName.length<1) {
        return nil;
    }
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    NSString *imgPath = [bundle pathForResource:[self fullImgNameWithName:imageName] ofType:@""];
    UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
    if (!img && imageName.length>0) {
        if ([[UIScreen mainScreen]scale]>2) {//没有3x图片使用2x图片代替
            imgPath = [bundle pathForResource:[NSString stringWithFormat:@"%@@2x.png",imageName] ofType:@""];
            img = [UIImage imageWithContentsOfFile:imgPath];
            return img;
        }
//        THKErrorLog([NSString stringWithFormat:@"no img for imageName:%@ imgPath:%@",imageName,imgPath]);
    }
    return img;
}

//+ (UIImage *)imgAtBasicLibBundleWithName:(NSString *)imageName {
//    return [self imgAtBundleName:kTBasicLibResourceBundleName fileName:imageName];
//}

+ (UIImage *)imgWithUrlStr:(NSString *)urlStr cachDirectory:(CDirectory)direc {
    return [self imgWithUrlStr:urlStr cachDirectory:direc isSych:NO];
}

//+ (UIImage *)imgWithUrlStr:(NSString *)urlStr cachDirectory:(CDirectory)direc isSych:(BOOL)isSynch {
//    if (kSuffixOfWebpImg) {
//        urlStr = [urlStr stringByAppendingString:kSuffixOfWebpImg];
//    }
//    //urlStr如果不是string类型，会导致kFileNameWithUrlStr方法里的getMd5_32Bit闪退
//    if (![urlStr isKindOfClass:[NSString class]]) {
//        urlStr = [NSString string];
//    }
//    NSString *filename = kFileNameWithUrlStr(urlStr);
//    NSString *filepath = nil;
//    switch (direc) {
//        case CDirectory_doc:
//        {
//            NSAssert(urlStr == nil, @"下载图片暂时不支持CDirectory_doc存储");
//            filepath = kFilePathAtDocumentWithName(filename);
//        }
//            break;
//        default:
//        {
//            YYImageCache *cache = [YYImageCache sharedCache];
//            UIImage *image = [cache getImageForKey:[[YYWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:urlStr]]];
//            return image;
//        }
//            break;
//    }
//    UIImage *img = nil;
//    if (![[NSFileManager defaultManager]fileExistsAtPath:filepath]) {
//        if (isSynch) {
//            NSData *data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:urlStr]];
//            if(data){
//                [data writeToFile:filepath atomically:NO];
//                img = [[UIImage alloc]initWithData:data];
//            }
//            data = nil;
//        } else {
//            return nil;
//        }
//
//
//    } else {
//        NSData *data = [[NSData alloc]initWithContentsOfFile:filepath];
//        img = [[UIImage alloc]initWithData:data];
//        data=nil;
//
//    }
//    return img;
//}

+ (UIImage *)imgFromCachWithUrl:(NSString *)url isSych:(BOOL)isSynch {
    return [self imgWithUrlStr:url cachDirectory:CDirectory_cach isSych:isSynch];
}

+ (UIImage *)imgFromCachWithUrl:(NSString *)url {
    return [self imgWithUrlStr:url cachDirectory:CDirectory_cach isSych:NO];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

// 设置图片透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIColor *)imageWithAverageColor {
    unsigned char rgba[4] = {};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextInspectContext(context);
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    if(rgba[3] > 0) {
        return [UIColor colorWithRed:((CGFloat)rgba[0] / rgba[3])
                               green:((CGFloat)rgba[1] / rgba[3])
                                blue:((CGFloat)rgba[2] / rgba[3])
                               alpha:((CGFloat)rgba[3] / 255.0)];
    } else {
        return [UIColor colorWithRed:((CGFloat)rgba[0]) / 255.0
                               green:((CGFloat)rgba[1]) / 255.0
                                blue:((CGFloat)rgba[2]) / 255.0
                               alpha:((CGFloat)rgba[3]) / 255.0];
    }
}

/// context是否合法
+ (void)inspectContextIfInvalidatedInDebugMode:(CGContextRef)context {
    if (!context) {
        NSAssert(NO, @"CGPostError, %@:%d %s, 非法的context：%@\n%@",
                 [[NSString stringWithUTF8String:__FILE__] lastPathComponent],
                 __LINE__,
                 __PRETTY_FUNCTION__,
                 context,
                 [NSThread callStackSymbols]);
    }
}

+ (BOOL)inspectContextIfInvalidatedInReleaseMode:(CGContextRef)context {
    if (context) {
        return YES;
    }
    return NO;
}

@end
