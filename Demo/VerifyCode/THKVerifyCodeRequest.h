//
//  THKVerifyCodeRequest.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/16.
//

#import "THKBaseRequest.h"
@class THKVerifyCodeModel;
NS_ASSUME_NONNULL_BEGIN

@interface THKVerifyCodeRequest : THKBaseRequest

/// 页面来源, 1-APP网店预约 2-APP登录/注册 3-APP添加银行卡 4-APP修改支付密码 5-APP修改手机号  6-APP修改密码 7-APP(PC)注销账号 8-APP绑定手机号 9-APP签约页面  10-敏感登录 11-PC 注册 12-PC绑定新手机号
@property (nonatomic, assign) NSInteger source;
/// 唯一标识对象，获取图形验证码时接口返回的key标识，用于图形码校验
@property (nonatomic, strong) NSString *imgUuid;
/// 用户输入的图形验证码
@property (nonatomic, strong) NSString *imgCode;
/// 手机号的加密串
@property (nonatomic, strong) NSString *phone;
/// 手机号id
@property (nonatomic, strong) NSString *phoneId;
/// 用户ip
@property (nonatomic, strong) NSString *ip;
/// 平台，1：app 2：小程序 3：pc 4：h5
@property (nonatomic, strong) NSString *platform;


@end

@interface THKVerifyCodeResponse : THKResponse

@property (nonatomic, strong) THKVerifyCodeModel *data;

@end

@interface THKVerifyCodeModel : NSObject

/// 0 短信校验发送失败! 1 短信校验发送成功! 2 先请求图片验证码! 3 短信ip发送限频! 4 短信phone发送限频! 5 图形验证码校验失败!
@property (nonatomic, assign) NSInteger status;

/// 原因
@property (nonatomic, strong) NSString *result;

@end

NS_ASSUME_NONNULL_END
