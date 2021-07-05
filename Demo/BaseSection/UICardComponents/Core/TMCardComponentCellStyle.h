//
//  TMCardComponentCellStyle.h
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#ifndef TMCardComponentCellStyle_h
#define TMCardComponentCellStyle_h

/**卡片组件对应的几种显示样式*/
typedef NS_ENUM(NSInteger, TMCardComponentCellStyle) {
    ///若为自定义的样式，即不在当前支持卡片组件样式内的样式，则本地的相关数据应该赋值为此类型，相关UI样式走外部自定义的处理
    TMCardComponentCellStyleCustom = -1,
    
    ///通用的图文内容样式, 图、标题、描述、底部头像、底部title 、底部点赞或其它、图片上可选指定显示内容标记icon
    TMCardComponentCellStyleNormal = 0,
    
    ///8.6之前旧版回答对应显示的样式，封面图上显示标题、副标题, 底部title 、底部头像。标题最多显示2行、副标题最多显示2行
    TMCardComponentCellStyleTitleAndSubTitle = 1,
    
    ///话题、讨论、提问对应显示的样式, 图、标题、参与者头像列表、描述串、底部title 、底部头像
    ///8.6 对此旧样式进行了拆分，分别对应了单独的话题、提问、回答样式，所以这里命名有调整为oldTopicAndQa
    TMCardComponentCellStyleOldTopicAndQa = 2,
    
    ///装修公司对应显示的样式，图、装修公司头像、装修公司名、描述串、底部title 、底部头像
    TMCardComponentCellStyleCompany = 3,
    
    ///设计大咖对应显示的样式，图、参与者头像列表、描述串、标题、底部title 、底部头像
    TMCardComponentCellStyleDesignMaster = 4,
    
    ///style- 5 后端有用到搜索插入的数据类型---8.9版本 将搜索推荐标签对应的卡片类型定义到卡片组件样式里，但对应的style重新定义为11，相关涉及瀑布流列表或获取数据的接口也对应替换为新接口

    /// 8.5 add 增加-直播样式卡片
    /// 直播或回播的样式，跟normal差不多，但左上角直播状态有Lottie动画效果，底部右下方不支持互动，有观看人数
    TMCardComponentCellStyleLive = 6,
    
    ///8.6 add 增加-新的话题样式、新的标签在标题上方显示的样式(案例、日记用到)、单独的提问及回答样式
    /// 单独的话题样式, 无新增加字段，话题Icon及话题文本复用原bottom的imageUrl和title, 话题名复用cover的title字段，参与话题的描述复用原subTitle字段
    TMCardComponentCellStyleTopic = 7,
    
    /// 标签串显示在标题上方，整体效果与TMCardComponentCellStyleNormal类似，只是标题与子标题上下位置颠倒
    /// 案例及日记会用到
    TMCardComponentCellStyleTitleAndSubTitleUpSideDown = 8,
    
    /// 单独的提问及回答样式，卡片样式分两种效果，根据实际数据确定展示哪种及是否显示相关动画效果
    TMCardComponentCellStyleQa = 9,
    
    /// 8.8 add 增加-新的视频集样式，与style=0类型有点类似，但底部无互组件，且视频集封面有多张图渐变切换效果、视频集封面高宽比为固定1：1效果显示
    TMCardComponentCellStyleVideoSets = 10,
    
    /// 8.9 add 通用的搜索推荐标签样式卡片，暂数据未接入相关瀑布流接口，这里先做类型定义及处理相关UI显示和点击的通用逻辑    
    TMCardComponentCellStyleRecommendTags = 11,
    
    /// 8.8 增加，向后兼容，对超出当前支持的类型提供统一的提示cell
    /// 当前版本不支持的style的最小值，会对应显示一个小的提示升级的cell,卡片组件内部相关显示高度等会自行处理这些不支持的类型
    TMCardComponentCellStyleNotSupport,
};

#define kCardCellStyleNormalIdentifier          @"kCardCellStyleNormalIdentifier"
#define kCardCellStyleTileSubTitleIdentifier    @"kCardCellStyleTileSubTitleIdentifier"
#define kCardCellStyleOldTopicAndQaIdentifier   @"kCardCellStyleOldTopicAndQaIdentifier"
#define kCardCellStyleCompanyIdentifier         @"kCardCellStyleCompanyIdentifier"
#define kCardCellStyleDesignMasterIdentifier    @"kCardCellStyleDesignMasterIdentifier"

//8.5 add
#define kCardCellStyleLiveIdentifier            @"kCardCellStyleLiveIdentifier"

//8.6 add
#define kCardCellStyleTopicIdentifier           @"kCardCellStyleTopicIdentifier"
#define kCardCellStyleQaIdentifier              @"kCardCellStyleQaIdentifier"
#define kCardCellStyleTitleSubTitleUpSideDownIdentifier    @"kCardCellStyleTitleSubTitleUpSideDownIdentifier"

//8.8 add
#define kCardCellStyleVideoSetsIdentifier               @"kCardCellStyleVideoSetsIdentifier"

//8.9 add 搜索推荐标签样式
#define kCardCellStyleRecommendTagsIdentifier           @"kCardCellStyleRecommendTagsIdentifier"

// not support card identifier define
#define kCardCellStyleNotSupportIdentifier              @"kCardCellStyleNotSupportIdentifier"

#endif /* TMCardComponentCellStyle_h */
