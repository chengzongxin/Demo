//
//  GEStorage.h
//  AFNetworking
//
//  Created by jerry.jiang on 2018/12/25.
//

#import <Foundation/Foundation.h>
#import "GETrackerModel.h"

@interface GEStorage : NSObject

+ (void)putData:(NSArray <GETrackerModel *> *)data;

+ (NSArray <GETrackerModel *> *)getData;

+ (void)removeData:(NSArray <GETrackerModel *> *)data;

@end

