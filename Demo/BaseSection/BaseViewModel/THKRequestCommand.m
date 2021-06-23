//
//  THKRequestCommand.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/5/24.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKRequestCommand.h"

@interface  THKRequestCommand ()

@property (nonatomic, strong) RACSubject *nextSignal;

@property (nonatomic, strong) RACSubject *errorSignal;

@end

@implementation THKRequestCommand

+ (instancetype)commandMake:(cmdMake)make{
    THKRequestCommand *cmd = [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            make(input,subscriber);
            return [RACDisposable disposableWithBlock:^{
            }];
        }];
    }];
    
    [cmd.executionSignals.switchToLatest subscribe:cmd.nextSignal];
    
    [cmd.errors subscribe:cmd.errorSignal];
    
    return cmd;
}


+ (instancetype)commandMakeWithRequest:(cmdRequestMake)requestMake{
    THKRequestCommand *cmd = [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            THKBaseRequest *request = requestMake(input);
            [request.rac_requestSignal subscribeNext:^(id  _Nullable x) {
                [subscriber sendNext:x];
            } error:^(NSError * _Nullable error) {
                // 网络问题
                [subscriber sendError:error];
            } completed:^{
                [subscriber sendCompleted];
            }];
            return [RACDisposable disposableWithBlock:^{
                [request cancel];
            }];
        }];
    }];

    [cmd.executionSignals.switchToLatest subscribe:cmd.nextSignal];

    [cmd.errors subscribe:cmd.errorSignal];

    return cmd;
}

- (RACSubject *)nextSignal{
    if (!_nextSignal) {
        _nextSignal = RACSubject.subject;
    }
    return _nextSignal;
}

- (RACSubject *)errorSignal{
    if (!_errorSignal) {
        _errorSignal = RACSubject.subject;
    }
    return _errorSignal;
}

@end
