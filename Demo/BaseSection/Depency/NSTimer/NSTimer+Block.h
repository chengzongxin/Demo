//
//  NSTimer+Block.h
//  HouseKeeper
//
//  Created by 荀青锋 on 2019/6/24.
//  Copyright © 2019 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Block)

/** 创建一个timer并将其加到当前currentRunloop里且mode设置为传入的mode值 */
+ (NSTimer *)thk_timerWithTimeInterval:(NSTimeInterval)interval
                                 block:(void(^)(void))block
                               repeats:(BOOL)repeats
                                  mode:(NSRunLoopMode)mode;

+ (NSTimer *)thk_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)(void))block
                                        repeats:(BOOL)repeats;

+ (dispatch_source_t)thk_dispatchTimerWithTarget:(id)target
                                    timeInterval:(NSTimeInterval)timeInterval
                                           block:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
