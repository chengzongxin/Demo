//
//  GECommonEventTracker.m
//  Pods
//
//  Created by jerry.jiang on 2019/2/26.
//

#import "GECommonEventTracker.h"
#import "GEProcessor+GodeyePrivate.h"

@implementation GECommonEventTracker

+ (void)reportEvent:(NSString *)eventName properties:(NSDictionary *)properties
{
    [[GEProcessor shareProcessor] reportEvent:eventName properties:properties];
}

@end
