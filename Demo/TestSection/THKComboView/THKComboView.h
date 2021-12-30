//
//  THKComboView.h
//  Demo
//
//  Created by Joe.cheng on 2021/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKComboView : UIView

@property (nonatomic ,assign) NSInteger number;/**< 初始化数字 */
@property (nonatomic ,assign) NSInteger maxNumber;/**< 最大数字 默认9999 */

// 开始连击
- (void)combo;


@end

NS_ASSUME_NONNULL_END
