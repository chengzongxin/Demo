//
//  THKDiaryCircleView.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/26.
//

typedef enum : NSUInteger {
    THKDiaryCircleType_Section,
    THKDiaryCircleType_Row,
} THKDiaryCircleType;

#import <UIKit/UIKit.h>

UIKIT_EXTERN const CGFloat THKDiaryCircleWidth;


NS_ASSUME_NONNULL_BEGIN

@interface THKDiaryCircleView : UIView
@property (nonatomic, assign) CGSize normalSize;
@property (nonatomic, assign) CGFloat circleWidth; /// 3
@property (nonatomic, assign) CGSize selectedSize;
@property (nonatomic, strong) UIColor *circleColor; /// 22C787
@property (nonatomic, strong) UIColor *lineColor;  /// ECEEEC

@property (nonatomic, assign) THKDiaryCircleType type;

@end

NS_ASSUME_NONNULL_END
