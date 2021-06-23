//
//  THKAuthenticationView.h
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import <UIKit/UIKit.h>
#import "THKView.h"
#import "THKIdentityViewModel.h"
NS_ASSUME_NONNULL_BEGIN


/*
 需求描述：
 1.后端增加一个V标识的配置表，随app初始化接口返回，数据结构包含：logo、文字、字体尺寸、字体颜色、背景颜色等；
 2.封装头像右下角的V标识和带文字的V标识，根据type从配置表中匹配对应的数据并展示，从8.15版本开始，都按此方案做；
 */


/// 使用认证标识组件，返回的数据接口必须包含identificationType，subCategory两个字段，需要在接口model类中遵循协议，然后使用组件
@protocol THKIdentityProtocol <NSObject>
@property (nonatomic, assign) NSInteger identificationType;        ///< 认证类型,1 官方认证 2 个人认证 3 机构认证 4 品牌认证 5 房检官认证 , 6或11 均表示土巴兔设计师认证
@property (nonatomic, assign) NSInteger subCategory;               ///< 认证二级类型
@end

#define THKIdentityProtocolSynthesize \
@synthesize identificationType;\
@synthesize subCategory;

/// 标识View，支持 Masonry，Frame，Xib，懒加载等形式
/// Full样式，按照Label使用方式（内置Size）不需要设置size约束，可以直接当做Label使用（使用内置Size），如果设置宽度，可能文字会有裁剪（xyz...），高度取icon的图标上下扩大4个像素
/// Icon样式，按照View常规样式，可以使用THKAvatarView，内部已集成标识组件，因为每个业务的UI部分头像大小不一样，所以需要外部设置宽高Size，在右下角显示
@interface THKIdentityView : THKView

@property (nonatomic, strong, readonly) THKIdentityViewModel *viewModel;
/// 图标
@property (nonatomic, strong, readonly) UIImageView *iconImageView;
/// 文本 （IconText样式才有）
@property (nonatomic, strong, readonly) UILabel *textLabel;
/// 获取认证标识View尺寸大小
@property (nonatomic, assign, readonly) CGSize viewSize;
/// 点击事件
@property (nonatomic, strong, readonly) RACSubject *onTapSubject;

@end

NS_ASSUME_NONNULL_END
