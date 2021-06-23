//
//  THKMaterialHotRankVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/23.
//

#import "THKMaterialHotRankVM.h"
#import "THKMaterialHotListRequest.h"

@interface THKMaterialHotRankVM ()

@property (nonatomic, strong) THKRequestCommand *requestCommand;

@end

@implementation THKMaterialHotRankVM

- (void)initialize{
    [self.requestCommand.nextSignal subscribeNext:^(id  _Nullable x) {
        
    }];
    
    [self.requestCommand.errorSignal subscribeNext:^(id  _Nullable x) {
            
    }];
    
    [self.requestCommand execute:nil];
}

- (THKRequestCommand *)requestCommand{
    if (!_requestCommand) {
        _requestCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            return [[THKMaterialHotListRequest alloc] init];
        }];
    }
    return _requestCommand;
}

@end
