//
//  THKStateMechanismsViewModel.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/24.
//

#import "THKViewModel.h"
#import "THKRequestCommand.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    THKLoadingStatus_Loading,
    THKLoadingStatus_Finish,
} THKLoadingStatus;

typedef enum : NSUInteger {
    THKRefreshStatus_EndRefreshing,
    THKRefreshStatus_ResetNoMoreData,
    THKRefreshStatus_NoMoreData,
} THKRefreshStatus;

typedef NSArray *_Nullable(^AppendDataBlock)(THKResponse *);

@interface THKStateMechanismsViewModel : THKViewModel

@property (nonatomic, strong, readonly) THKRequestCommand *requestCommand;
/// 数据源
@property (nonatomic, readonly, nullable) NSArray *data;

- (void)bindWithView:(UIView *)view scrollView:(UIScrollView *)scrollView appenBlock:(NSArray * (^)(THKResponse *))appendBlock;


/// 子类重写
- (THKBaseRequest *)requestWithInput:(id)input;

@end

NS_ASSUME_NONNULL_END
