//
//  TMCardComponentCellDataModel.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/4/9.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMCardComponentCellDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 可直接使用的cellData数据对象
 @note 外部若支持直接创建相关cellData数据对象，可选择直接使用此model进行数据转换，也可选择自行实现TMCardComponentCellDataProtocol协议，若继承此类再进行更多的扩展
 */
@interface TMCardComponentCellDataModel : NSObject<TMCardComponentCellDataProtocol>

@end

NS_ASSUME_NONNULL_END
