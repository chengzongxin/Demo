//
//  TMUIFilterCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/30.
//

#import "TMUIFilterCell.h"

@interface TMUIFilterCell ()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation TMUIFilterCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupviews];
    }
    return self;
}

- (void)setupviews {
    [self.contentView addSubview:self.btn];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton tmui_button];
    }
    return _btn;
}

@end
