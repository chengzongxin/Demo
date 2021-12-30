//
//  UILabel+Fold.h
//  Demo
//
//  Created by Joe.cheng on 2021/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Fold)

@property (nonatomic, strong) NSAttributedString *unfoldString;

@property (nonatomic, strong) NSAttributedString *foldString;

@end

NS_ASSUME_NONNULL_END
