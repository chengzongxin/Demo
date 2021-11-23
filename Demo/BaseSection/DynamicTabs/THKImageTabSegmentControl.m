//
//  THKImageTabSegmentControl.m
//  HouseKeeper
//
//  Created by amby.qin on 2020/10/30.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKImageTabSegmentControl.h"
//#import <YYWebImage/YYWebImage.h>

#define kImageAndTextOffset 4
#define kBadgeSize CGSizeMake(6,6)
#define kButtonEdgeInsets UIEdgeInsetsMake(0, 10, 0, 10)

@interface THKImageTabSegmentButton ()

@property (nonatomic, strong)   YYAnimatedImageView *iconImageView;
@property (nonatomic, strong)   UILabel *textLabel;
@property (nonatomic, strong)   UIImageView *badgeIconView;

@property (nonatomic, strong)   THKDynamicTabsModel *tabModel;
@property (nonatomic, strong)   UIView  *containerView;

@end

@implementation THKImageTabSegmentButton


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView  *containerView = [[UIView alloc] init];
        containerView.userInteractionEnabled = NO;
        [self addSubview:containerView];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.left.height.top.equalTo(self);
            make.edges.mas_equalTo(kButtonEdgeInsets);
        }];
        self.containerView = containerView;
        
        [containerView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(0);
            make.centerY.equalTo(containerView);
            make.size.mas_equalTo(CGSizeZero);
        }];
        
        [containerView addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).mas_offset(0);
            make.centerY.equalTo(containerView);
            make.right.mas_offset(0);
            make.width.mas_equalTo(0);
        }];
        
        [self addSubview:self.badgeIconView];
        [self.badgeIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(containerView.mas_right).mas_offset(-3);
            make.centerY.equalTo(containerView).mas_offset(-10);
            make.size.mas_equalTo(kBadgeSize);
        }];
    }
    return self;
}

- (void)setButtonModel:(THKDynamicTabsModel *)model textWidth:(CGFloat)textWidth {
    _tabModel = model;
    if (model.style != THKDynamicTabButtonStyle_TextOnly) {
        [self.iconImageView loadImageWithUrlStr:model.image.url];
        [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(model.image.width, model.image.height));
        }];
    }
    
    if (model.style != THKDynamicTabButtonStyle_ImageOnly) {
        self.textLabel.font =  model.displayModel.normalFont;
        self.textLabel.text = model.title;
        [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textWidth);
            if (model.style == THKDynamicTabButtonStyle_TextAndImage) {
                make.left.equalTo(self.iconImageView.mas_right).mas_offset(kImageAndTextOffset);
            }
        }];
    }
    
    if (model.displayModel.badgeImageColor) {
        self.badgeIconView.backgroundColor = model.displayModel.badgeImageColor;
    }
    [self showBadgeIconWithModel:model];
}

- (void)showBadgeIconWithModel:(THKDynamicTabsModel *)model {
    _tabModel = model;
    BOOL show = self.tabModel.displayModel.showBadge;
    self.badgeIconView.hidden = !show;
}

- (void)setSelected:(BOOL)selected {
    THKDynamicTabDisplayModel *displayModel = self.tabModel.displayModel;
    if (self.tabModel.style != THKDynamicTabButtonStyle_ImageOnly) {
        self.textLabel.font = selected ? displayModel.selectedFont : displayModel.normalFont;
        self.textLabel.textColor = selected ? displayModel.selectedColor : displayModel.normalColor;
    }
}

- (YYAnimatedImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[YYAnimatedImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UIImageView *)badgeIconView {
    if (!_badgeIconView) {
        _badgeIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kBadgeSize.width, kBadgeSize.height)];
        _badgeIconView.cornerRadius = kBadgeSize.width / 2;
        _badgeIconView.backgroundColor = THKColor_RedPointColor;
    }
    return _badgeIconView;
}

- (NSString *)currentTitle {
    return self.tabModel.title?:@"";
}

@end

@interface THKImageTabSegmentControl ()

@property (nonatomic, copy)   NSArray<THKDynamicTabsModel *> *titles;
@property (nonatomic, strong) NSMutableArray<THKImageTabSegmentButton *> *titleBtns;

@end

@implementation THKImageTabSegmentControl
@dynamic titleBtns,titles;
@synthesize scale = _scale;

- (UIButton *)createButtonWithObject:(THKDynamicTabsModel *)model index:(NSInteger)index offsetX:(CGFloat)offsetX {
    if (![model isKindOfClass:[THKDynamicTabsModel class]]) {
        return nil;
    }
    UIFont *selectedFont = model.displayModel.selectedFont;
    CGFloat textWidth = 0;
    CGFloat tempWidth = kButtonEdgeInsets.left + kButtonEdgeInsets.right;// + ((index == self.titles.count - 1) ? 0 : 14);//左边距离5px，红点6px，红点距离右边2px
    if (model.style == THKDynamicTabButtonStyle_TextOnly || model.style == THKDynamicTabButtonStyle_TextAndImage) { //纯文字/图文混排
        textWidth = [model.title boundingRectWithSize:CGSizeMake(FLT_MAX, self.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:selectedFont} context:nil].size.width + 2;
        textWidth = MAX(textWidth,self.minItemWidth);
        tempWidth += textWidth;
        if (model.style == THKDynamicTabButtonStyle_TextAndImage) {
            tempWidth += (model.image.width + kImageAndTextOffset);
        }
    } else if (model.style == THKDynamicTabButtonStyle_ImageOnly) { //纯图片
        tempWidth += model.image.width;
    }
    
    THKImageTabSegmentButton *button = [[THKImageTabSegmentButton alloc] initWithFrame:CGRectMake(offsetX, 0, tempWidth, self.height)];
    [button setButtonModel:model textWidth:textWidth];
    return button;
}

