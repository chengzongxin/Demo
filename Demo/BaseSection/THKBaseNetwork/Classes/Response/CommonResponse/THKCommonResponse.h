//
//  THKCommonResponse.h
//  HouseKeeper
//
//  Created by nigel.ning on 2019/11/5.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKResponse.h"

NS_ASSUME_NONNULL_BEGIN


/**
 对于有一些旧的业务代码，相关接口回调解析不好拆解的情况下，在尽可能少的修改业务代码的前提下改造接口调用为request模式时，对返回的response数据解析可能需要用到此类。
 */
@interface THKCommonResponse : THKResponse

@property (nonatomic, strong, nullable)id data;///< 接口返回data对应的内容，通常为字典，少数可能为其它，上层业务层可自行判断数据类型并解析处理

@end

NS_ASSUME_NONNULL_END
