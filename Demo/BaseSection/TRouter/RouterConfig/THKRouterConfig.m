//
//  THKRouterConfig.m
//  HouseKeeper
//
//  Created by 彭军 on 2019/5/23.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKRouterConfig.h"
#import "THKCustomRouter.h"
#import "THKBackPushRouter.h"
#import "THKRouterPathDefine.h"
@implementation THKRouterConfig
- (BOOL)isNeedLogin:(nonnull TRouter *)router {
    //TODO:这里处理哪些路由页面需要登录成功后才能跳转进入的
    if ([router routerMatch:THKRouterPage_MyHomeMain]
        || [router routerMatch:THKRouterPage_OldHomeMain]
        || [router routerMatch:THKRouterPage_NewhomeQualityrecord]
        || [router routerMatch:THKRouterPage_DiaryDispatch]
        || [router routerMatch:THKRouterPage_EditTransparent]
        || [router routerMatch:THKRouterPage_IntegralTask]
        || [router routerMatch:THKRouterPage_MyWallet]
        || [router routerMatch:THKRouterPage_ContractList]
        || [router routerMatch:THKRouterPage_TopicMsgList]
        || [router routerMatch:THKRouterPage_DesignerServiceEdit]
        || [router routerMatch:THKRouterPage_fanweStoreAuth]
        || [router routerMatch:THKRouterPage_fanweLiveAuth]
        || [router routerMatch:THKRouterPage_fanweOrderDetail]
        || [router routerMatch:THKRouterPage_DiaryWrite]
        || [router routerMatch:THKRouterPage_DiaryBookWrite]
        || [router routerMatch:THKRouterPage_PersonProfile]){
        
        return YES;
    }
    return NO;
}


/**
如果不是push或者需要需要自定义处理跳转的则在此处理

 @param routeName <#routeName description#>
 @return <#return value description#>
 */
- (nonnull Class)routeSubClassForRouteName:(nonnull NSString *)routeName {
    
    if ([routeName isEqualToString:THKRouterPage_AppMainTab]
        ||[routeName isEqualToString:THKRouterPage_IndexPublish]
        ||[routeName isEqualToString:THKRouterPage_IMChat]
        ||[routeName isEqualToString:THKRouterPage_DiaryDispatch]
        ||[routeName isEqualToString:THKRouterPage_EditTransparent]
        ||[routeName isEqualToString:THKRouterPage_Command]
        ||[routeName isEqualToString:THKRouterPage_ExpertChat]
        ||[routeName isEqualToString:THKRouterPage_AskAddAnswer]
        ||[routeName isEqualToString:THKRouterPage_fanweLiveRoom]
        ||[routeName isEqualToString:THKRouterPage_fanweStoreAuth]
        ||[routeName isEqualToString:THKRouterPage_DiaryWrite]
        ||[routeName isEqualToString:THKRouterPage_DiaryBookWrite]
        ||[routeName isEqualToString:THKRouterPage_LivePreviewDetail]
        ||[routeName isEqualToString:THKRouterPage_openWechatMini]
        ) {
        return [THKCustomRouter class];
    }else if([routeName isEqualToString:THKRouterPage_VideoDetail]){
        return [THKBackPushRouter class];
    }
    else{
        return [TPushRouter class];
    }
}
@end
