//
//  THKSelectMaterialCommunicationVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/24.
//

#import "THKSelectMaterialCommunicationVM.h"

@interface THKSelectMaterialCommunicationVM ()


@property (nonatomic, strong) THKRequestCommand *labelRequest;

@end

@implementation THKSelectMaterialCommunicationVM

- (THKBaseRequest *)requestWithInput:(NSNumber *)input{
    THKMaterialV3CommunicateListRequest *request = [[THKMaterialV3CommunicateListRequest alloc] init];
    request.page = input.integerValue;
    request.categoryId = self.categoryId;
    request.wholeCode = self.wholeCode;
    return request;
}


- (THKRequestCommand *)labelRequest{
    if (!_labelRequest) {
        _labelRequest = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            THKMaterialV3CommunicateLabelRequest *request = [[THKMaterialV3CommunicateLabelRequest alloc] init];
            request.categoryId = self.categoryId;
            return request;
        }];
    }
    return _labelRequest;
}


@end
