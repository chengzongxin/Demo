//
//  TMCardComponentCellDataModel.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/4/9.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentCellDataModel.h"
//#import "TInsteractiveNotification.h"

@implementation TMCardComponentCellDataModel

TMCardComponentCellDataProtocolSyntheSizeAutoImplementation;

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"layout_cellSize",
             @"layout_coverShowHeight",
             @"layout_bottomViewHeight",
             @"layout_titleBoxViewHeight",
             @"layout_subTitleBoxViewHeight",
             @"highlightKeyWordColor",];
}

+ (NSArray *)mj_ignoredCodingPropertyNames {
    return @[@"highlightKeyWordColor"];
}

- (TMCardComponentDataReportConfig *)reportConfig {
#warning 8.8 npp add | 由于当前还没有接口支持，app端处理逻辑暂可写在此处
    [self configReportConfigIfNeed];
    //
    return _reportConfig;
}

- (void)configReportConfigIfNeed {
    if (self.style == TMCardComponentCellStyleVideoSets) {
        if (!_reportConfig) {
            _reportConfig = [[TMCardComponentDataReportConfig alloc] init];
            _reportConfig.reportActions = TMCardComponentDataReportActionsExpose;
            _reportConfig.exposeReportUrl =  [NSString stringWithFormat:@"%@%@/eas/video/topicHasBeenExposed", kJavaServerDomain, kJavaServerPath];
            //参数需要从路由中取,
            NSString *code = nil;
            NSString *routerStr = self.content.router;
            TRouter *router = [TRouter routerFromUrl:routerStr jumpController:nil];
            code = [router.param safeStringForKey:@"code"];
            if (code.length > 0) {
                _reportConfig.reportData = @{@"code": code};
            }else {
                _reportConfig.reportActions = TMCardComponentDataReportActionsNone;
            }
        }
    }
}

#pragma mark - 8.8 add针对互动数据的同步问题，效果图、视频点击到详情页滑动查看并互动，会造成详情页交互状态及数据与列表中的相关数据不一致(若列表中的数据已经在当前展示cell中则对应cell内部的互动处理会同步相关数据，但已加载但未展示到当前cell的数据则不会进行同步)

- (void)setInteraction:(TMCardComponentDataInteractionInfo *)interaction {
    _interaction = interaction;
    
    //增加互动数据同步的通知
    if (interaction &&
        interaction.type == TMCardComponentDataInteractionInfoTypePraise &&
        interaction.moduleCode.length > 0) {
        [self addInteractionStatusDataUpdateNotice];
    }
}

- (void)addInteractionStatusDataUpdateNotice {
//    @weakify(self);
//    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"TInsteractiveEventNotification" object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(NSNotification * _Nullable notification) {
//        @strongify(self);
//        TInsteractiveNotification *noti = (TInsteractiveNotification *)(notification.object);
//        NSString *moduleCode = noti.moduleCode;
//        NSInteger objId = noti.objId;
//        if (self.interaction.type == TMCardComponentDataInteractionInfoTypePraise &&
//            [self.interaction.moduleCode isEqualToString:moduleCode] &&
//            [self.content.Id integerValue] == objId) {
//            TInsteractiveNotificationEvent event = noti.notificationEvent;
//            TInsteractiveNotificationResult result = noti.notificationResult;
//            if (event == TInsteractiveNotificationEvent_Praise) {//点赞刷新
//                BOOL isPraise = noti.isPraise;
//                if (result == TInsteractiveNotificationResult_Success) {
//                    self.interaction.status = isPraise;
//                    //具体点赞数因可能cell的互动回调里已作了处理，所以这里干脆不做加减操作，仅确保点赞状态同步，并尽量保持点赞数的有效
//                    if (isPraise && self.interaction.num == 0) {
//                        //点赞成功应至少保持点赞数为1
//                        self.interaction.num = 1;
//                    }
//                }
//            }
//        }
//    }];
}

@end
