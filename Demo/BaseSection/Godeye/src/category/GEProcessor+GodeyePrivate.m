//
//  GEProcessor+GodeyePrivate.m
//  Pods
//
//  Created by jerry.jiang on 2019/2/26.
//

#import "GEProcessor+GodeyePrivate.h"
#import "GETrackerModel.h"
#import "GEDispatcher.h"


/**
 为抽象类提供基本的上报接口
 */
@implementation GEProcessor (GodeyePrivate)

+ (instancetype)shareProcessor
{
    static GEProcessor *processor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        processor = [[GEProcessor alloc] init];
    });
    return processor;
}

- (void)reportEvent:(NSString *)event properties:(NSDictionary *)properties
{
    GETrackerModel *tracker = [GETrackerModel trackerWithEvent:event properties:properties];
    [[GEDispatcher defaultDispatcher] reportTracker:tracker];
}


@end
