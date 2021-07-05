//
//  NSAttributedString+THKTextTagLabel.m
//  Example
//
//  Created by nigel.ning on 2020/11/12.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "NSAttributedString+THKTextTagLabel.h"

@implementation NSAttributedString(THKTextTagLabelAttributedString)


- (void)setThk_drawBackgroundRange:(NSRange)thk_drawBackgroundRange {
    _tmui_setAssociatedStrongObj(self, @selector(thk_drawBackgroundRange), [NSValue valueWithRange:thk_drawBackgroundRange]);
}
- (NSRange)thk_drawBackgroundRange {
    NSValue *value = _tmui_associatedStrongObj(self, @selector(thk_drawBackgroundRange));
    return [value rangeValue];
}

- (void)setThk_drawBackgroundColor:(UIColor *)thk_drawBackgroundColor {
    _tmui_setAssociatedStrongObj(self, @selector(thk_drawBackgroundColor), thk_drawBackgroundColor);
}
- (UIColor *)thk_drawBackgroundColor {
    return _tmui_associatedStrongObj(self, @selector(thk_drawBackgroundColor));
}

- (void)setThk_drawRangeTextColor:(UIColor *)thk_drawRangeTextColor {
    _tmui_setAssociatedStrongObj(self, @selector(thk_drawRangeTextColor), thk_drawRangeTextColor);
}
- (UIColor *)thk_drawRangeTextColor {
    return _tmui_associatedStrongObj(self, @selector(thk_drawRangeTextColor));
}

- (void)setThk_drawBackgroundCornerRadius:(CGFloat)thk_drawBackgroundCornerRadius {
    _tmui_setAssociatedStrongObj(self, @selector(thk_drawBackgroundCornerRadius), @(thk_drawBackgroundCornerRadius));
}
- (CGFloat)thk_drawBackgroundCornerRadius {
    NSNumber *radiusNum = _tmui_associatedStrongObj(self, @selector(thk_drawBackgroundCornerRadius));
    return radiusNum ? [radiusNum floatValue] : 2;
}

@end
