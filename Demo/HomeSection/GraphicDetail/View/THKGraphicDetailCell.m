//
//  THKGraphicDetailCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import "THKGraphicDetailCell.h"

@interface THKGraphicDetailCell ()

@end

@implementation THKGraphicDetailCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.titleLbl];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(0);
    }];
}

+ (CGFloat)heightWithModel:(THKGraphicDetailContentListItem *)model{
    CGSize size = [model.anchorContent tmui_sizeForFont:UIFont(16) size:CGSizeMax lineHeight:26 mode:NSLineBreakByWordWrapping];
    return size.height;
}

- (void)setModel:(THKGraphicDetailContentListItem *)model{
    _model = model;
    
    self.titleLbl.text = model.anchorContent;
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.font = UIFont(16);
        _titleLbl.textColor = UIColorPrimary;
    }
    return _titleLbl;
}


@end
