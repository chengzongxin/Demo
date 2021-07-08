//
//  GEClickProcessor.h
//  Pods
//
//  Created by jerry.jiang on 2018/12/27.
//

#import "GEProcessor.h"

NS_ASSUME_NONNULL_BEGIN

@interface GEWidgetProcessor : GEProcessor

+ (instancetype)defaultProcessor;

- (void)reportClickEvent:(NSDictionary *)event;

- (void)reportExposeEvent:(NSDictionary *)event;

- (void)reportCustomEvent:(NSString *)eventName property:(NSDictionary *)property;

@end

NS_ASSUME_NONNULL_END
