//
//  TMUIExpandLabel.h
//  Demo
//
//  Created by Joe.cheng on 2022/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMUIExpandLabel : UILabel

/**限制最多行数 默认为3 */
@property(nonatomic)NSUInteger maximumLines;
@end

NS_ASSUME_NONNULL_END
