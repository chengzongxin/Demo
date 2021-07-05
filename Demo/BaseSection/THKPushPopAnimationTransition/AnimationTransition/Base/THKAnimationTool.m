//
//  THKAnimationTool.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/4/10.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKAnimationTool.h"

@implementation THKAnimationTool

+ (CGRect)checkCellAndScrollToScreen:(NSIndexPath *)indexPath
                      collectionView:(UICollectionView *)collectionView
                           topOffset:(CGFloat)topOffset
                        bottomOffset:(CGFloat)bottomOffset
                          delayFrame:(FrameBlock)delayFrame {
    CGRect viewRect = [collectionView convertRect:collectionView.bounds toView:TMUI_AppWindow];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    CGRect startRect = [cell.contentView convertRect:cell.contentView.bounds toView:TMUI_AppWindow];
    CGFloat top = viewRect.origin.y;
    CGFloat bottom = viewRect.origin.y + viewRect.size.height;

    if (!CGRectEqualToRect(CGRectZero, startRect)) {
        if ((startRect.origin.y + topOffset) < top) {
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        } else if (startRect.origin.y + startRect.size.height > bottom + bottomOffset) {
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        } else {
            return startRect;
        }
    } else {
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }
    CGRect endRect = [cell.contentView convertRect:cell.contentView.bounds toView:TMUI_AppWindow];
    if (delayFrame) {
        dispatch_after(0.3, dispatch_get_main_queue(), ^{
            delayFrame([cell.contentView convertRect:cell.contentView.bounds toView:TMUI_AppWindow]);
        });
    }
    return endRect;
}

+ (CGRect)checkCellAndScrollToScreen:(NSIndexPath *)indexPath
                      collectionView:(UICollectionView *)collectionView {
    return [self checkCellAndScrollToScreen:indexPath collectionView:collectionView topOffset:0 bottomOffset:0 delayFrame:nil];
}

@end
