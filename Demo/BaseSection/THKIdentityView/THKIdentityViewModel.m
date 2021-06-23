//
//  THKIdentityConfiguration.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/2/3.
//

#import "THKIdentityViewModel.h"
#import "THKIdentityConfigManager.h"

@interface THKIdentityViewModel ()
/// 标识点击信号
//@property (nonatomic, strong, readwrite) RACSubject *onTapSubject;
/// 抓取配置是否成功
@property (nonatomic, assign, readwrite) BOOL fetchConfigSuccess;

@property(nonatomic, strong) THKIdentityTypeModel *model;

@end

@implementation THKIdentityViewModel
@dynamic model;

- (void)initialize{
    self.font = UIFont(12);
    self.iconSize = CGSizeMake(16, 16);
    self.style = THKIdentityStyle_Icon;
    self.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 0);
    self.imageTextSpace = 4;
//    self.onTapSubject = RACSubject.subject;
}

+ (instancetype)viewModelWithType:(NSInteger)type subType:(NSInteger)subType style:(THKIdentityStyle)style{
    return [[self alloc] initWithType:type subType:subType style:style];
}

- (instancetype)initWithType:(NSInteger)type subType:(NSInteger)subType style:(THKIdentityStyle)style{
    self = [super init]; // 调用 initialize
    if (!self) return nil;
    
    _type = type;
    _subType = subType;
    _style = style;
    
    // 配置自身属性
    [self configSelf];
    
    return self;
}

- (void)configSelf{
    NSInteger type = self.type;
    NSInteger subType = self.subType;
    // 获取配置文件
    THKIdentityTypeModelSubCategory *category = [THKIdentityConfigManager.shareInstane fetchConfigWithType:type subType:subType];
    
    if (category) {
        _fetchConfigSuccess = YES;
        [self configSelfWithModel:category];
    }else{
        _fetchConfigSuccess = NO;
    }
}

- (void)configSelfWithModel:(THKIdentityTypeModelSubCategory *)model{
    self.iconUrl = model.identificationPic;
    self.text = model.textData.identificationDesc;
    self.font = [UIFont systemFontOfSize:model.textData.fontSize];
    self.backgroundColor = [UIColor colorWithHexString:model.textData.backgroundColor];
    self.textColor = [UIColor colorWithHexString:model.textData.textColor];
    self.iconSize = CGSizeMake(model.iconWidth, model.iconHeight);
    self.iconLocal = [self iconImg:self.type subType:self.subType];
}


- (UIImage *)iconImg:(NSInteger)type subType:(NSInteger)subType{
    switch (type) {
        case 6:
        case 11:
            return subType ? [UIImage imageNamed:@"icon_identity_orange"] : [UIImage imageNamed:@"icon_identity_green"];
        case 10:
            return [UIImage imageNamed:@"icon_identity_orange"];
        case 12:
            return [UIImage imageNamed:@"icon_identity_yellow"];
        case 13:
            return [UIImage imageNamed:@"icon_identity_yellow"];
        case 14:
            return [UIImage imageNamed:@"icon_identity_yellow"];
        default:
            break;
    }
    return nil;
}



- (void)setType:(NSInteger)type{
    _type = type;
    
    [self configSelf];
}

- (void)setSubType:(NSInteger)subType{
    _subType = subType;
    
    [self configSelf];
}

@end
