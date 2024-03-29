//
//  THKOnlineDesignSectionHeader.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignSectionHeader : UICollectionReusableView

@property (nonatomic, strong, readonly) UILabel *numLbl;

@property (nonatomic, strong, readonly) UILabel *titleLbl;

@property (nonatomic, copy, nullable) NSString *selectString;

@property (nonatomic, copy) void (^editBlock)(UIButton *btn);

@end

NS_ASSUME_NONNULL_END
