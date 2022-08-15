//
//  THKOnlineDesignAudioView.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignAudioView : UIView

@property (nonatomic, assign) NSInteger timeInterval;

@property (nonatomic, copy) void (^clickPlayBlock)(UIView *,NSUInteger idx);

@property (nonatomic, copy) void (^clickCloseBlock)(UIButton *,NSUInteger idx);

@end

NS_ASSUME_NONNULL_END
