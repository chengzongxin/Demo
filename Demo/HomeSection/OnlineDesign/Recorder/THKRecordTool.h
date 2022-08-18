//
//  THKRecordTool.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import <UIKit/UIKit.h>

@class THKAudioDescription;

typedef void(^recordFinishBlock)(THKAudioDescription * _Nullable audioDesc);

@interface THKAudioDescription : NSObject

@property (nonatomic, strong) NSString *filePath;

@property (nonatomic, assign) NSUInteger duration;

@end

NS_ASSUME_NONNULL_BEGIN

@interface THKRecordTool : NSObject
SHARED_INSTANCE_FOR_HEADER;

@property (nonatomic, copy) recordFinishBlock recordFinish;

- (void)startRecord:(NSString *)fileName;

- (void)stopRecord;

- (BOOL)deleteRecording;

- (void)play:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
