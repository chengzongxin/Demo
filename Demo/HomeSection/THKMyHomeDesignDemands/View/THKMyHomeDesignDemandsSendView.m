//
//  THKMyHomeDesignDemandsSendView.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/16.
//

#import "THKMyHomeDesignDemandsSendView.h"


@interface THKMyHomeDesignDemandsSendView ()


@end

@implementation THKMyHomeDesignDemandsSendView


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)thk_setupViews{
    [self addSubview:self.sendButton];
    CGFloat bottom = 24;
    if (kSafeAreaBottomInset() > 0) {
        bottom = 34;
    }
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(48);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-bottom);
    }];
    self.sendButton.cornerRadius = 24;
    
    
}
-(UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:THKColor_FFFFFF forState:UIControlStateNormal];
        _sendButton.backgroundColor = THKColor_MainColor;
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    }
    return _sendButton;
}

@end
