//
//  THKRequestCommand.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/5/24.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "RACCommand.h"
#import "THKBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    THKLoadingStatus_Loading,
    THKLoadingStatus_Finish,
} THKLoadingStatus;

typedef void(^cmdMake)(id input,id<RACSubscriber>  _Nonnull subscriber);
typedef THKBaseRequest *(^cmdRequestMake)(id input);

@interface THKRequestCommand : RACCommand


/**
 * 创建cmd，内部会自动关联成功信号和失败信号,在execute后，关注cmd的next和error回调，适用于不关注input的情况
    
 * Block arguments:
    1) input: 执行execute传入的参数
    2) subscriber: 内部订阅者，需要在外部请求完成后，主动调用订阅者的next，error，complete（否则无法进行下一次操作）
 
 * Usages:
     @weakify(self);
     [THKRequestCommand commandMake:^(id  _Nonnull input, id<RACSubscriber>  _Nonnull subscriber) {
         @strongify(self);
         RACTupleUnpack(NSIndexPath *indexPath,id model) = input; // unpack input if you Passing in multiple parameters
         [request.rac_requestSignal subscribeNext:^(id  _Nullable x) {
             [subscriber sendNext:indexPath];
         } error:^(NSError * _Nullable error) {
             [subscriber sendError:error];
         } completed:^{
             [subscriber sendCompleted];
         }];
     }];
 */
+ (instancetype)commandMake:(cmdMake)make;

/**
 * 创建cmd，内部会自动关联成功信号和失败信号，在execute后，关注cmd的next和error回调
    
 * Block arguments:
    1) cmdRequestMake: 需要执行请求的request，在创建时赋值好参数,在input获取execute参数
 
 * Usages:
 *     [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            THKBaseRequest *request = [[THKBaseRequest alloc] init];
            request.xxx = input;
            return request;
        }];
 *
 */
+ (instancetype)commandMakeWithRequest:(cmdRequestMake)requestMake;

/// 成功信号
@property (nonatomic, strong, readonly) RACSubject *nextSignal;
/// 失败信号
@property (nonatomic, strong, readonly) RACSubject *errorSignal;


@end

NS_ASSUME_NONNULL_END
