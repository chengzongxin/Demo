//
//  THKDiaryIndexView.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/26.
//

#import "THKDiaryIndexView.h"

@interface THKDiaryIndexView ()

@property (nonatomic, strong) UIView *outCircle;
@property (nonatomic, strong) UIView *intCircle;
@property (nonatomic, strong) UIView *line;

@end

@implementation THKDiaryIndexView
#pragma mark - Life Cycle

/// init or initWithFrame创建
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setup{
    self.circleWidth = 3;
    self.normalSize = CGSizeMake(13, 13);
    self.circleColor = UIColorHex(22C787);
    self.lineColor = UIColorHex(ECEEEC);
    
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = self.lineColor;
    _outCircle = [[UIView alloc] init];
    _outCircle.backgroundColor = self.circleColor;
    _outCircle.cornerRadius = self.normalSize.height / 2.0;
    _intCircle = [[UIView alloc] init];
    _intCircle.backgroundColor = UIColor.whiteColor;
    _intCircle.cornerRadius = (self.normalSize.height - self.circleWidth*2)/ 2.0;
    [self addSubview:_line];
    [self addSubview:_outCircle];
    [_outCircle addSubview:_intCircle];
    
}


#pragma mark - Public
// initWithModel or bindViewModel: 方法来到这里
// MARK: 初始化,刷新数据和UI,xib,重新设置时调用
- (void)bindViewModel{
    
}


#pragma mark - Private


#pragma mark - Getter && Setter
- (void)setPosition:(THKDiaryIndexPosition)position{
    
    _outCircle.cornerRadius = self.normalSize.height / 2.0;
    _intCircle.cornerRadius = (self.normalSize.height - self.circleWidth*2)/ 2.0;
    
    UIEdgeInsets insetCircle = UIEdgeInsetsMake(self.circleWidth, self.circleWidth, self.circleWidth, self.circleWidth);
    
    switch (position) {
        case THKDiaryIndexPosition_Top:
        {
            [_outCircle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(38);
                make.width.equalTo(self.mas_width);
                make.height.equalTo(self.mas_width);
            }];
            [_intCircle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(insetCircle);
            }];
            [_line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.top.equalTo(_outCircle.mas_bottom);
                make.width.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
            }];
        }
            break;
        case THKDiaryIndexPosition_Mid:
        {
            [_outCircle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.width.equalTo(self.mas_width);
                make.height.equalTo(self.mas_width);
            }];
            [_intCircle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(insetCircle);
            }];
            [_line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
            }];
        }
            break;
        case THKDiaryIndexPosition_Bot:
        {
            [_outCircle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.width.equalTo(self.mas_width);
                make.height.equalTo(self.mas_width);
            }];
            [_intCircle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(insetCircle);
            }];
            [_line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
            }];
        }
            break;
        case THKDiaryIndexPosition_Diary:
        {
            _outCircle.backgroundColor = UIColor.whiteColor;
            _intCircle.backgroundColor = self.circleColor;
            [_outCircle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(5);
                make.width.equalTo(self.mas_width);
                make.height.equalTo(self.mas_width);
            }];
            [_intCircle mas_makeConstraints:^(MASConstraintMaker *make) {
                UIEdgeInsets diaryInset = UIEdgeInsetsMake(self.circleWidth/2.0, self.circleWidth/2.0, self.circleWidth/2.0, self.circleWidth/2.0);
                make.edges.mas_equalTo(insetCircle);
            }];
            [_line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
            }];
        }
            break;

        default:
            break;
    }
}

@end
