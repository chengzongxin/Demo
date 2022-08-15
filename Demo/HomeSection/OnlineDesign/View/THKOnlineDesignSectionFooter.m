//
//  THKOnlineDesignSectionFooter.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/15.
//

#import "THKOnlineDesignSectionFooter.h"

@interface THKOnlineDesignSectionFooter ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation THKOnlineDesignSectionFooter


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    [self addSubview:self.button];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.right.equalTo(self).inset(20);
    }];
}

- (UIButton *)button{
    if (!_button) {
        _button = [TMUIButton tmui_button];
    }
    return _button;
}

@end
