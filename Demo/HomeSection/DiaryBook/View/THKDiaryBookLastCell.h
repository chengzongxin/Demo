//
//  THKDiaryBookLastCell.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/27.
//

#import <UIKit/UIKit.h>
#import "THKDiaryBookCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDiaryBookLastCell : UITableViewCell

@property (nonatomic, strong, readonly) RACSubject *urgeUpdateSubject;

@property (nonatomic, copy) void (^animationStartBlock)(void);

@property (nonatomic, assign) CGPoint animateStartPoint;
@property (nonatomic, assign) CGPoint animateEndPoint;

@end

NS_ASSUME_NONNULL_END
