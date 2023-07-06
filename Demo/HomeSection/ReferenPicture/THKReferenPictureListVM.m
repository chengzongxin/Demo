//
//  THKReferenPictureListVM.m
//  Demo
//
//  Created by Joe.cheng on 2023/7/5.
//

#import "THKReferenPictureListVM.h"
#import "THKReferenPictureListRequest.h"

@implementation THKReferenPictureListVM

- (THKBaseRequest *)requestWithInput:(id)input {
    return [[THKReferenPictureListRequest alloc] init];
}

- (NSArray *)appendData:(THKReferenPictureListResponse *)response {
    return response.data;
}

@end
