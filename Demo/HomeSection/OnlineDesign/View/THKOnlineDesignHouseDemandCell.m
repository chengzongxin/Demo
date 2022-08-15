//
//  THKOnlineDesignHouseDemandCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignHouseDemandCell.h"
#import "THKOnlineDesignHouseDemandView.h"
@interface THKOnlineDesignHouseDemandCell ()<TMUITextViewDelegate>

@property (nonatomic, strong) TMUITextView *textView;

@property (nonatomic, strong) THKOnlineDesignHouseDemandView *demandView;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) TMUIButton *recordBtn;

@end

@implementation THKOnlineDesignHouseDemandCell

- (void)setupSubviews{
    self.contentView.backgroundColor = UIColorWhite;
    self.contentView.cornerRadius = 8;
    
    [self.contentView addSubview:self.textView];
    
    [self.contentView addSubview:self.demandView];
    
    [self.contentView addSubview:self.line];
    
    [self.contentView addSubview:self.recordBtn];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(95);
    }];
    
    [self.demandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(5);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).inset(64);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(-48);
    }];
    
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
}

- (void)bindWithModel:(NSArray *)model{
    self.demandView.demands = model;
}

//- (void)clickRecordBtn:(UIButton *)btn{
//    if ([self.delegate respondsToSelector:@selector(clickRecordBtn:)]) {
//        [self.delegate clickRecordBtn:btn];
//    }
//}

- (void)recordBtnTouchDown:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(recordBtnTouchDown:)]) {
        [self.delegate recordBtnTouchDown:btn];
    }
}

- (void)recordBtnTouchUp:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(recordBtnTouchUp:)]) {
        [self.delegate recordBtnTouchUp:btn];
    }
}

- (TMUITextView *)textView{
    if (!_textView) {
        _textView = [[TMUITextView alloc] init];
        _textView.delegate = self;
        _textView.placeholder = @"描述一下我家设计需求，例如学习习惯、个人偏好等，方便设计师更好出设计方案";
        _textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _textView.font = UIFont(14);
        _textView.placeholderColor = UIColorPlaceholder;
    }
    return _textView;
}

- (THKOnlineDesignHouseDemandView *)demandView{
    if (!_demandView) {
        _demandView = [[THKOnlineDesignHouseDemandView alloc] init];
    }
    return _demandView;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = UIColorSeparator;
    }
    return _line;
}

- (TMUIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [TMUIButton tmui_button];
        _recordBtn.tmui_titleColor = UIColorDark;
        _recordBtn.tmui_font = UIFontSemibold(14);
        _recordBtn.tmui_text = @"按住说话";
        _recordBtn.tmui_image = UIImageMake(@"od_record_black");
        _recordBtn.spacingBetweenImageAndTitle = 6;
        [_recordBtn addTarget:self action:@selector(recordBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(recordBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtn addTarget:self action:@selector(recordBtnTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
        
    }
    return _recordBtn;
}


@end
