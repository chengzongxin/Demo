//
//  THKOnlineDesignAudioView.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/15.
//

#import "THKOnlineDesignAudioView.h"

@interface THKOnlineDesignAudioView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *audioImgV;

@property (nonatomic, strong) UILabel *timeLbl;

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation THKOnlineDesignAudioView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.audioImgV];
    [self.contentView addSubview:self.timeLbl];
    [self addSubview:self.closeBtn];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(60);
    }];
    
    [self.audioImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_right).offset(6);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setTimeInterval:(NSInteger)timeInterval{
    _timeInterval = timeInterval;
//    1’ 30’’
    NSInteger minute = timeInterval / 60;
    NSInteger second = timeInterval % 60;
    if (minute > 0) {
        _timeLbl.text = [NSString stringWithFormat:@"%zd’ %zd’’",minute,second];
    }else{
        _timeLbl.text = [NSString stringWithFormat:@"%zd’’",second];
    }
    if (timeInterval > 0) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60 + timeInterval * 5);
        }];
    }
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = UIColorGreen;
        _contentView.cornerRadius = 16;
        @weakify(self);
        [_contentView tmui_addSingerTapWithBlock:^{
            @strongify(self);
            if (self.clickPlayBlock) {
                self.clickPlayBlock(self.contentView,self.tag);
            }
        }];
    }
    return _contentView;
}

- (UIImageView *)audioImgV{
    if (!_audioImgV) {
        _audioImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"od_record_white")];
    }
    return _audioImgV;
}

- (UILabel *)timeLbl{
    if (!_timeLbl) {
        _timeLbl = [UILabel new];
        _timeLbl.font = UIFont(12);
        _timeLbl.textColor = UIColorWhite;
    }
    return _timeLbl;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton tmui_button];
        _closeBtn.tmui_image = UIImageMake(@"od_record_close_icon");
        @weakify(self);
        [_closeBtn tmui_addActionBlock:^(NSInteger tag) {
            @strongify(self);
            if (self.clickCloseBlock) {
                self.clickCloseBlock(self.closeBtn,self.tag);
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(TMUI_SCREEN_WIDTH - 70, 32);
}

@end
