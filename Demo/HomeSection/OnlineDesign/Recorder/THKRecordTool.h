//
//  THKRecordTool.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKRecordTool : NSObject
SHARED_INSTANCE_FOR_HEADER;

- (void)startRecord;

- (void)stopRecord;

- (void)play;

@end

NS_ASSUME_NONNULL_END
