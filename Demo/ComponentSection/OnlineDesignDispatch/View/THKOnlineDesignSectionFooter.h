//
//  THKOnlineDesignSectionFooter.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignSectionFooter : UICollectionReusableView

@property (nonatomic, copy) void (^commitClickBlock)(UIButton *btn);

@end

NS_ASSUME_NONNULL_END
