//
//  THKOnlineDesignSearchAreaListCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import "THKOnlineDesignSearchAreaListCell.h"

@interface THKOnlineDesignSearchAreaListCell ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *subtitleLbl;

@end

@implementation THKOnlineDesignSearchAreaListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.subtitleLbl];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
    }];
    
    
    [self.subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(5);
        make.left.mas_equalTo(20);
    }];
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorDark;
        _titleLbl.font = UIFont(20);
        _titleLbl.text = @"万科云城1栋A座";
    }
    return _titleLbl;
}

- (UILabel *)subtitleLbl{
    if (!_subtitleLbl) {
        _subtitleLbl = [[UILabel alloc] init];
        _subtitleLbl.textColor = UIColorPlaceholder;
        _subtitleLbl.font = UIFont(16);
        _subtitleLbl.text = @"深圳市南山区-西丽";
    }
    return _subtitleLbl;
}

@end
