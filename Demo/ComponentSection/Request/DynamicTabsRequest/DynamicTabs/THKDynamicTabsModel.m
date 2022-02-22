//
//  THKDynamicTabsModel.m
//  HouseKeeper
//
//  Created by amby.qin on 2020/7/10.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKDynamicTabsModel.h"


//DynamicTabsWholeCodeString const kDynamicTabsWholeCodeHomePage = @"7!710!71001!01"; //首页 | 9.5.0 之前的版本用到此值
DynamicTabsWholeCodeString const kDynamicTabsWholeCodeHomePage = @"7!710!71001!22";///< 首页获取标签要传的全码 | 9.5.0 调整
DynamicTabsWholeCodeString const kDynamicTabsWholeCodeCaseList = @"7!710!71001!02"; //案例列表
DynamicTabsWholeCodeString const kDynamicTabsWholeCodeVedioList = @"7!710!71001!15"; //视频列表
DynamicTabsWholeCodeString const kDynamicTabsWholeCodeCommunity = @"7!710!71001!16"; //社区
DynamicTabsWholeCodeString const kDynamicTabsWholeCodeMinePage = @"7!710!71001!26"; //我的
DynamicTabsWholeCodeString const kDynamicTabsWholeCodeLivePage = @"7!710!71001!17"; //直播

DynamicTabsWholeCodeString const kDynamicTabsWholeCodeCompanyDetail = @"dcs!appshopdetail!811"; //装企详情页

/**
 本地自定义的全码，如果接口不需要传全码，为了保持本地逻辑一致性，定义了我们本地自己使用的全码，以9开头，在调用request时要传对应的wholeCode，主要是用于区分调哪个request
 */
DynamicTabsWholeCodeString const kDynamicTabsWholeCodeLocalDiaryChannel = @"7!710!71001!20";//日记频道

@implementation THKDynamicTabsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"tabId":@"id"};
}

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"THKDynamicTabDisplayModel"];
}

@end

@implementation THKDynamicTabDisplayModel

@end

@implementation THKDynamicTabsHomeImageModel

@end
