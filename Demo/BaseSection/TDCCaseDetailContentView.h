//
//  TDCCaseDetailContentView.h
//  HouseKeeper
//
//  Created by jerry.jiang on 16/10/25.
//  Copyright © 2016年 binxun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TDCCaseDetailContentView;

@protocol TDCCaseDetailViewDelegate <NSObject>

- (void)caseDetailContentViewIsScrollerToTop:(TDCCaseDetailContentView *)contentView;

@end

@interface TDCCaseDetailContentView : UIScrollView

@property (nonatomic, weak) id<UIScrollViewDelegate> t_delegate;

@property (nonatomic, assign) CGFloat lockArea;

- (void)scrollToTop:(BOOL)animated;

@property (nonatomic, weak) id<TDCCaseDetailViewDelegate> otherDelegate;

@end
