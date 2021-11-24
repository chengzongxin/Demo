//
//  THKTableViewCellProtocol.h
//  HouseKeeper
//
//  Created by 荀青锋 on 2019/5/6.
//  Copyright © 2019 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THKTableViewCellProtocol <NSObject>

@optional

// 子视图布局
- (void)thk_setupViews;

// 绑定ViewModel
- (void)bindViewModel;

@end
