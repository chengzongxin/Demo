//
//  GESnsTracker.m
//  Pods
//
//  Created by jerry.jiang on 2019/2/26.
//

#import "GESnsTracker.h"
#import "GEProcessor+GodeyePrivate.h"


@implementation GESnsTracker

+ (void)reportEventWithType:(GESnsEvent)event properties:(NSDictionary *)properties
{
    NSString *eventName = nil;
    switch (event) {
        case GESnsEventLike:
            eventName = @"like";
            break;
        case GESnsEventCancelLike:
            eventName = @"cancelLike";
            break;
        case GESnsEventCollect:
            eventName = @"collect";
            break;
        case GESnsEventCancelCollect:
            eventName = @"cancelCollect";
            break;
        case GESnsEventComment:
            eventName = @"comment";
            break;
        case GESnsEventPlayVideo:
            eventName = @"videoPlay";
            break;
    }
    
    NSAssert(eventName, @"Godeye Error: Undefined event name");
    [[GEProcessor shareProcessor] reportEvent:eventName properties:properties];
}

+ (void)reportShareMethod:(GEShareMethod)method properties:(NSDictionary *)properties
{
    NSString *methodString = nil;
    switch (method) {
        case GEShareMethodQQ:
            methodString = @"qq";
            break;
        case GEShareMethodQzone:
            methodString = @"qzone";
            break;
        case GEShareMethodWechat:
            methodString = @"wxMsg";
            break;
        case GEShareMethodWxTimeline:
            methodString = @"wxTimeline";
            break;
        case GEShareMethodWeibo:
            methodString = @"weibo";
            break;
    }
    NSMutableDictionary *prop = [NSMutableDictionary dictionaryWithDictionary:properties];
    if (methodString) {
        prop[@"share_method"] = methodString;
    }
    [[GEProcessor shareProcessor] reportEvent:@"share" properties:prop];
}

+ (void)reportSharePicMethod:(GEShareMethod)method properties:(NSDictionary *)properties
{
    NSString *methodString = nil;
    switch (method) {
        case GEShareMethodQQ:
            methodString = @"qq";
            break;
        case GEShareMethodQzone:
            methodString = @"qzone";
            break;
        case GEShareMethodWechat:
            methodString = @"wxMsg";
            break;
        case GEShareMethodWxTimeline:
            methodString = @"wxTimeline";
            break;
        case GEShareMethodWeibo:
            methodString = @"weibo";
            break;
    }
    NSMutableDictionary *prop = [NSMutableDictionary dictionaryWithDictionary:properties];
    if (methodString) {
        prop[@"share_method"] = methodString;
    }
    [[GEProcessor shareProcessor] reportEvent:@"sharePic" properties:prop];
}

@end
