//
//  TMCardComponentBaseAbstractCell.h
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMCardComponentCellProtocol.h"
#import "TMCardComponentCellDataProtocol.h"
#import <Masonry/Masonry.h>
#import "TMCardComponentMacro.h"
#import "TMCardComponentUIConfigDefine.h"
#import "TMCardComponentTool.h"
//#import <Lottie/Lottie.h>
#import <YYAnimatedImageView.h>

//当前所有样式卡片都用到的公共底部视图
#import "TMCardComponentCellBottomView.h"

//封面图支持动图，这里对支持动图的YYAnimatedImageView取个别名，方便若以后此类被替换后可以很快替换类名
typedef YYAnimatedImageView TMCardComponentBaseAbstractCellCoverImageView;

NS_ASSUME_NONNULL_BEGIN

/**卡片组件的抽象基类，封装一部分相同处理逻辑，并规范部分共用扩展接口
 @warning 此类不直接使用，应该继承后使用
 @note v8.10 调整UI样式，卡片整体视图四周圆角统一半径为6pt, 单纯封面视图底部圆角统一半径为2pt (因封面图在卡片内位置，可直接设置封面图圆角为2即可)
 */
@interface TMCardComponentBaseAbstractCell : UICollectionViewCell<TMCardComponentCellProtocol>

@property (nonatomic, strong, readonly)NSObject<TMCardComponentCellDataProtocol> *data;

/**统一的图片视图
 基类会初始化并指定相关初始约束，初始约束时高度指定为0
 */
@property (nonatomic, strong, readonly) TMCardComponentBaseAbstractCellCoverImageView *coverImgView;

/**统一的底部视图
 基类会初始化并指定相关初始约束，初始约束时高度指定为0
 */
@property (nonatomic, strong, readonly)TMCardComponentCellBottomView *bottomView;

/**加载子元素视图，需要子类重写
 @warning 子类需要先调用super实现，super实现内部会先添加coverImgView、bottomView并赋值其显示的初始约束值
 */
- (void)loadSubUIElement NS_REQUIRES_SUPER;

/** 封面图上视图上方覆盖的蒙层视图，尺寸与封面视图相同, 此返回蒙层视图显示时对应的背景颜色
 @note 默认为nil，即效果上看不出来有蒙层，子类可根据实际需要指定封面图上的蒙层颜色
 @note 子类重写
 */
- (UIColor *_Nullable)coverImgViewMaskLayerViewColor;

/** 若有需要可调用此方法更新当前显示的封面视图上的蒙层视图的颜色，具体颜色可由 coverImgViewMaskLayerViewColor 方法返回即可
 @note 子类调用
 */
- (void)updateCoverImgViewMaskLayerViewColor;

/** 以下方法需要子类重写实现
 @warning 子类应该先调用super实现，super实现内部会根据data统一更新调整coverImgView、bottomView的显示高度
 */
- (void)updateUIElement:(NSObject<TMCardComponentCellDataProtocol> *)data NS_REQUIRES_SUPER;

#if DEBUG
/// 移除长按事件
/// @param vcClass 控制器类
-(void)removeCellLongPressGestureWithVcClass:(Class)vcClass;
#endif
@end

NS_ASSUME_NONNULL_END
