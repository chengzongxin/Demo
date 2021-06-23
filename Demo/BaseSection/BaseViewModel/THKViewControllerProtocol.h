//
//  THKViewControllerProtocol.h
//  HouseKeeper
//
//  Created by 荀青锋 on 2019/5/6.
//  Copyright © 2019 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

//骨架视图样式-加载中显示的UI样式
typedef NS_ENUM(NSInteger, TLoadingFrameViewStyle){
    TLoadingFrameViewStyleNone = 0,//无
    TLoadingFrameViewStyleDiaryBook ,//日记本详情
    TLoadingFrameViewStyleDiary, //子日记详情
    TLoadingFrameViewStyleCase, //案例详情
};

@protocol THKViewModelProtocol;

@protocol THKViewControllerProtocol <NSObject>

@optional


// 初始化
- (void)thk_initialize;

// 子视图布局
- (void)thk_addSubviews;

// 设置导航栏
- (void)thk_layoutNavigation;

//加载过程中展示的骨架屏view
- (void)thk_addLoadingFrameView;

//移除骨架屏
- (void)thk_removeLoadingFrameView;

//骨架屏的样式
- (TLoadingFrameViewStyle)thk_loadingFrameViewStyle;

///设置页面额外参数【场景：push到下个页面时用到】
- (void)setPageExtraDic:(NSDictionary *)dic;

///获取页面额外参数【场景：push到下个页面时用到】
- (NSDictionary *)getPageExtraDic;
@end
