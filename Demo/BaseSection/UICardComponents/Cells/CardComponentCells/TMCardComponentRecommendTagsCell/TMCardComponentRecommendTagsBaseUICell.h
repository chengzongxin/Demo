//
//  TMCardComponentRecommendTagsBaseUICell.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/9/12.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 因推荐搜索标签样式的卡片，在首页信息流、视频推荐列表、搜索综合列表中均会用到，且分别为不同的接口进行临时的插入逻辑，为了相关数据刷新UI的多样化，这里提供一个纯用于UI展示的基本样式cell
 @note 卡片组件列表里对应的cell及其它地方用到的标签样式，均需要继承此cell，再做一些相关的业务或其它可自定义的封装
 */
@interface TMCardComponentRecommendTagsBaseUICell : UICollectionViewCell

///子类不用管
@property (nonatomic, strong, readonly)UIImageView *backgroundImageView;///< 背景图，预留背景图加载功能，暂时会赋值默认底色。子类不用管 | v8.10 调整UI，此背景图为加载本地图
@property (nonatomic, strong, readonly)UIImageView *searchIconImageView;///< 标题前搜索icon，此类内部初始化时会加载本地对应的icon。子类不用管

@property (nonatomic, strong, readonly)UILabel *titleLabel;///< 标题lbl，子类赋值显示

/// 展示的4块小块视图相关
@property (nonatomic, strong, readonly)NSArray<YYAnimatedImageView *> *tagImgViews;///< 用于展示标签项对应的图片
@property (nonatomic, strong, readonly)NSArray<UILabel *> *tagNameLbls;///< 用于展示标签项对应的标签名串
@property (nonatomic, strong, readonly)NSArray<UIControl *> *tagControls;///< 标签整块视图分别响应点击的四块视图, 按顺序tag分别为0，1，2，3

@property (nonatomic, copy, readonly)NSString *defaultTitleLabelText;///< 默认的标题串 你可能在找

/**
 初始化后可对一些本地固定的UI元素进行一些初始赋值
 @note 子类需要先调用super
 */
- (void)configUIElement NS_REQUIRES_SUPER;

/**
 标签内容整体块视图点击的回调，子类实现具体的点击处理逻辑
 */
- (void)tagControlClick:(UIControl *)tagControl;

/**
 返回此卡片样式在默认瀑布流中显示时对应显示的尺寸。基础类会适配相关尺寸后返回
 */
+ (CGSize)tagsCellLayoutSize;

/**
 返回此卡片样式在某些瀑布流中显示时对应显示的尺寸。基础类会适配相关尺寸后返回
 @note 外部指定卡片显示的宽度，返回一个合适的用于显示的size
 */
+ (CGSize)tagsCellLayoutSizeWithCellWidth:(CGFloat)cellWidth;

@end

NS_ASSUME_NONNULL_END
