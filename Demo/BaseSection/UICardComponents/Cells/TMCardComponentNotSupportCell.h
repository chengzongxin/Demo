//
//  TMCardComponentNotSupportCell.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/8/18.
//  Copyright © 2020 binxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMCardComponentCellProtocol.h"
#import "TMCardComponentCellDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN
/**
 8.8 add 做类型向后的兼容，当出现当前版本不支持的style时，展示此提示升级的cell
 */
@interface TMCardComponentNotSupportCell : UICollectionViewCell<TMCardComponentCellProtocol>

- (void)updateUIElement:(NSObject<TMCardComponentCellDataProtocol> *)data;

@end

NS_ASSUME_NONNULL_END
