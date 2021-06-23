//
//  THKIdentityModel.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/2/3.
//

#import "THKIdentityTypeModel.h"
#import <MJExtension.h>
#import "NSData+Common.h"



@implementation THKDomainConfigModel
@end
@implementation THKIdentityTypeModel

-(NSDictionary*)getDecryptedData{
    if (self.data.length > 0) {
        NSData *decryptedData = [NSData thk_AES128DecryptWithText:self.data];
        if (decryptedData) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:decryptedData options:NSJSONReadingAllowFragments error:nil];
            if (json.count >= 1) {
                return json;
            }
        }
    }
    return nil;
}

//MJExtensionCodingImplementation

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"identify":THKIdentityTypeModelIdentify.class};
}



+ (instancetype)modelDefault{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"V_Identity_Config.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return [THKIdentityTypeModel mj_objectWithKeyValues:json[@"data"]];
}


@end


@implementation THKIdentityTypeModelIdentify
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"subCategory":THKIdentityTypeModelSubCategory.class};
}



//+ (NSArray *)modelArray{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"V标识配置接口.json" ofType:nil];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSDictionary *json =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    return [THKIdentityTypeModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"identify"]];
//}

@end

@implementation THKIdentityTypeModelSubCategory
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"textData":THKIdentityTypeModelSubCategoryTextData.class};
}
@end

@implementation THKIdentityTypeModelSubCategoryTextData

@end
