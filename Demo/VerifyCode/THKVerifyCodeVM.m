//
//  THKVerifyCodeVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/16.
//

#import "THKVerifyCodeVM.h"

@interface THKVerifyCodeVM ()

@property (nonatomic, strong) THKRequestCommand *refreshCodeCommand;
@property (nonatomic, strong) THKRequestCommand *commitCommand;
@end

@implementation THKVerifyCodeVM

- (THKRequestCommand *)refreshCodeCommand{
    if (!_refreshCodeCommand) {
        _refreshCodeCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            return [THKPicCaptchaRequest new];
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
            request.platform = self.platform;
            return request;
        }];
    }
    return _commitCommand;
}

@end
