//
//  THKMaterialHotRankVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/23.
//

#import "THKMaterialHotRankVM.h"

@interface THKMaterialHotRankVM ()

@property (nonatomic, strong) THKRequestCommand *requestCommand;

@property (nonatomic, strong, nullable) NSArray <THKMaterialHotListModel *> *data;

@end

@implementation THKMaterialHotRankVM

@dynamic requestCommand;
@dynamic data;

- (THKBaseRequest *)requestWithInput:(id)input{
    return [[THKMaterialHotListRequest alloc] init];
}

@end
