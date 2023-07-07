//
//  THKReferenPictureListVM.m
//  Demo
//
//  Created by Joe.cheng on 2023/7/5.
//

#import "THKReferenPictureListVM.h"
#import "THKReferenPictureListRequest.h"

@implementation THKReferenPictureListVM

- (THKBaseRequest *)requestWithInput:(NSNumber *)input {
    THKReferenPictureListRequest *request = [[THKReferenPictureListRequest alloc] init];
    request.page = input.integerValue;
    request.size = 100;
    return request;
}

- (NSArray *)appendData:(THKReferenPictureListResponse *)response {
    return response.data;
}

@end
