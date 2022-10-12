//
//  THKCalculateQuotationCell.m
//  Demo
//
//  Created by 程宗鑫 on 2022/10/12.
//

#import "THKCalculateQuotationCell.h"

@interface THKCalculateQuotationCell ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIView *rightContentView;

@end

@implementation THKCalculateQuotationCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.rightContentView];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.rightContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_right);
        make.right.equalTo(self.contentView).inset(20);
        make.top.bottom.equalTo(self.contentView);
    }];
    
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorDark;
        _titleLbl.font = UIFontMedium(14);
    }
    return _titleLbl;
}

TMUI_PropertyLazyLoad(UIView, rightContentView);


@end
