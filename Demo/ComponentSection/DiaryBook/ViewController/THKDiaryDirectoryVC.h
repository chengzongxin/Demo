//
//  THKDiaryDirectoryVC.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/27.
//

#import "THKViewController.h"
#import "THKPageContentViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SideSlipFilterCommitBlock)(NSIndexPath *indexPath);
typedef void (^SideSlipFilterResetBlock)(NSArray *dataList);

static inline CGFloat kDirectionWidth() {
    return TMUI_SCREEN_WIDTH * 0.8;
}

@interface THKDiaryDirectoryVC : TMUIPageViewController

- (instancetype)initWithSponsor:(UIViewController *)sponsor
                     resetBlock:(SideSlipFilterResetBlock)resetBlock
                    commitBlock:(SideSlipFilterCommitBlock)commitBlock;
- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
