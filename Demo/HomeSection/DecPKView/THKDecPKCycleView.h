//
//  THKDecPkCycleView.h
//  Demo
//
//  Created by Joe.cheng on 2022/12/23.
//

#import <UIKit/UIKit.h>
#import "THKDecPKSrcollCell.h"
NS_ASSUME_NONNULL_BEGIN

@class THKDecPKCycleView;
typedef void (^THKDecPKConfigCycleCell)(THKDecPKSrcollCell *cell, id model);
typedef void (^THKDecPKSelectCycleCell)(THKDecPKSrcollCell *cell, id model);
typedef void (^THKDecPKScrollCycleCell)(THKDecPKCycleView *cycleView, NSInteger index);

@interface THKDecPKCycleView : UIView

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, copy) THKDecPKConfigCycleCell configCell;

@property (nonatomic, copy) THKDecPKSelectCycleCell selectCell;

@property (nonatomic, copy) THKDecPKScrollCycleCell scrollCell;

- (id)objectInDatasAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
