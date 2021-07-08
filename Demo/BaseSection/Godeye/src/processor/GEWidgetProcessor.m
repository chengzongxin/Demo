//
//  GEClickProcessor.m
//  Pods
//
//  Created by jerry.jiang on 2018/12/27.
//

#import "GEWidgetProcessor.h"
#import "GEDispatcher.h"
#import "GEProcessor+GodeyePrivate.h"


@implementation GEWidgetProcessor

+ (instancetype)defaultProcessor
{
    static GEWidgetProcessor *processor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        processor = [[GEWidgetProcessor alloc] init];
    });
    return processor;
}

- (void)reportClickEvent:(NSDictionary *)event
{
    NSParameterAssert(event);
    if (!event) {
        return;
    }
    [self reportEvent:@"appWidgetClick" properties:event];
}

- (void)reportExposeEvent:(NSDictionary *)event
{
    NSParameterAssert(event);
    if (!event) {
        return;
    }
    [self reportEvent:@"appWidgetShow" properties:event];
}

- (void)reportCustomEvent:(NSString *)eventName property:(NSDictionary *)property {
    NSParameterAssert(eventName);
    if (!property || !eventName || eventName.length == 0) {
        return;
    }
    [self reportEvent:eventName properties:property];
}

@end
