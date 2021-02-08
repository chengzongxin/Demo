//
//  THKIdentityConfiguration.h
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/2/3.
//

#import "THKViewModel.h"
#import "THKIdentityTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, THKIdentityStyle) {
    THKIdentityStyle_Icon = 0, // 只显示icon，默认位于右下角
    THKIdentityStyle_IconText = 1, // 完整显示 eg ：V 认证机构
};

@interface THKIdentityViewModel : THKViewModel

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger subType;
@property (nonatomic, assign) THKIdentityStyle style;



@property (nonatomic, strong) UIImage *iconLocal;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) CGSize iconSize;

@property(nonatomic, assign) UIEdgeInsets imageEdgeInsets;
@property(nonatomic, assign) CGFloat imageTextSpace;


@property (nonatomic, assign) CGPoint iconOffset;
@property(nonatomic, strong) RACSubject *onTapSubject;

@property (nonatomic, assign) BOOL fetchConfigSuccess;

/// 初始化创建标识View
/// @param type V标识类型
/// @param style V标识样式
- (instancetype)initWithType:(NSInteger)type style:(THKIdentityStyle)style;

/// 初始化创建标识View
/// @param type V标识类型
/// @param subType 二级标识分类，有些业务线会一个类型下会对应两个标识，比如11.1设计机构，11.2个人设计师
/// @param style V标识样式
- (instancetype)initWithType:(NSInteger)type subType:(NSInteger)subType style:(THKIdentityStyle)style;



@end

NS_ASSUME_NONNULL_END
