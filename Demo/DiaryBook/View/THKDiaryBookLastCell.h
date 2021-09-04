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

@end

NS_ASSUME_NONNULL_END
