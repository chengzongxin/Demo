//
//  THKAvatarViewModel.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/2/7.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKAvatarViewModel : THKViewModel
/// 头像URL
@property (nonatomic, strong) NSString *avatarUrl;
/// 头像占位图片
@property (nonatomic, strong) UIImage *placeHolderImage;
/// 标识类型，如果不传则不显示标识
@property (nonatomic, assign) NSInteger identityType;
/// 标识二级类型，没有二级标识类型可不传
@property (nonatomic, assign) NSInteger identitySubType;

/// 用户可指定identityIconView的展示尺寸
@property (nonatomic, assign) CGSize identityIconSize;
/// 用户可指定identityIconView的展示比例，头像和标识默认比例为 <3.6:1>,当不设置identityIconSize才会按照取这个值，如果设置了identityIconSize，这个属性无效
@property (nonatomic, assign) CGFloat identityRatio;
/// 用户可指定identityIconView展示时中心位置的偏移。默认为{0, 0}
@property (nonatomic, assign) CGPoint identityIconCenterOffset;


///MARK: 考虑并不是所有的头像视图都需要处理点击，为了不影响头像视图所属的父级视图的其它点击事件的处理，这里需要对是否需要响应点击触发回调做一些动态开关判断

//@property (nonatomic, assign, readonly)BOOL isTapEnable;///< 点击响应是否可用，默认为NO | avatarView需要监控此属性的改禁用或开启头像视图是否需要响应点击事件的开关
//- (void)makeTapEnable:(BOOL)tapEnable;///< 单独控制是否响应点击事件
//
/////当调用了此接口后，内部会自动将tapEnable设置为YES
///// 点击THKAvatarView的回调设置, 外部使用时需要对tapSignal执行subscribeNext:订阅操作
///// @warning 如果此接口调用多次，则对应的点击事件可能会被回调多次,见RACSubject的用法.
//- (void)makeTapAutoEnableAndSignal:(void(^)(RACSubject *tapSubject))tapSignal;
//
///// 此接口在avatarView响应了点击了调用，来间接触发对应的tapSubject的sendNext回调
///// @note 通常说，这个的x为点击的视图对象 即为UIView或子类型的对象
//- (void)sendNext:(id)x;

/// 创建VM对象
/// @param avatarUrl 头像URL
/// @param identityType 标识类型
/// @param identitySubType 标识二级类型，没有二级标识类型可不传
- (instancetype)initWithAvatarUrl:(NSString *)avatarUrl
                     identityType:(NSInteger)identityType
                  identitySubType:(NSInteger)identitySubType;

/// 创建VM对象
/// @param avatarUrl 头像URL
/// @param placeHolderImage 头像占位图片
/// @param identityType 标识类型
/// @param identitySubType 标识二级类型，没有二级标识类型可不传
- (instancetype)initWithAvatarUrl:(NSString *)avatarUrl
                 placeHolderImage:(nullable UIImage *)placeHolderImage
                     identityType:(NSInteger)identityType
                  identitySubType:(NSInteger)identitySubType;

@end

NS_ASSUME_NONNULL_END
