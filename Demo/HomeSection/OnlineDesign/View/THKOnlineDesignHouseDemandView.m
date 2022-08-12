//
//  THKOnlineDesignHouseDemandView.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignHouseDemandView.h"
#import "THKRecordTool.h"

@interface THKOnlineDesignHouseDemandView ()


@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation THKOnlineDesignHouseDemandView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setDemands:(NSArray<NSString *> *)demands{
    _demands = demands;
    
    [self.stackView tmui_removeAllSubviews];
    
    [demands enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TMUIButton *btn = [TMUIButton tmui_button];
        btn.tmui_text = obj;
        btn.backgroundColor = UIColor.tmui_randomColor;
        [btn tmui_addTarget:self action:@selector(btnClick:)];
        [self.stackView addArrangedSubview:btn];
    }];
}

- (void)btnClick:(UIButton *)btn{
    [[THKRecordTool sharedInstance] play:btn.tmui_text];
}

- (void)setupSubviews{
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UIStackView *)stackView{
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisVertical;
    }
    return _stackView;
}


@end
