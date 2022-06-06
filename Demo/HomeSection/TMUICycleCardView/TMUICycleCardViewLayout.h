//
//  TMUICycleCardViewLayout.h
//  Demo
//
//  Created by Joe.cheng on 2022/5/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMUICycleCardViewLayout : UICollectionViewLayout
/// 卡片左右之间的距离
@property (nonatomic, assign) CGFloat horSpacing;
/// 卡片底部之间的距离
@property (nonatomic, assign) CGFloat verSpacing;

@property (nonatomic, assign) NSInteger count;

@end

NS_ASSUME_NONNULL_END
