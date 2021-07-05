//
//  TMCardComponentCellDataBasicProtocol.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/8/25.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMCardComponentMacro.h"
#import "TMCardComponentCellExposeFlagDataProtocol.h"
#import "TMCardComponentCellStyle.h"

NS_ASSUME_NONNULL_BEGIN

#define TMCardComponentCellDataBasicProtocolSyntheSizeAutoImplementation \
TMCardComponentCellExposeFlagDataProtocolSyntheSizeAutoImplementation   \
TMCardComponentProtocolSyntheSize(style) \
TMCardComponentProtocolSyntheSize(layout_cellSize) \


/** 不管是支持类型的卡片还是自定义的卡片对应的数据结构都需要满足的基础协议
@note 用于确定一个cell的显示样式
@note 用于确定一个cell展示的尺寸
@note 不管是内部支持的卡片还是自定义的卡片，按通用逻辑都会用到暴光，所以将暴光标记的协议作为此基础协议的父协议
*/
@protocol TMCardComponentCellDataBasicProtocol <TMCardComponentCellExposeFlagDataProtocol>

/**确定卡片显示的样式，若为自定义则给custom类型即可，相关自定义cell的注册、填充数据等均需要自行实现*/
@property(nonatomic, assign)TMCardComponentCellStyle style;

/**
 对应显示的cell的size值,当为CGSizeZero时，若为支持的卡片类型则卡片组件列表内部相关逻辑会调用相关方法以懒加载的方式计算相关值并缓存到此属性中，若已赋值则会忽略
 @note 当为自定义卡片样式时，则需要外部自动合适的值
 */
@property (nonatomic, assign)CGSize layout_cellSize;

@end

NS_ASSUME_NONNULL_END
