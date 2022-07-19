//
//  THKNavigationTitleProtocol.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2022/6/7.
//  Copyright © 2022 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol THKNavigationTitleProtocol <NSObject>

#pragma mark - 快捷设置标题
/// 设置后会自动创建简单titleLabel
@property (nonatomic, strong) NSString *thk_title;
/// 设置后会自动创建简单titleLabel
@property (nonatomic, strong) NSAttributedString *thk_attrTitle;
/// 设置左按钮文字
@property (nonatomic, strong) NSString *thk_leftTitle;
/// 设置左按钮富文本
@property (nonatomic, strong) NSAttributedString *thk_attrLeftTitle;
/// 设置右按钮富文字
@property (nonatomic, strong) NSString *thk_rightTitle;
/// 设置右按钮富文本
@property (nonatomic, strong) NSAttributedString *thk_attrRightTitle;

#pragma mark - 快捷设置左右按钮禁用状态
/// 快捷添加左边返回Button是否禁用，采用禁用默认颜色
- (void)thk_setBackItemEnable:(BOOL)isEnable;
/// 快捷添加左边返回Button是否禁用，禁用颜色
- (void)thk_setBackItemEnable:(BOOL)isEnable diaEnableColor:(UIColor *)disEnableColor;
/// 快捷添加左边返回Button是否禁用，采用禁用默认颜色
- (void)thk_setRightItemEnable:(BOOL)isEnable;
/// 快捷添加左边返回Button是否禁用，禁用颜色
- (void)thk_setRightItemEnable:(BOOL)isEnable diaEnableColor:(UIColor *)disEnableColor;
/// 快捷添加Button是否禁用，采用禁用默认颜色
- (void)thk_setButtonItem:(UIButton *)btn enable:(BOOL)isEnable diaEnableColor:(UIColor *)disEnableColor;

#pragma mark - 快捷设置左右按钮文字或者图片
/// 快捷添加左边返回Button Item方法
- (void)thk_setBackButtonItemTitle:(NSString *)title target:(id)target action:(SEL)selector;
/// 快捷添加右边Button Item方法
- (void)thk_setRightButtonItemTitle:(NSString *)title target:(id)target action:(SEL)selector;
/// 快捷添加左边返回Button Item方法
- (void)thk_setBackButtonItemImage:(UIImage *)image target:(id)target action:(SEL)selector;
/// 快捷添加右边Button Item方法
- (void)thk_setRightButtonItemImage:(UIImage *)image target:(id)target action:(SEL)selector;
/// 快捷添加左边返回Button Item方法
- (void)thk_setBackButtonItemTitle:(NSString *)title Image:(UIImage *)image target:(id)target action:(SEL)selector;
/// 快捷添加右边Button Item方法
- (void)thk_setRightButtonItemTitle:(NSString *)title Image:(UIImage *)image target:(id)target action:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
