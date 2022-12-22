//
//  THKDecPKCompanyModel.m
//  Demo
//
//  Created by Joe.cheng on 2022/12/22.
//

#import "THKDecPKCompanyModel.h"

@implementation THKDecPKCompanyModel

@end

@implementation THKDecPKModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"companyInfoList":[THKDecPKCompanyModel class]};
}
@end
