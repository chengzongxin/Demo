//
//  THKDiaryIndexView.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    THKDiaryIndexPosition_Top,
    THKDiaryIndexPosition_Mid,
    THKDiaryIndexPosition_Bot,
    THKDiaryIndexPosition_Diary,
} THKDiaryIndexPosition;

typedef enum : NSUInteger {
    THKDiaryIndexState_Nor,
    THKDiaryIndexState_Sel,
} THKDiaryIndexState;

@interface THKDiaryIndexView : UIView

@property (nonatomic, assign) THKDiaryIndexPosition position;
@property (nonatomic, assign) THKDiaryIndexState state;

@property (nonatomic, assign) CGSize normalSize;
@property (nonatomic, assign) CGFloat circleWidth; /// 3
@property (nonatomic, assign) CGSize selectedSize;
@property (nonatomic, strong) UIColor *circleColor; /// 22C787
@property (nonatomic, strong) UIColor *lineColor;  /// ECEEEC

@end

NS_ASSUME_NONNULL_END
