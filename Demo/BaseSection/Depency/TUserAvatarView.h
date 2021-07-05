//
//  TUserAvatarView.h
//  UIComponentSamples
//
//  Created by nigel.ning on 2019/2/20.
//  Copyright © 2019 t8t. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 土巴兔app中，关于用户头像显示封装的统一视图。使用时外部不会给圆角等其它属性，默认值即可，初始化或后期修改的frame.size即为实际头像展示的size。 (若外部赋值的size的宽高不相等，则内部头像视图展示时会取最小边为实际直径并整体居中显示)
 @note 此控件创建支持纯代码initWithFrame或直接在interface build里指定相关视图类为TUserAvatarView均可。
 @warning 不要仅单独用UINib的加载方式初始化，此类无单独的xib文件。[UINib nibWithNibName:@"TUserAvatarView" bundle:nil] 此调用将在运行时crash。
 @warning 此视图的clipToBounds外部尽量不要修改，内部会在layoutsubviews里重新调整clipToBounds的属性为NO。（因身份标记视图可能会超出此控件的本身显示范围，所以clipToBounds需要为NO）
 */
@interface TUserAvatarView : UIView

/**
 用户头像展示，为圆形裁剪样式。
 @note 内部默认的contentModel为UIViewContentModeScaleAspectFill。
 */
@property (nonatomic, strong, readonly)UIImageView *avatarImgView;

/**
 在用户头像视图在右下方，展示身份标识小视图，默认此视图的中心点位于头像视图的右下位置的圆上。即中心点到头像视图中心点的直线与水平方向夹角成45度。
 @note 内部默认的contentModel为UIViewContentModeScaleToFill。
 */
@property (nonatomic, strong, readonly)UIImageView *identityIconView;

/**
 用户可指定identityIconView的展示尺寸，默认值为{10, 10}
 */
@property (nonatomic, assign)CGSize identityIconSize;

/**
 用户可指定identityIconView展示时中心位置的偏移。默认为{0, 0}
 */
@property (nonatomic, assign)CGPoint identityIconCenterOffset;

/**
 若外部需要处理点击事件，则赋值即可，默认为nil
 @note 只有此block赋为有效值后才会响应点击(内部的相关按钮的可响应状态会根据此值自动设置为disable或enable，此内部按钮UI上无显示效果)
 */
@property (nonatomic, strong)void (^_Nullable onTap)(__kindof TUserAvatarView * aView);

@end

NS_ASSUME_NONNULL_END
