//
//  THKIdentityConfiguration.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/2/3.
//

#import "THKIdentityViewModel.h"
#import "THKIdentityConfigManager.h"

@interface THKIdentityViewModel ()

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
    self.onTapSubject = RACSubject.subject;
}

+ (instancetype)viewModelWithType:(NSInteger)type style:(THKIdentityStyle)style{
    return [[self alloc] initWithType:type subType:0 style:style];
}

+ (instancetype)viewModelWithType:(NSInteger)type subType:(NSInteger)subType style:(THKIdentityStyle)style{
    return [[self alloc] initWithType:type subType:subType style:style];
}

- (instancetype)initWithType:(NSInteger)type style:(THKIdentityStyle)style{
    return [self initWithType:type subType:0 style:style];
}

- (instancetype)initWithType:(NSInteger)type subType:(NSInteger)subType style:(THKIdentityStyle)style{
    self = [super init]; // 调用 initialize
    if (!self) return nil;
    
    self.type = type;
    self.subType = subType;
    self.style = style;
    
//    [self fetchConfigWithType:type subType:subType];
    self.fetchConfigSuccess = [self fetchConfigSuccess];
    
    return self;
}

- (BOOL)fetchConfigSuccess{
    NSInteger type = self.type;
    NSInteger subType = self.subType;
    
    THKIdentityTypeModel *remoteConfig = THKIdentityConfigManager.shareInstane.remoteConfig;
    // 查找远程配置
    _fetchConfigSuccess = [self fetchWithModel:remoteConfig type:type subType:subType];
    if (_fetchConfigSuccess) {
        return _fetchConfigSuccess;
    }
    // 查找本地配置
    THKIdentityTypeModel *localConfig = THKIdentityConfigManager.shareInstane.localConfig;
    if (!localConfig) {
        [THKIdentityConfigManager.shareInstane loadConfig];
        localConfig = THKIdentityConfigManager.shareInstane.localConfig;
    }
    
    _fetchConfigSuccess = [self fetchWithModel:localConfig type:type subType:subType];
    return _fetchConfigSuccess;
}


- (BOOL)fetchWithModel:(THKIdentityTypeModel *)configModel type:(NSInteger)type subType:(NSInteger)subType{

    /// 空数组
    NSArray *models = configModel.identify;
    if (models.count == 0) return NO;
    
    THKIdentityTypeModelSubCategory *model;

    for (THKIdentityTypeModelIdentify *m in models) {
        if (m.identificationType == type) {
            if (subType == 0) {
                model = m.subCategory.firstObject;
            }else{
                if (subType > m.subCategory.count || m.subCategory.count == 0) {
                    break;
                }
                for (THKIdentityTypeModelSubCategory *category in m.subCategory) {
                    if (category.subCategory == subType) {
                        model = category;
                    }
                }
            }
            break;
        }
    }
    // 没找到对应model
    if (!model) {
        return NO;
    }

    // 找到配置model
    self.iconUrl = model.identificationPic;
    self.text = model.textData.identificationDesc;
    self.font = [UIFont systemFontOfSize:model.textData.fontSize];
    self.backgroundColor = [UIColor colorWithHexString:model.textData.backgroundColor];
    self.textColor = [UIColor colorWithHexString:model.textData.textColor];
    self.iconSize = CGSizeMake(model.iconWidth, model.iconHeight);
    self.iconLocal = [self iconImg:type subType:subType];
    return YES;
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
    
    [self fetchConfigSuccess];
}

- (void)setSubType:(NSInteger)subType{
    _subType = subType;
    
    [self fetchConfigSuccess];
}

@end
