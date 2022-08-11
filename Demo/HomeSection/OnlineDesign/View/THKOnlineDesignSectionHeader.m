//
//  THKOnlineDesignSectionHeader.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignSectionHeader.h"

@interface THKOnlineDesignSectionHeader ()

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
    [self addSubview:self.titleLbl];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(20);
    }];
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = UIFont(24);
        _titleLbl.textColor = UIColorDark;
    }
    return _titleLbl;
}

@end
