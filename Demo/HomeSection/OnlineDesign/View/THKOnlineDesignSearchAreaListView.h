//
//  THKOnlineDesignSearchAreaListView.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignSearchAreaListView : UIView

@property (nonatomic, copy) void (^tapItem)(NSInteger idx);

@end

NS_ASSUME_NONNULL_END
