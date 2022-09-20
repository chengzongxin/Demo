//
//  THKOnlineDesignHomeConfigModel.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKOnlineDesignHomeConfigModel.h"


@implementation THKOnlineDesignHomeConfigColumnOptionList

@end

@implementation THKOnlineDesignHomeConfigColumnList
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"optionList":THKOnlineDesignHomeConfigColumnOptionList.class};
}

@end

@implementation THKOnlineDesignHomeConfigModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"columnList":THKOnlineDesignHomeConfigColumnList.class};
}

@end
