//
//  CycleCardCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/5/17.
//

#import "CycleCardCell.h"

@implementation CycleCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self thk_setupView];
    }
    return self;
}

- (void)thk_setupView {
    [self.contentView addSubview:self.textLbl];
    
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UILabel *)textLbl{
    if (!_textLbl) {
        _textLbl = [[UILabel alloc] init];
        _textLbl.backgroundColor = UIColor.tmui_randomColor;
        _textLbl.textAlignment = NSTextAlignmentCenter;
        _textLbl.textColor = UIColor.whiteColor;
        _textLbl.font = UIFont(20);
        _textLbl.layer.cornerRadius = 9;
        _textLbl.layer.masksToBounds = YES;
    }
    return _textLbl;
}


@end
