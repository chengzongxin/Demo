//
//  TMUIFilterSectionHeader.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/30.
//

#import "TMUIFilterSectionHeader.h"

@interface TMUIFilterSectionHeader ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *subtitleLbl;

@end

@implementation TMUIFilterSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupviews];
    }
    return self;
}

- (void)setupviews{
    [self addSubview:self.titleLbl];
    [self addSubview:self.subtitleLbl];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.right.equalTo(self).inset(15);
    }];
    
    [self.subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl).offset(15);
        make.left.right.equalTo(self).inset(15);
    }];
    
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLbl.text = title;
}

- (void)setSubtitle:(NSString *)subtitle{
    _subtitle = subtitle;
    _subtitleLbl.text = subtitle;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
    }
    return _titleLbl;
}


- (UILabel *)subtitleLbl{
    if (!_subtitleLbl) {
        _subtitleLbl = [[UILabel alloc] init];
    }
    return _subtitleLbl;
}

@end
