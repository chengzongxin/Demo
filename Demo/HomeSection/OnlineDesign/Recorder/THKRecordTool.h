//
//  THKRecordTool.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import <UIKit/UIKit.h>

typedef void(^recordFinishBlock)(NSString * _Nullable filePath);

NS_ASSUME_NONNULL_BEGIN

@interface THKRecordTool : NSObject
SHARED_INSTANCE_FOR_HEADER;

@property (nonatomic, copy) recordFinishBlock recordFinish;

- (void)startRecord:(NSString *)fileName;

- (void)stopRecord;

- (void)play:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
