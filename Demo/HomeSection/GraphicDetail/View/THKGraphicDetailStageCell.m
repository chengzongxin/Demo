//
//  THKGraphicDetailStageCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import "THKGraphicDetailStageCell.h"

@interface THKGraphicDetailStageCell ()

@end

@implementation THKGraphicDetailStageCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.titleLbl];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
}

- (void)setModel:(THKGraphicDetailContentListItem *)model{
    _model = model;
    
    self.titleLbl.text = model.anchor;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (selected) {
        self.containerView.backgroundColor = UIColorGreen;
        self.titleLbl.textColor = UIColorWhite;
        self.titleLbl.font = UIFontMedium(14);
    }else{
        self.containerView.backgroundColor = UIColorBackgroundLight;
        self.titleLbl.textColor = UIColorDark;
        self.titleLbl.font = UIFont(14);
    }
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = UIColorBackgroundLight;
        _containerView.cornerRadius = 12;
    }
    return _containerView;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.font = UIFont(14);
        _titleLbl.textColor = UIColorDark;
    }
    return _titleLbl;
}

@end
