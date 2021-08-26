//
//  THKDiaryCircleView.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/26.
//

#import "THKDiaryCircleView.h"

const CGFloat THKDiaryCircleWidth = 13;

@interface THKDiaryCircleView ()

@property (nonatomic, strong) UIView *outCircle;
@property (nonatomic, strong) UIView *intCircle;

@end

@implementation THKDiaryCircleView
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
    self.normalSize = CGSizeMake(THKDiaryCircleWidth, THKDiaryCircleWidth);
    self.circleColor = UIColorHex(22C787);
    self.lineColor = UIColorHex(ECEEEC);
    
    _outCircle = [[UIView alloc] init];
    _outCircle.backgroundColor = self.circleColor;
    _outCircle.cornerRadius = self.normalSize.height / 2.0;
    _intCircle = [[UIView alloc] init];
    _intCircle.backgroundColor = UIColor.whiteColor;
    _intCircle.cornerRadius = (self.normalSize.height - self.circleWidth*2)/ 2.0;
    [self addSubview:_outCircle];
    [_outCircle addSubview:_intCircle];
}


- (void)setType:(THKDiaryCircleType)type{
    _outCircle.cornerRadius = self.normalSize.height / 2.0;
    _intCircle.cornerRadius = (self.normalSize.height - self.circleWidth*2)/ 2.0;
    
    UIEdgeInsets insetCircle = UIEdgeInsetsMake(self.circleWidth, self.circleWidth, self.circleWidth, self.circleWidth);
    
    switch (type) {
        case THKDiaryCircleType_Section:
        {
            [_outCircle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.width.equalTo(self.mas_width);
                make.height.equalTo(self.mas_width);
            }];
            [_intCircle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(insetCircle);
            }];
        }
            break;
        case THKDiaryCircleType_Row:
        {
            _outCircle.backgroundColor = UIColor.whiteColor;
            _intCircle.backgroundColor = self.circleColor;
            [_outCircle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(5);
                make.width.equalTo(self.mas_width);
                make.height.equalTo(self.mas_width);
            }];
            [_intCircle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(insetCircle);
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Private



#pragma mark - Getter && Setter


@end
