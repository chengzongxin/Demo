//
//  TPushRouter.h
//  Example
//
//  Created by 彭军 on 2019/4/29.
//  Copyright © 2019 to8to. All rights reserved.
//  

#import "TRouter.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, TransitionStyle){
    TransitionStyleNormalPush = 0,//普通跳转,[navigationController pushViewController]
    TransitionStylePresent, //从下往上弹出视图，自带导航栏
    TransitionStylePopOrPushIsExist,//当导航栏中有有跳转的页面时，会自动退回到那一页，否则推入一个新的页面
    TransitionStyleCustom //自定义的跳转
};

@interface TPushRouter : TRouter
@property (nonatomic, strong) NSNumber* transitionStyle;
@end

NS_ASSUME_NONNULL_END
