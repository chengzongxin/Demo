//
//  THKUGCDetailPageControlCell.h
//  HouseKeeper
//
//  Created by cl w on 2021/12/11.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKUGCDetailPageControlCell : UICollectionViewCell

- (void)setPhotoNum:(NSInteger)photoNum;

- (void)updateIndex:(NSInteger)idx;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
