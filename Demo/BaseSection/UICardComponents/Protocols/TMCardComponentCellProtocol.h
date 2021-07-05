//
//  TMCardComponentCellProtocol.h
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>

//basic data protocol
#import "TMCardComponentCellDataBasicProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**统一相关cell应该遵守的协议族
 @note 为了规范内部样式卡片组件cell及外部自定义卡片cell的更新UI调用接口统一性，这里参数传递指定为基础协议。具体的传参，可由具体的cell去自行指定合适的类型，但对应的数据都必须服务此基础协议
 */
@protocol TMCardComponentCellProtocol

/**
 用指定的data数据更新相关UI
 */
- (void)updateUIElement:(NSObject<TMCardComponentCellDataBasicProtocol> *)data;


@end

NS_ASSUME_NONNULL_END
