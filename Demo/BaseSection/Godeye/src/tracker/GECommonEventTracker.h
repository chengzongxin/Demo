//
//  GECommonEventTracker.h
//  Pods
//
//  Created by jerry.jiang on 2019/2/26.
//

#import "GEProcessor.h"


@interface GECommonEventTracker : GEProcessor

+ (void)reportEvent:(NSString *)eventName properties:(NSDictionary *)properties;

@end

