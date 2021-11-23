//
//  THKEntranceView.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKView.h"
#import "THKEntranceViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKEntranceView : THKView

@property (nonatomic, strong, readonly) THKEntranceViewModel *viewModel;

@end


@interface THKEntranceView (Godeye)

/// 埋点携带补充字段,默认内部添加曝光和点击埋点（装修公司主页业务），可添加额外字段覆盖已添加字典
@property (nonatomic, strong) NSDictionary *geParas;

- (void)entrancesShowReport:(UIView *)view model:(id)model indexPath:(NSIndexPath *)indexPath;
- (void)entrancesClickReport:(UIView *)view model:(id)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
