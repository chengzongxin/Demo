//
//  GEProcessor+GodeyePrivate.h
//  Pods
//
//  Created by jerry.jiang on 2019/2/26.
//

#import "GEProcessor.h"

@interface GEProcessor (GodeyePrivate)

+ (instancetype)shareProcessor;

- (void)reportEvent:(NSString *)event properties:(NSDictionary *)properties;


@end