- (void)showButtonBadgeWithModel:(THKDynamicTabsModel *)model {
    [self.titleBtns enumerateObjectsUsingBlock:^(THKImageTabSegmentButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tabModel.tabId == model.tabId) {
            [obj showBadgeIconWithModel:model];
            *stop = YES;
        }
    }];
}

- (CGRect)getButtonRect:(UIButton *)button index:(NSInteger)index {
    CGRect rect = [self convertRect:button.frame toView:self];
    if (![button isKindOfClass:[THKImageTabSegmentButton class]]) {
        return CGRectMake(button.centerX - self.indicatorView.width / 2, self.indicatorView.top, self.indicatorView.width, self.indicatorView.height);;
    }
    CGFloat offset = 14;
    if (index == self.titles.count - 1) {
        offset = 0;
    }
    return CGRectMake(button.centerX - self.indicatorView.width / 2, self.indicatorView.top, self.indicatorView.width, self.indicatorView.height);//CGRectMake((button.centerX - (kBadgeSize.width + offset) / 2) - self.indicatorView.width / 2, self.indicatorView.top, self.indicatorView.width, self.indicatorView.height);
}

//- (void)setMinItemWidth:(CGFloat)minItemWidth {
//    //覆盖父类方法，不做任何处理
//}

- (void)setScale:(CGFloat)scale {
    
    for (THKImageTabSegmentButton *button in self.titleBtns) {
        if (button.tabModel.style == THKDynamicTabButtonStyle_ImageOnly) {
            continue;
        }
        button.textLabel.transform = CGAffineTransformIdentity;
        if (button == self.lastSelectedButton) {
            [self scaleFontForSelectedButton:(THKImageTabSegmentButton *)self.lastSelectedButton normalButton:nil];
        } else {
            if (button.tabModel.displayModel.scale > 0) {
                button.textLabel.transform = CGAffineTransformMakeScale(button.tabModel.displayModel.scale, button.tabModel.displayModel.scale);
            }
        }
    }
}

- (void)scaleFontForSelectedButton:(THKImageTabSegmentButton *)selectedButton normalButton:(THKImageTabSegmentButton *)normalButton {

    [UIView animateWithDuration:0.25 animations:^{
        if (selectedButton.tabModel.style != THKDynamicTabButtonStyle_ImageOnly) {
            selectedButton.textLabel.transform = CGAffineTransformIdentity;
        } else {
            selectedButton.iconImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
        if (normalButton.tabModel.style == THKDynamicTabButtonStyle_ImageOnly) {
            normalButton.iconImageView.transform = CGAffineTransformIdentity;
        }
        if (normalButton.tabModel.style != THKDynamicTabButtonStyle_ImageOnly && normalButton.tabModel.displayModel.scale > 0) {
            normalButton.textLabel.transform = CGAffineTransformMakeScale(normalButton.tabModel.displayModel.scale, normalButton.tabModel.displayModel.scale);
        }
    }];
}

- (NSString *)titleForSelected {
    THKDynamicTabsModel *model = [self.titles safeObjectAtIndex:self.selectedIndex];
    return model.title;
}

- (NSMutableDictionary <NSNumber *, UIFont *> *)titleFontAttributes {
    //覆盖父类方法，不做任何处理
    return nil;
}

- (NSMutableDictionary <NSNumber *, UIColor *> *)titleColorAttributes {
    //覆盖父类方法，不做任何处理
    return nil;
}

- (void)reloadSegmentWithTitles:(NSArray<THKDynamicTabsModel *> *)segmentTitles animated:(BOOL)animated {
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:segmentTitles.count];
    __block CGFloat totalWidth = 0;
    [segmentTitles enumerateObjectsUsingBlock:^(THKDynamicTabsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        THKImageTabSegmentButton *button = [self existButtonForModel:obj];
        if (!button) {
            button = (THKImageTabSegmentButton *)[self createButtonWithObject:obj index:idx offsetX:totalWidth];
            
        }
        totalWidth += button.width;
        [arrayTemp addObject:button];
    }];
}

- (THKImageTabSegmentButton *)existButtonForModel:(THKDynamicTabsModel *)model {
    __block THKImageTabSegmentButton *button = nil;
    [self.titleBtns enumerateObjectsUsingBlock:^(THKImageTabSegmentButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.targetUrl isEqualToString:obj.tabModel.targetUrl]) {
            button = obj;
            *stop = YES;
        }
    }];
    return button;
}


@end
