//
//  THKPicCaptchaRequest.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/16.
//

#import "THKBaseRequest.h"
@class THKPicCaptchaModel;
NS_ASSUME_NONNULL_BEGIN

@interface THKPicCaptchaRequest : THKBaseRequest

/// 验证码类型:1四位随机 2六位随机 3算术运算
@property (nonatomic, assign) NSInteger type;

@end

@interface THKPicCaptchaResponse : THKResponse

@property (nonatomic, strong) THKPicCaptchaModel *data;

@end

@interface THKPicCaptchaModel : NSObject

@property (nonatomic, strong) NSString *img;

@property (nonatomic, strong) NSString *verifyKey;

@end

NS_ASSUME_NONNULL_END
