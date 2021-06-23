//
//  THKCommonRequestExtensionDefine.h
//  HouseKeeper
//
//  Created by nigel.ning on 2019/11/27.
//  Copyright © 2019 binxun. All rights reserved.
//

#ifndef THKCommonRequestExtensionDefine_h
#define THKCommonRequestExtensionDefine_h

#import "THKResponse.h"
#import "THKCommonResponse.h"

///MARK: 定义一些跟网络请求相关，上层业务可能会通用的一些宏定义、或inline函数、或其它回调block等
#pragma mark -
/**
 定义回调参数为 THKResponse 类型对象的回调
 */
typedef void (^THKResponseBlock)(__kindof THKResponse *resp);

/**
 定义回调参数为 THKCommonResponse类型对象的回调
 */
typedef void (^THKCommonResponseBlock)(__kindof THKCommonResponse *commonResp);


#endif /* THKCommonRequestExtensionDefine_h */
