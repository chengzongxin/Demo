//
//  THKOnlineDesignHeader.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignHeader.h"

@interface THKOnlineDesignHeader ()

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation THKOnlineDesignHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self addSubview:self.titleLbl];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(50);
    }];
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = UIFont(18);
        _titleLbl.textColor = UIColorDark;
        _titleLbl.text = @"无需到店，在线出图";
    }
    return _titleLbl;
}


@end
