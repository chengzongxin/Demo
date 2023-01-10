//
//  THKDecorationCompareImageView.h
//  Demo
//
//  Created by Joe.cheng on 2022/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationCompareImageView : UIView

@property (nonatomic, strong) NSArray <NSString *> *imgs;

/// 斜分割线样式，默认右分割线样式 “ \ ”
@property (nonatomic, assign) BOOL isRightSperateStyle;

/// 倾斜角度0-90，默认60
@property (nonatomic, assign) float degree;

/// 中间空白间距，默认8
@property (nonatomic, assign) float space;

@end

NS_ASSUME_NONNULL_END
