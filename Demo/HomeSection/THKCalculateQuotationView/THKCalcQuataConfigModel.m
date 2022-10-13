//
//  THKCalcQuataConfigModel.m
//  Demo
//
//  Created by 程宗鑫 on 2022/10/13.
//

#import "THKCalcQuataConfigModel.h"

@implementation THKCalcQuataConfigHouseBaseListItem
@end

@implementation THKCalcQuataConfigHouseTypeListItem

- (NSString *)houseTypeName{
    return [NSString stringWithFormat:@"%zd室%zd厅%zd厨%zd卫%zd阳台",self.fang,self.ting,self.chu,self.wei,self.yangtai];
}

@end


@implementation THKCalcQuataConfigWeiListItem
@end


@implementation THKCalcQuataConfigTingListItem
@end


@implementation THKCalcQuataConfigYangtaiListItem
@end


@implementation THKCalcQuataConfigFangListItem
@end


@implementation THKCalcQuataConfigChuListItem
@end


@implementation THKCalcQuataConfigTownListItem
@end


@implementation THKCalcQuataConfigCityListItem
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"townList":THKCalcQuataConfigTownListItem.class
    };
}
@end


@implementation THKCalcQuataConfigModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"houseTypeList":THKCalcQuataConfigHouseTypeListItem.class,
             @"weiList":THKCalcQuataConfigWeiListItem.class,
             @"tingList":THKCalcQuataConfigTingListItem.class,
             @"yangtaiList":THKCalcQuataConfigYangtaiListItem.class,
             @"fangList":THKCalcQuataConfigFangListItem.class,
             @"chuList":THKCalcQuataConfigChuListItem.class,
             @"cityList":THKCalcQuataConfigCityListItem.class,
    };
}
@end
