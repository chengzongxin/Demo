//
//  TMCardComponentCellDataProtocol.h
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMCardComponentMacro.h"
#import "TMCardComponentCellStyle.h"
#import "TMCardComponentCellDataBasicProtocol.h"
#import "TMCardComponentCellLayoutDataProtocol.h"
#import "TMCardComponentCellExposeFlagDataProtocol.h"
#import "TMCardComponentDataInfoObjects.h"
#import "TSearchContentHighlightKeyWordsDefine.h"

NS_ASSUME_NONNULL_BEGIN

///!!!: 相关服从协议的对象在.m的implementation下方添加此宏，即可快速完成相关协议属性对象的synthesize操作 xx = _xx,不需要外部再一个个手动去写
#define TMCardComponentCellDataProtocolSyntheSizeAutoImplementation \
TMCardComponentCellDataBasicProtocolSyntheSizeAutoImplementation \
    \
TMCardComponentProtocolSyntheSize(cover) \
TMCardComponentProtocolSyntheSize(bottom) \
TMCardComponentProtocolSyntheSize(content) \
TMCardComponentProtocolSyntheSize(insert) \
TMCardComponentProtocolSyntheSize(interaction) \
TMCardComponentProtocolSyntheSize(reportConfig) \
TMCardComponentProtocolSyntheSize(hideAnimateView) \
TMCardComponentProtocolSyntheSize(report) \
TMCardComponentProtocolSyntheSize(isShow) \
    \
TMCardComponentCellLayoutDataProtocolSyntheSizeAutoImplementation \
    \
TMCardComponentProtocolSyntheSize(reportDicInfo) \
TMCardComponentProtocolLazyLoadImplementation_reportDicInfo \
    \
    \
TMCardComponentProtocolSyntheSize(highlightList)    \
TSearchContentHighlightKeyWordsProperties_Implementation;   \


/// !!!: 搜索高亮时，相关.m文件需要添加以下方法实现以忽略一些归档属性
//+ (NSArray *)mj_ignoredPropertyNames {
//    return @[@"highlightKeyWordColor"];
//}
//+ (NSArray *)mj_ignoredCodingPropertyNames {
//    return @[@"highlightKeyWordColor"];
//}


#define TMCardComponentProtocolLazyLoadImplementation_reportDicInfo \
- (NSDictionary *)reportDicInfo { \
    if (!_reportDicInfo) {\
        _reportDicInfo = reportDictionaryFromReportKeyValueList(self.report); \
    } \
    return _reportDicInfo; \
}   \


/**统一相关内部支持的样式cell对应的dataModel应该遵守的协议族*/
@protocol TMCardComponentCellDataProtocol <TMCardComponentCellDataBasicProtocol, TMCardComponentCellLayoutDataProtocol>

///8.6 搜索模块集成卡片组件后需要支持搜索词高亮的相关处理---搜索高亮词相关属性及方法定义
TSearchContentHighlightKeyWordsProperties_Interface;

///MARK: 相关定义的数据结构对象
//@property(nonatomic, assign)TMCardComponentCellStyle style; 此属性定义在TMCardComponentCellDataBasicProtocol协议中
@property(nonatomic, strong)TMCardComponentDataCoverInfo *cover;
@property(nonatomic, strong)TMCardComponentDataBottomInfo *bottom;
@property(nonatomic, strong)TMCardComponentDataContentInfo *content;
@property(nonatomic, strong)TMCardComponentDataInteractionInfo *interaction;

/** 推荐插入的标签数据项卡片需要的数据对象
 @version 8.9 增加
 @note 为保证旧版本其它接口的相关逻辑,这里定义的对象直接复用之前其它接口定义的相关结构即可
 */
@property(nonatomic, strong)TMCardComponentDataInsertRecommendTagsInfo *insert;

/** 非天眼上报，需要单独调用相关接口进行上报操作
 @version 8.8 增加
 @note 为方便后续可能的特殊上报逻辑，8.8版本ios app端暂按通用的上报处理逻辑设计
 */
@property (nonatomic, strong)TMCardComponentDataReportConfig *reportConfig;

/**是否隐藏直播卡片右下角动效，默认NO不隐藏。
 * @note v8.10 直播卡片样式调整，去除原卡片右下角的动效，故此属性值被弃用
 */
@property(nonatomic, assign)BOOL hideAnimateView __deprecated_msg("v8.10 直播UI样式改版，废弃此属性值");

/**
 相关埋点上报的业务数据，具体内容不同返回的值不同
 @note 数组结构为 [{key:xx, value:xxx}, {key:xx, value:xxx}, ...] ,  app端需要通过key\value解析转成对应天眼需要的字典才能用
 */
@property (nonatomic, strong, nullable)NSArray<NSDictionary<NSString *, id> *> *report;

/** 暂用于视频列表中与8.7版本时isShow字段作用一致，即当 为0时表示此数据在列表中和跳转到的详情页里都显示；当 != 0 时，仅在跳转的视频详情页时中显示，在列表中不显示此条数据UI；默认为0
 8.8 add 同8.7版本里旧的视频对象中的isShow字段
 */
@property (nonatomic, assign)NSInteger isShow;

/**
 从report列表数据中解析并重新组装的可以用于在数据上报里透传的数据字典
 @note 此属性只读，相关具体实现逻辑已经封装到相关宏代码，且会被包含在  TMCardComponentCellDataProtocolSyntheSizeAutoImplementation 的宏实现中
 @note 若外部使用了TMCardComponentCellDataProtocolSyntheSizeAutoImplementation宏则不需要重写getter方法，若外部未用到此宏则需要自行进行相关解析拼装，
 @note 若要自定义实现则相关辅助方法可用 reportDictionaryFromReportKeyValueList(reportList)
 */
@property (nonatomic, strong, readonly, nullable)NSDictionary *reportDicInfo;


#pragma mark - TMCardComponentCellLayoutDataProtocol 用于相关卡片组件cell展示时子内容UI的布局，以下属性赋值外部可忽略，内部有tool工具类会在合适的时候统一调用处理赋值, 【custom的样式除外】

@end

/**辅助方法*/
NS_INLINE NSDictionary *reportDictionaryFromReportKeyValueList(NSArray<NSDictionary<NSString *, id> *> *kvList) {
    if (kvList.count == 0) {return nil;}
        
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [kvList enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = obj[@"key"];
        id value = obj[@"value"];
        if (key && value) {
            dic[key] = value;
        }
    }];
    return dic.count > 0 ? dic : nil;
};


NS_ASSUME_NONNULL_END
