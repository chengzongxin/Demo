//
//  THKGraphicDetailSectionHeaderView.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import "THKGraphicDetailSectionHeaderView.h"

@interface THKGraphicDetailSectionHeaderView ()

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation THKGraphicDetailSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.titleLbl];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_lessThanOrEqualTo(0);
        make.height.mas_equalTo(22);
    }];
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorPrimary;
        _titleLbl.font = UIFontSemibold(16);
    }
    return _titleLbl;
}


- (CGSize)intrinsicContentSize{
    return CGSizeMake(TMUI_SCREEN_WIDTH, 32);
}

@end
