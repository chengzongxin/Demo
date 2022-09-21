//
//  THKGraphicDetailSpaceCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/21.
//

#import "THKGraphicDetailSpaceCell.h"

@interface THKGraphicDetailSpaceCell ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIView *dot;

@end

@implementation THKGraphicDetailSpaceCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self setupSubviews];
//    }
//    return self;
//}


- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    _dot.hidden = !selected;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.dot];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.dot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom);
        make.centerX.equalTo(self.titleLbl);
        make.size.mas_equalTo(CGSizeMake(4, 4));
    }];
}

+ (CGFloat)heightWithModel:(THKGraphicDetailImgInfoItem *)model{
    CGSize size = [model.spaceTagName tmui_sizeForFont:UIFont(14) size:CGSizeMax lineHeight:26 mode:NSLineBreakByWordWrapping];
    return size.height;
}

- (void)setModel:(THKGraphicDetailImgInfoItem *)model{
    _model = model;
    
    self.titleLbl.text = model.spaceTagName;
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.font = UIFont(14);
        _titleLbl.textColor = UIColorWhite;
    }
    return _titleLbl;
}

- (UIView *)dot{
    if (!_dot) {
        _dot = [UIView new];
        _dot.backgroundColor = UIColor.whiteColor;
        _dot.cornerRadius = 2;
        _dot.hidden = YES;
    }
    return _dot;
}

@end
