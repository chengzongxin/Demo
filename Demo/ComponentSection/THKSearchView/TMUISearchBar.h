//
//  TMUISearchBar.h
//  Demo
//
//  Created by 程宗鑫 on 2022/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TMUISearchBarStyle_Normal,
    TMUISearchBarStyle_City,
} TMUISearchBarStyle;

@interface TMUISearchBar : UIView

- (instancetype)initWithStyle:(TMUISearchBarStyle)style;

@end

NS_ASSUME_NONNULL_END
