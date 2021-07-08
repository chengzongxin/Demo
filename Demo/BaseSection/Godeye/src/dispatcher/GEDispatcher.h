//
//  GEDispatcher.h
//  AFNetworking
//
//  Created by jerry.jiang on 2018/12/25.
//

#import <Foundation/Foundation.h>
#import "GETrackerModel.h"

#define kBigDataRoomIdKey @"bigdata_room_id"

@protocol GEDispatcherDelegate <NSObject>

- (void)dispatcherReportTrackers:(NSArray <GETrackerModel *> *)trackers success:(BOOL)success;

@end


@interface GEDispatcher : NSObject

@property (nonatomic, weak) id <GEDispatcherDelegate> delegate;

@property (nonatomic, copy) NSString *roomId;

/**
 add by amby.qin
 只要在这个列表中则不需要等待，立即上报
 */
@property (nonatomic, copy) NSArray *immediatelyReportList;

+ (instancetype)defaultDispatcher;

- (void)reportTracker:(GETrackerModel *)tracker;

- (void)connectToRocketCI;

@end

