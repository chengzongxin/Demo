//
//  THKOnlineDesignHouseDemandCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignHouseDemandCell.h"
#import "THKOnlineDesignHouseDemandView.h"
#import "THKOnlineDesignModel.h"

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
        make.top.equalTo(self.textView.mas_bottom);
        make.left.right.equalTo(self.contentView).inset(15);
        make.height.mas_equalTo(0);
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

- (void)bindWithModel:(THKOnlineDesignItemDemandModel *)model{
    self.demandView.demands = model.demandDesc;
    if (model.demandDesc.count) {
        [self.demandView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(model.demandDesc.count * 32 + (model.demandDesc.count - 1) * 14);
        }];
    }else{
        [self.demandView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    
    self.textView.placeholder = model.demandPlacehoder;
}

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

- (void)recordPlayClick:(UIView *)view idx:(NSUInteger)idx indexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(recordPlayClick:idx:indexPath:)]) {
        [self.delegate recordPlayClick:view idx:idx indexPath:indexPath];
    }
}

- (void)recordCloseClick:(UIView *)view idx:(NSUInteger)idx indexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(recordCloseClick:idx:indexPath:)]) {
        [self.delegate recordCloseClick:view idx:idx indexPath:indexPath];
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
        @weakify(self);
        _demandView.clickPlayBlock = ^(UIView * _Nonnull view, NSUInteger idx) {
            @strongify(self);
            [self recordPlayClick:view idx:idx indexPath:self.indexPath];
        };
        _demandView.clickCloseBlock = ^(UIButton * _Nonnull btn, NSUInteger idx) {
            @strongify(self);
            [self recordCloseClick:btn idx:idx indexPath:self.indexPath];
        };
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
