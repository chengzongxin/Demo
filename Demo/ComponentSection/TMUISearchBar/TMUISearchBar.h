//
//  TMUISearchBar.h
//  Demo
//
//  Created by 程宗鑫 on 2022/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TMUISearchBarCityClickBlock)(UIButton *btn);
typedef void(^TMUISearchBarTextClickBlock)(UITextField *textField);
typedef void(^TMUISearchBarTextChangeBlock)(UITextField *textField,NSString *text);
typedef void(^TMUISearchBarTextMaxLengthBlock)(UITextField *textField,NSRange range,NSString *replacementString);

typedef enum : NSUInteger {
    TMUISearchBarStyle_Normal,  ///< 常规样式
    TMUISearchBarStyle_City,  ///< 城市
} TMUISearchBarStyle;

@interface TMUISearchBar : UIView

- (instancetype)initWithStyle:(TMUISearchBarStyle)style;

#pragma mark - 方法接口
/// 是否可输入，默认YES
@property (nonatomic, assign) BOOL isCanInput;
/// 最大文字长度
@property (nonatomic, assign) NSInteger maxTextLength;
/// 城市
- (void)setCurrentCity:(NSString *)cityName;

#pragma mark - 事件响应
/// 点击城市
@property (nonatomic, copy) TMUISearchBarCityClickBlock cityClick;
/// 点击输入框，只有禁用了输入事件（isCanInput = NO），才会响应
@property (nonatomic, copy) TMUISearchBarTextClickBlock textClick;
/// 文字改变
@property (nonatomic, copy) TMUISearchBarTextChangeBlock textChange;
/// 输入达到最大长度
@property (nonatomic, copy) TMUISearchBarTextMaxLengthBlock maxLength;

@end

NS_ASSUME_NONNULL_END
