//
//  THKOnlineDesignHouseDemandView.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignHouseDemandView.h"
#import "THKOnlineDesignAudioView.h"

@interface THKOnlineDesignHouseDemandView ()


//@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation THKOnlineDesignHouseDemandView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setupSubviews];
        self.axis = UILayoutConstraintAxisVertical;
        self.distribution = UIStackViewDistributionFillEqually;
        self.alignment = UIStackViewAlignmentLeading;
        self.spacing = 14;
    }
    return self;
}

- (void)setDemands:(NSArray<THKAudioDescription *> *)demands{
    _demands = demands;
    
    [self tmui_removeAllSubviews];
    
    [demands enumerateObjectsUsingBlock:^(THKAudioDescription * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        THKOnlineDesignAudioView *audioView = [self createAudioView:obj.duration idx:idx];
        [self addArrangedSubview:audioView];
    }];
}

- (THKOnlineDesignAudioView *)createAudioView:(NSInteger)time idx:(NSUInteger)idx{
    THKOnlineDesignAudioView *audioView = [[THKOnlineDesignAudioView alloc] init];
    audioView.cornerRadius = 16;
    audioView.tag = idx;
    audioView.timeInterval = time;
    self.clickPlayBlock = audioView.clickPlayBlock;
    self.clickCloseBlock = audioView.clickCloseBlock;
    return audioView;
}

//- (void)btnClick:(UIButton *)btn{
//    [[THKRecordTool sharedInstance] play:btn.tmui_text];
//}

//- (void)setupSubviews{
//    [self addSubview:self.stackView];
//    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
//}

//- (UIStackView *)stackView{
//    if (!_stackView) {
//        _stackView = [[UIStackView alloc] init];
//        _stackView.axis = UILayoutConstraintAxisVertical;
//    }
//    return _stackView;
//}


@end
