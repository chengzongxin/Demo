//
//  GESnsTracker.h
//  Pods
//
//  Created by jerry.jiang on 2019/2/26.
//

#import "GEProcessor.h"

typedef NS_ENUM(NSInteger, GESnsEvent) {
    GESnsEventLike,
    GESnsEventCancelLike,
    GESnsEventCollect,
    GESnsEventCancelCollect,
    GESnsEventComment,
    GESnsEventPlayVideo,
};

typedef NS_ENUM(NSInteger, GEShareMethod) {
    GEShareMethodQQ = 1,
    GEShareMethodQzone,
    GEShareMethodWechat,
    GEShareMethodWxTimeline,
    GEShareMethodWeibo,
};

@interface GESnsTracker : GEProcessor

+ (void)reportEventWithType:(GESnsEvent)event properties:(NSDictionary *)properties;

+ (void)reportShareMethod:(GEShareMethod)method properties:(NSDictionary *)properties;

+ (void)reportSharePicMethod:(GEShareMethod)method properties:(NSDictionary *)properties;

@end
