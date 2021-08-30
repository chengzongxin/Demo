//
//  THKDiaryDirectoryCell.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/27.
//

#import "THKDiaryDirectoryCell.h"
#import "THKDiaryCircleView.h"
#import "THKDiaryCircle.h"

@interface THKDiaryDirectoryCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) THKDiaryCircle *circle;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation THKDiaryDirectoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubviews];
}

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
    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.circle];
    [self.contentView addSubview:self.titleLabel];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14.5);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(1);
        make.height.equalTo(self.contentView).multipliedBy(.5);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14.5);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
        make.height.equalTo(self.contentView).multipliedBy(.5);
    }];
    
    [self.circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(7, 7));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    self.topLineView.hidden = (indexPath.row == 0);
}

//- (void)setSelected:(BOOL)selected{
//    [super setSelected:selected];
//
//    if (selected) {
////        _titleLabel.textColor = UIColor.whiteColor;
//        self.circle.tmui_borderWidth = 3;
//        self.circle.layer.cornerRadius = 13/2.0;
//    }else{
////        _titleLabel.textColor = UIColorHex(#333333);
//        self.circle.tmui_borderWidth = 1;
//        self.circle.layer.cornerRadius = 7/2.0;
//    }
//
//    [self setNeedsDisplay];
//}




- (UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = UIColorHex(ECEEEC);
    }
    return _topLineView;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = UIColorHex(ECEEEC);
    }
    return _bottomLineView;
}

//- (UIView *)circle{
//    if (!_circle) {
//        _circle = [[UIView alloc] init];
//        _circle.tmui_borderColor = UIColorHex(22C787);
//        _circle.tmui_borderPosition = TMUIViewBorderPositionTop|TMUIViewBorderPositionLeft|TMUIViewBorderPositionBottom|TMUIViewBorderPositionRight;
//        _circle.tmui_borderLocation = TMUIViewBorderLocationInside;
//        _circle.tmui_borderWidth = 3;
//        _circle.backgroundColor = UIColor.whiteColor;
//        _circle.layer.cornerRadius = 13/2.0;
//        _circle.layer.masksToBounds = YES;
//    }
//    return _circle;
//}

- (THKDiaryCircle *)circle{
    if (!_circle) {
        _circle = [[THKDiaryCircle alloc] init];
        _circle.layer.cornerRadius = 7/2.0;
        _circle.layer.masksToBounds = YES;
    }
    return _circle;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"找设计师";
    }
    return _titleLabel;
}

@end
