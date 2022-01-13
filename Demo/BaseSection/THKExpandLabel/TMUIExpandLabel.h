//
//  TMUIExpandLabel.h
//  Demo
//
//  Created by Joe.cheng on 2022/1/7.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TMUIExpandLabelClickActionType_Label,
    TMUIExpandLabelClickActionType_Expand,
    TMUIExpandLabelClickActionType_Shrink,
} TMUIExpandLabelClickActionType;

typedef void(^TMUIExpandLabelClickAction)(TMUIExpandLabelClickActionType clickType);
typedef void(^TMUIExpandLabelSizeChange)(CGSize size);

NS_ASSUME_NONNULL_BEGIN

@interface TMUIExpandLabel : UILabel

/**限制最多行数 默认为3 */
@property(nonatomic)NSUInteger maximumLines;
/// 点击
@property(nonatomic,copy) TMUIExpandLabelClickAction clickActionBlock;
/// 尺寸改变
@property(nonatomic,copy) TMUIExpandLabelSizeChange sizeChangeBlock;

@end

NS_ASSUME_NONNULL_END
