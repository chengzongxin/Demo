//
//  TMCardLiveStatusView.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/12/22.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardLiveStatusView.h"
//#import <Lottie/Lottie.h>

@interface TMCardLiveStatusView()

///直播状态视图中左侧的lottie 动画视图, 当显示liveStatusView时此动画需要开启，当显示vodStatusView时此暂停已有动画
@property (nonatomic, strong)UIView *liveStatusIconLottieView;

@property (nonatomic, strong)UIImageView *vodBoxView;/// 回放背景块视图- 包含了背景色及"回放"

/// label: "xxx 观看"
@property (nonatomic, strong)UILabel *watchNumDesLabel;

@end

@implementation TMCardLiveStatusView

TMUI_PropertyLazyLoad(UIImageView, vodBoxView);
TMUI_PropertyLazyLoad(UILabel, watchNumDesLabel);

- (void)thk_setupViews {
    [super thk_setupViews];
    
//    self.liveStatusIconLottieView = [[LOTAnimationView alloc] init];
//    self.liveStatusIconLottieView.loopAnimation = YES;
//    [self.liveStatusIconLottieView setAnimationNamed:@"listCardLiveStatusAnimate_V8_10"];
//    [self.liveStatusIconLottieView stop];
    [self addSubview:self.liveStatusIconLottieView];
    
    [self addSubview:self.vodBoxView];
    [self addSubview:self.watchNumDesLabel];
    
    [self thk_setupSubConstraints];
}

- (void)thk_setupSubConstraints {
    [self.liveStatusIconLottieView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(5);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.vodBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.width.mas_equalTo(34);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.watchNumDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).mas_offset(34 + 5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).mas_offset(-5);
    }];
    
    //
    self.clipsToBounds = YES;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.vodBoxView.contentMode = UIViewContentModeScaleAspectFit;
    self.vodBoxView.clipsToBounds = YES;
    self.watchNumDesLabel.clipsToBounds = YES;
        
    self.watchNumDesLabel.textColor = [UIColor whiteColor];
    self.watchNumDesLabel.font = UIFontMedium(10);
    
    self.vodBoxView.image = [UIImage imageNamed:@"liveCard_vodTextBoxImg"];
    self.contentRadius = 4;
    self.living = NO;
    self.watchNumFormatStr = nil;
}

- (void)setContentRadius:(CGFloat)contentRadius {
    _contentRadius = contentRadius;
    self.layer.cornerRadius = contentRadius;
    self.vodBoxView.layer.cornerRadius = contentRadius;
}

- (void)setLiving:(BOOL)living {
    _living = living;
    if (_living) {
        self.vodBoxView.hidden = YES;
        self.liveStatusIconLottieView.hidden = NO;
//        [self.liveStatusIconLottieView play];
    }else {
        self.vodBoxView.hidden = NO;
        self.liveStatusIconLottieView.hidden = YES;
//        [self.liveStatusIconLottieView stop];
    }
    [self updateWatchNumLabelWithWatchNumFormatStr:self.watchNumFormatStr];
}

- (void)setWatchNumFormatStr:(NSString *)watchNumFormatStr {
    _watchNumFormatStr = watchNumFormatStr;
    [self updateWatchNumLabelWithWatchNumFormatStr:watchNumFormatStr];
}

- (void)updateWatchNumLabelWithWatchNumFormatStr:(NSString *)watchNumFormatStr {    
    if (watchNumFormatStr.length == 0) {
        CGFloat leading = _living ? 5 + 16 + 5 : 34;
        //不显示文本
        self.watchNumDesLabel.text = nil;
        [self.watchNumDesLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading).mas_offset(leading);
            make.trailing.mas_equalTo(self.mas_trailing).mas_offset(0);
        }];
    }else {
        CGFloat leading = _living ? 5 + 16 : 34;
        [self.watchNumDesLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading).mas_offset(leading + 5);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.trailing.mas_equalTo(self.mas_trailing).mas_offset(-5);
        }];
        UIFont *numFont = [UIFont fontWithName:@"DIN Alternate" size:12];
        if (!numFont) {
            numFont = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
        }
        UIFont *textFont = UIFontMedium(10);
        NSString *text = @"观看";
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", watchNumFormatStr, text]];
        NSRange textRg = [mAttr.string rangeOfString:text];
        [mAttr addAttributes:@{NSFontAttributeName: numFont} range:NSMakeRange(0, watchNumFormatStr.length)];
        [mAttr addAttributes:@{NSFontAttributeName: textFont, NSBaselineOffsetAttributeName: @(0.36 * (numFont.pointSize - textFont.pointSize))} range:textRg];
        self.watchNumDesLabel.attributedText = mAttr;
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (!self.superview) {
//        [self.liveStatusIconLottieView stop];
    }
}

@end
