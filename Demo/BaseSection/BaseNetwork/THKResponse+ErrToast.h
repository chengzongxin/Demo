//
//  THKResponse+ErrToast.h
//  AFNetworking-iOS10.0
//
//  Created by nigel.ning on 2020/9/7.
//

#import "THKResponse.h"
#import "TMToast.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKResponse (ErrToast)
/**
 接口调用失败后，可以选择调用此接口进行相关toast提示
 @note 当网络问题是failResponse为nil,error有值；当服务器问题时failResponse有值，error为nil; 当failResponse和error都为nil时，默认提示 请求失败，请稍后重试
 @note failResponse可以为THKCustomResponse对象或其它response对象,若repsonse对象有data属性，当errMsg无值但data有值且为字符串则取data提示
 */
+ (void)toastIfNeedWithFailResponse:(__kindof THKResponse *_Nullable)failResponse error:(NSError *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
