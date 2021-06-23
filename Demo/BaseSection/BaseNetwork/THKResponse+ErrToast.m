//
//  THKResponse+ErrToast.m
//  AFNetworking-iOS10.0
//
//  Created by nigel.ning on 2020/9/7.
//

#import "THKResponse+ErrToast.h"
#import "THKCommonResponse.h"

@implementation THKResponse (ErrToast)

+ (void)toastIfNeedWithFailResponse:(__kindof THKResponse *_Nullable)resp error:(NSError *_Nullable)error {
    if (error) {
        [TMToast toast:@"网络出问题了，请检查网络连接"];
    }else {
        NSString *tipMsg = @"请求失败，请稍后重试";
        if (resp.errorMsg.length > 0) {
            tipMsg = resp.errorMsg;
        }else if ([resp isKindOfClass:[THKCommonResponse class]]) {
            THKCommonResponse *commonResp = (THKCommonResponse *)resp;
            if ([commonResp.data isKindOfClass:[NSString class]] && [commonResp.data length] > 0) {
                tipMsg = commonResp.data;
            }
        }else if ([resp respondsToSelector:@selector(data)]) {
            id data = [(id)resp data];
            if ([data isKindOfClass:[NSString class]] && [data length] > 0) {
                //提示语兼容data本身为字符串的逻辑
                tipMsg = data;
            }else if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *errMsg = data[@"failReason"];
                if (errMsg &&
                    [errMsg isKindOfClass:[NSString class]] &&
                    errMsg.length > 0) {
                    //提示语兼容data[@"failReason"]为字符串的逻辑
                    tipMsg = errMsg;
                }
            }
        }
        [TMToast toast:tipMsg];
    }
}

@end
