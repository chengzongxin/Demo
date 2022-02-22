//
//  THKMaterialHotListResponse.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/23.
//

#import "THKMaterialHotListResponse.h"

@implementation THKMaterialHotListResponse

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data":THKMaterialHotListModel.class};
}

@end


@implementation THKMaterialHotListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"brandList":THKMaterialHotBrandModel.class};
}

@end

@implementation THKMaterialHotBrandModel


@end
