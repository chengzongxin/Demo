//
//  THKOnlineDesignHouseListVM.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import "THKOnlineDesignHouseTypeListVM.h"

@interface THKOnlineDesignHouseTypeListVM ()

//@property (nonatomic, strong) THKRequestCommand *requestCommand;

@end

@implementation THKOnlineDesignHouseTypeListVM

//- (void)initialize{
//    [super initialize];
//
//}
//
//
//- (THKRequestCommand *)requestCommand{
//    if (!_requestCommand) {
//        _requestCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(RACTuple * _Nonnull input) {
//            THKOnlineDesignSearchHouseRequest *request = [THKOnlineDesignSearchHouseRequest new];
//            request.wd = input.first;
//            request.city = [input.second integerValue];
//            return request;
//        }];
//    }
//    return _requestCommand;
//}

- (THKBaseRequest *)requestWithInput:(NSNumber *)input{
    THKOnlineDesignSearchHouseRequest *request = [THKOnlineDesignSearchHouseRequest new];
    request.page = input.integerValue;
    request.wd = self.wd;
    request.city = 1130;
    request.perPage = 10;
    return request;
}

@end
