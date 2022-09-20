//
//  THKHomeQueryCardModel.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKHomeQueryCardModel.h"

@implementation THKHomeQueryCardModelColumnListModel

@end

@implementation THKHomeQueryCardModel

- (instancetype)mj_setKeyValues:(id)keyValues{
    [super mj_setKeyValues:keyValues];
    return self;
}


+ (NSDictionary *)mj_objectClassInArray{
    return @{@"columnList":THKHomeQueryCardModelColumnListModel.class};
}

@end
