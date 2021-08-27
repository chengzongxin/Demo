//
//  THKDiaryBookLastCell.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/27.
//

#import "THKDiaryBookLastCell.h"
#import "THKDiaryBookCell.h"
#import "THKDiaryCircleView.h"

@interface THKDiaryBookLastCell ()
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) THKDiaryCircleView *circleView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation THKDiaryBookLastCell


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
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.circleView];
    [self.contentView addSubview:self.contentLabel];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView.mas_centerX);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(2);
    }];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(THKDiaryCircleWidth);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kDiaryContentInset.left);
        make.right.mas_equalTo(-kDiaryContentInset.right);
    }];
    
    [self.contentLabel tmui_setAttributesString:@"屋主还在为自己的家努力，你可以提醒TA继续更新～" lineSpacing:6];
}

- (void)bindViewModel:(THKDiaryBookCellVM *)viewModel{
    
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize realSize = CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(kDiaryContentInset), 0);
    
    realSize.height += [self.contentLabel tmui_sizeForWidth:realSize.width].height;
    realSize.height += 150;
    
    return realSize;
}


- (THKDiaryCircleView *)circleView{
    if (!_circleView) {
        _circleView = [[THKDiaryCircleView alloc] init];
        _circleView.type = THKDiaryCircleType_Row;
    }
    return _circleView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorHex(ECEEEC);
    }
    return _lineView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = UIColorHex(010101);
        _contentLabel.font = UIFont(16);
    }
    return _contentLabel;
}
@end
