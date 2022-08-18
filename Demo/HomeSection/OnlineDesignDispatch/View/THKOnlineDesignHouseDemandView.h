//
//  THKOnlineDesignHouseDemandView.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import <UIKit/UIKit.h>
#import "THKRecordTool.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignHouseDemandView : UIStackView

@property (nonatomic, strong) NSArray <THKAudioDescription *>*demands;

@property (nonatomic, copy) void (^clickPlayBlock)(UIView *,NSUInteger idx);

@property (nonatomic, copy) void (^clickCloseBlock)(UIButton *,NSUInteger idx);

@end

NS_ASSUME_NONNULL_END
