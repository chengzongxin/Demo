//
//  THKMaterialRecommendRankVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialRecommendRankVM.h"

@interface THKMaterialRecommendRankVM ()

@property (nonatomic, strong) THKRequestCommand *requestCommand;

@property (nonatomic, strong, nullable) NSArray <THKMaterialHotListModel *> *data;

@end

@implementation THKMaterialRecommendRankVM
@dynamic requestCommand;
@dynamic data;

- (THKBaseRequest *)requestWithInput:(id)input{
    return [[THKMaterialHotListRequest alloc] init];
}

@end
