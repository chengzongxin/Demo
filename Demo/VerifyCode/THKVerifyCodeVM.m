//
//  THKVerifyCodeVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/16.
//

#import "THKVerifyCodeVM.h"

@interface THKVerifyCodeVM ()
/// 唯一标识对象，获取图形验证码时接口返回的key标识，用于图形码校验
@property (nonatomic, strong) NSString *verifyKey;
/// 用户输入的图形验证码
@property (nonatomic, strong) NSString *imgCode;

@property (nonatomic, strong) THKRequestCommand *refreshCodeCommand;
@property (nonatomic, strong) THKRequestCommand *commitCommand;
@property (nonatomic, strong) RACSubject *imageSubject;
@end

@implementation THKVerifyCodeVM

- (THKRequestCommand *)refreshCodeCommand{
    if (!_refreshCodeCommand) {
        _refreshCodeCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            return [THKPicCaptchaRequest new];
        }];
        
        @weakify(self);
        [_refreshCodeCommand.nextSignal subscribeNext:^(THKPicCaptchaResponse *x) {
            NSLog(@"%@",x);
            @strongify(self);
            // verifyKey
            self.verifyKey = x.data.verifyKey;
            // img
            NSString *base64Str = [x.data.img stringByReplacingOccurrencesOfString:@"data:image/jpg;base64," withString:@""];
            NSData *base64Data = [NSData dataWithBase64EncodedString:base64Str];
            UIImage *img = [UIImage imageWithData:base64Data];
            // update UI
            [self.imageSubject sendNext:img];

        }];
    }
    return _refreshCodeCommand;
}

- (THKRequestCommand *)commitCommand{
    if (!_commitCommand) {
        @weakify(self);
        _commitCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            @strongify(self);
            THKVerifyCodeRequest *request = [[THKVerifyCodeRequest alloc] init];
            request.source = 2;
            request.imgUuid = self.verifyKey;
            request.imgCode = self.imgCode;
            // 17611111120
            request.phone = @"WwogICJBOXJ2KzRqXC9xU0hhN0R3bmVqTDNHVzZHWW5KazdSMUJYNGU0VVwvanFcL3gzVHZxMDdtWHM2SUxTR2NKZDRRaFQxR2U2K3hPaHJjdHdmbGNWNGtFR0pTV2NNSFk2YWx4a05YT0M1QzJja2R6Z1hSdUkyT1cwUlprQlI4eGZsQ2wwbkVLcHhJMTJUXC92OThlTmRMVE1MREFBSFl1RHd3Y2ordU9paGxyYjhqZVwvUT0iCl0=";
            request.phoneId = self.phoneId;
            request.ip = self.ip;
            request.platform = self.platform?:@"1";
            return request;
        }];
    }
    return _commitCommand;
}

TMUI_PropertyLazyLoad(RACSubject, imageSubject);

@end
