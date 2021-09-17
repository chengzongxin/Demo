//
//  THKOSSTool.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/9/17.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OSSToolUploadSuccess)(NSArray <NSString *> * _Nullable urls);
typedef void(^OSSToolUploadFail)(NSError * _Nullable error);

typedef enum : NSUInteger {
    THKOSSModuleType_Diary,
    THKOSSModuleType_UGC,
    THKOSSModuleType_Ask,
    THKOSSModuleType_Personal,
    THKOSSModuleType_GONGDI_PIC
} THKOSSModuleType;

NS_ASSUME_NONNULL_BEGIN

@interface THKOSSTool : NSObject

+ (void)uploadImage:(NSArray <UIImage *> *)images type:(THKOSSModuleType)type success:(OSSToolUploadSuccess)success fail:(OSSToolUploadFail)fail;

@end

NS_ASSUME_NONNULL_END
