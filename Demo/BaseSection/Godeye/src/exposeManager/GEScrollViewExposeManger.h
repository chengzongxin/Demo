//
//  GEScrollViewExposeManger.h
//  THKMyTestApp
//
//  Created by amby.qin on 2020/12/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GEScrollViewExposeManger : NSObject

/**
 计算列表的可见cell是否符合曝光条件
 */
+ (void)calculateVisbleCellsWithScrollView:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
