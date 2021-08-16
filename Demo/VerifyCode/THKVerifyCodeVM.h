//
//  THKVerifyCodeVM.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/16.
//

#import "THKViewModel.h"
#import "THKRequestCommand.h"
#import "THKPicCaptchaRequest.h"
#import "THKVerifyCodeRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKVerifyCodeVM : THKViewModel

#pragma mark - 接口参数
/// 页面来源, 1-APP网店预约 2-APP登录/注册 3-APP添加银行卡 4-APP修改支付密码 5-APP修改手机号  6-APP修改密码 7-APP(PC)注销账号 8-APP绑定手机号 9-APP签约页面  10-敏感登录 11-PC 注册 12-PC绑定新手机号  （初始化传入）
@property (nonatomic, assign) NSInteger source;
/// 唯一标识对象，获取图形验证码时接口返回的key标识，用于图形码校验
@property (nonatomic, strong) NSString *verifyKey;
/// 用户输入的图形验证码
@property (nonatomic, strong) NSString *imgCode;
/// 手机号的加密串  （初始化传入）
@property (nonatomic, strong) NSString *phone;
/// 手机号id  （初始化传入）
@property (nonatomic, strong) NSString *phoneId;
/// 用户ip
@property (nonatomic, strong) NSString *ip;
/// 平台，1：app 2：小程序 3：pc 4：h5
@property (nonatomic, strong) NSString *platform;

#pragma mark - 请求接口

/// 刷新验证码
@property (nonatomic, strong, readonly) THKRequestCommand *refreshCodeCommand;
/// 提交验证码
@property (nonatomic, strong, readonly) THKRequestCommand *commitCommand;

@end

NS_ASSUME_NONNULL_END
