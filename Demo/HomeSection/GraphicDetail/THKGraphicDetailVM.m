//
//  THKGraphicDetailVM.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import "THKGraphicDetailVM.h"
#import "THKMeituDetailv2Request.h"

@interface THKGraphicDetailVM ()

@property (nonatomic, strong) THKRequestCommand *requestCommand;

@end

@implementation THKGraphicDetailVM


- (THKRequestCommand *)requestCommand{
    if (!_requestCommand) {
        _requestCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            THKMeituDetailv2Request *request = [THKMeituDetailv2Request new];
            request.baseId = [input integerValue];
            return request;
        }];
    }
    return _requestCommand;
}

@end
