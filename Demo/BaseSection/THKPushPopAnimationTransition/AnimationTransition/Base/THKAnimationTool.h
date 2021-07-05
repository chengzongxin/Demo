//
//  THKAnimationTool.h
//  HouseKeeper
//
//  Created by ben.gan on 2021/4/10.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FrameBlock)(CGRect rect);

NS_ASSUME_NONNULL_BEGIN

@interface THKAnimationTool : NSObject

/**
 检测cell是否在屏幕中，否则滑动到屏幕中
 @param indexPath indexPath
 @param collectionView collectionView
 @param topOffset 距离上的偏移
 @param bottomOffset 距离下的偏移
 @param delayFrame 延迟返回的frame
 @return 返回相对于屏幕的frame
 */
+ (CGRect)checkCellAndScrollToScreen:(NSIndexPath *)indexPath
                      collectionView:(UICollectionView *)collectionView
                           topOffset:(CGFloat)topOffset
                        bottomOffset:(CGFloat)bottomOffset
                          delayFrame:(FrameBlock)delayFrame;

+ (CGRect)checkCellAndScrollToScreen:(NSIndexPath *)indexPath
                      collectionView:(UICollectionView *)collectionView;

@end

NS_ASSUME_NONNULL_END
