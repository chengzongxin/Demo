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

/// 用于THKIdentityView绑定使用，调用bindViewModel：方法
/// @note 内部还未做RAC通知绑定，如果需要改动原有vm，需要重新生成一个新的vm，再绑定到View
@interface THKIdentityViewModel : THKViewModel
/// 标识类型，如果不传则不显示标识
@property (nonatomic, assign) NSInteger type;
/// 标识二级类型，没有二级标识类型可不传
@property (nonatomic, assign) NSInteger subType;
/// 显示样式，Icon或者IconText
@property (nonatomic, assign) THKIdentityStyle style;
/// 本地标识图像，只有3个图标可供选择
@property (nonatomic, strong) UIImage *iconLocal;
/// 标识图像URL
@property (nonatomic, strong) NSString *iconUrl;
/// 标识描述文本（IconText需要）
@property (nonatomic, strong) NSString *text;
/// 标识文本字体（IconText需要）
@property (nonatomic, strong) UIFont *font;
/// 标识文本颜色（IconText需要）
@property (nonatomic, strong) UIColor *textColor;
/// 标识背景色（IconText需要）
@property (nonatomic, strong) UIColor *backgroundColor;
/// 标识尺寸
@property (nonatomic, assign) CGSize iconSize;
/// 文本缩进，其中（上，左，下）对应icon在view中的缩进
/// 文本缩进，其中（右）对应文本距离右边的缩进
/// 设置后，标识View会按照iconSize增大
@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets;
/// 标识icon和文本的间距
@property (nonatomic, assign) CGFloat imageTextSpace;
/// 标识内容偏移（图标和文本）
@property (nonatomic, assign) CGPoint contentOffset;
/// 标识点击信号
//@property (nonatomic, strong, readonly) RACSubject *onTapSubject;
/// 抓取配置是否成功
@property (nonatomic, assign, readonly) BOOL fetchConfigSuccess;

/// 创建标识View
/// @param type V标识类型
/// @param subType 二级标识分类，有些业务线会一个类型下会对应两个标识，比如11.1设计机构，11.2个人设计师
/// @param style V标识样式
+ (instancetype)viewModelWithType:(NSInteger)type
                          subType:(NSInteger)subType
                            style:(THKIdentityStyle)style;


/// 初始化创建标识View
/// @param type V标识类型
/// @param subType 二级标识分类，有些业务线会一个类型下会对应两个标识，比如11.1设计机构，11.2个人设计师
/// @param style V标识样式
- (instancetype)initWithType:(NSInteger)type
                     subType:(NSInteger)subType
                       style:(THKIdentityStyle)style;



@end

NS_ASSUME_NONNULL_END
