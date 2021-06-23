//
//  TSimpleDataObject.m
//  to8to
//
//  Created by kevin.huang on 14-4-23.
//
//

#import "TSimpleDataObject.h"


@implementation TSimpleDataObject

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"_id": @[@"_id", @"id"],
        @"_name": @[@"_name", @"name"],
    };
}

@end
