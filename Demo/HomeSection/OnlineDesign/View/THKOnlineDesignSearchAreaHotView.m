//
//  THKOnlineDesignSearchAreaHotView.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import "THKOnlineDesignSearchAreaHotView.h"

@interface THKOnlineDesignSearchAreaHotView ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) TMUIFloatLayoutView *floatLayoutView;

@end

@implementation THKOnlineDesignSearchAreaHotView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitalilze];
    }
    return self;
}

- (void)didInitalilze{
    [self addSubview:self.titleLbl];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
    }];
    
    [self addSubview:self.floatLayoutView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(60, 20, 20, 20);
    self.floatLayoutView.frame = CGRectMake(padding.left, padding.top, CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(padding), TMUIViewSelfSizingHeight);
}

- (void)setAreaList:(NSArray<NSString *> *)areaList{
    _areaList = areaList;
    
    [self addViewList:areaList];
}

- (void)addViewList:(NSArray<NSString *> *)list{
    [self.floatLayoutView removeAllSubviews];
    
    for (NSInteger i = 0; i < list.count; i++) {
        TMUIButton *button = [self generateGhostButtonWithColor:UIColorPrimary];
        [button setTitle:list[i] forState:UIControlStateNormal];
        [self.floatLayoutView addSubview:button];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.tapItem) {
                self.tapItem(i);
            }
        }];
    }
}

- (TMUIButton *)generateGhostButtonWithColor:(UIColor *)color {
    TMUIButton *button = [[TMUIButton alloc] init];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.backgroundColor = UIColorBackgroundLight;
    button.contentEdgeInsets = UIEdgeInsetsMake(6, 20, 6, 20);
    button.titleLabel.font = UIFontMake(14);
//    button.layer.borderColor = color.CGColor;
//    button.layer.borderWidth = 1;
    button.cornerRadius = TMUIButtonCornerRadiusAdjustsBounds;
    return button;
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorDark;
        _titleLbl.font = UIFont(20);
        _titleLbl.text = @"热门小区";
    }
    return _titleLbl;
}

- (TMUIFloatLayoutView *)floatLayoutView{
    if (!_floatLayoutView) {
        _floatLayoutView = [[TMUIFloatLayoutView alloc] init];
        _floatLayoutView.padding = UIEdgeInsetsMake(12, 12, 12, 12);
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        _floatLayoutView.minimumItemSize = CGSizeMake(69, 29);// 以2个字的按钮作为最小宽度
//        _floatLayoutView.layer.borderWidth = PixelOne;
//        _floatLayoutView.layer.borderColor = UIColorSeparator.CGColor;
    }
    return _floatLayoutView;
}

@end
