//
//  GELocation.h
//  AFNetworking
//
//  Created by jerry.jiang on 2018/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GELocation : NSObject

+ (void)updateLocation;

+(double)latitude;

+(double)longitude;

@end

NS_ASSUME_NONNULL_END
