//
//  THKOnlineDesignSearchAreaHotView.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignSearchAreaHotView : UIView

@property (nonatomic, copy) NSArray <NSString *> *areaList;

@property (nonatomic, copy) void (^tapItem)(NSInteger idx);

@property (nonatomic, copy) void (^clickUploadBlock)(void);

@end

NS_ASSUME_NONNULL_END
