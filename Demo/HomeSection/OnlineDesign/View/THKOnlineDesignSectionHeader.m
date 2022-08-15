//
//  THKOnlineDesignSectionHeader.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignSectionHeader.h"

@interface THKOnlineDesignSectionHeader ()

@property (nonatomic, strong) UILabel *numLbl;

@property (nonatomic, strong) UILabel *titleLbl;
@end



@implementation THKOnlineDesignSectionHeader


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    [self addSubview:self.numLbl];
    [self addSubview:self.titleLbl];
    
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.numLbl.mas_right).offset(4);
    }];
}

- (UILabel *)numLbl{
    if (!_numLbl) {
        _numLbl = [UILabel new];
        _numLbl.font = UIFontDINAlt(9);
        _numLbl.textColor = UIColorWhite;
        _numLbl.backgroundColor = UIColorDark;
        _numLbl.cornerRadius = 7;
        _numLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _numLbl;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = UIFont(14);
        _titleLbl.textColor = UIColorDark;
    }
    return _titleLbl;
}

@end
