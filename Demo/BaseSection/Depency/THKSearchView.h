//
//  THKSearchView.h
//  HouseKeeper
//
//  Created by 荀青锋 on 2019/11/12.
//  Copyright © 2019 binxun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKSearchView : UIControl

@property (nonatomic, strong, readonly) UIImageView *searchIcon;
@property (nonatomic, strong, readonly) UILabel *searchLabel;



/// 首页样式的搜索view
+(instancetype)searchViewWithHomeStyle;

@end

NS_ASSUME_NONNULL_END
