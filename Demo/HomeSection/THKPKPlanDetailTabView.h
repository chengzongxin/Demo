//
//  THKPKPlanDetailTabView.h
//  Demo
//
//  Created by Joe.cheng on 2023/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKPKPlanDetailTabView : UIView

@property (nonatomic, strong) NSArray *data;

- (void)setSelectIdx:(NSInteger)idx;

@property (nonatomic, copy) void (^tapItem)(NSInteger idx);

@end

NS_ASSUME_NONNULL_END
