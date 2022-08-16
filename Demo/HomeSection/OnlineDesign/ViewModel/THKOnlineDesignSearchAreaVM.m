//
//  THKOnlineDesignSearchAreaVM.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import "THKOnlineDesignSearchAreaVM.h"

@interface THKOnlineDesignSearchAreaVM ()

@property (nonatomic, strong) THKRequestCommand *requestCommand;

@end

@implementation THKOnlineDesignSearchAreaVM
- (void)initialize{
    [super initialize];
    
}

- (THKRequestCommand *)requestCommand{
    if (!_requestCommand) {
        _requestCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(RACTuple * _Nonnull input) {
            THKOnlineDesignSearchAreaRequest *request = [THKOnlineDesignSearchAreaRequest new];
            request.wd = input.first;
            request.city = [input.second integerValue];
            return request;
        }];
    }
    return _requestCommand;
}

@end
