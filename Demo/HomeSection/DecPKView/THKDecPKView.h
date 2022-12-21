//
//  THKDecPKView.h
//  Demo
//
//  Created by Joe.cheng on 2022/12/21.
//

#import <UIKit/UIKit.h>
#import "THKDecPKViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKDecPKView : UIView

- (void)bindViewModel:(THKDecPKViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
