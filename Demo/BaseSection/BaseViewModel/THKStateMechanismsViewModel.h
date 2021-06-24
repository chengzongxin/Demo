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

/// VM内部集成刷新控件、空视图、加载状态等控件
/// @param view vc的view
/// @param scrollView 列表控件，tableView或者collectionView
/// @param appendBlock 接口返回需要拼接的数据源
- (void)bindWithView:(UIView *)view scrollView:(UIScrollView *)scrollView appenBlock:(NSArray * (^)(THKResponse *))appendBlock;


/// 子类重写
- (THKBaseRequest *)requestWithInput:(id)input;

/// 添加头部刷新
- (void)addRefreshHeader;
/// 添加尾部刷新
- (void)addRefreshFooter;

@end

NS_ASSUME_NONNULL_END
