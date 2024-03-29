//
//  THKOnlineDesignHouseDemandCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignHouseDemandCell.h"
#import "THKOnlineDesignHouseDemandView.h"
#import "THKOnlineDesignModel.h"

@protocol THKSwipVoiceButtonDelegate <NSObject>
@optional
- (void)swipVoiceButtonOffset:(CGPoint)offset; //上移偏移量

@end
static CGFloat const kOffsetY = 50;
@interface THKSwipVoiceButton : TMUIButton
@property(nonatomic, weak) id<THKSwipVoiceButtonDelegate> delegate;
@property (nonatomic, assign) CGPoint offset;
@end

@implementation THKSwipVoiceButton

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint point = [touch locationInView:self];
    self.offset = point;
    if([self.delegate respondsToSelector:@selector(swipVoiceButtonOffset:)]) {
        [self.delegate swipVoiceButtonOffset:point];
    }
    return [super continueTrackingWithTouch:touch withEvent:event];
}


@end

@interface THKOnlineDesignHouseDemandCell ()<TMUITextViewDelegate,THKSwipVoiceButtonDelegate>

@property (nonatomic, strong) TMUITextView *textView;

@property (nonatomic, strong) THKOnlineDesignHouseDemandView *demandView;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) THKSwipVoiceButton *recordBtn;

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
    self.textView.text = model.text;
}

#pragma mark - CallBack Event

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

- (void)cancelRecordVoice:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(cancelRecordVoice:)]) {
        [self.delegate cancelRecordVoice:btn];
    }
}

- (void)upswipeCancelRecordVoice:(THKSwipVoiceButton *)btn{
    if (btn.offset.y < -kOffsetY) {
        if ([self.delegate respondsToSelector:@selector(upswipeCancelRecordVoice:)]) {
            [self.delegate upswipeCancelRecordVoice:btn];
        }
    }
}

- (void)downSwipeContinueRecordVoice:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(downSwipeContinueRecordVoice:)]) {
        [self.delegate downSwipeContinueRecordVoice:btn];
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


#pragma mark - Delegate

- (void)swipVoiceButtonOffset:(CGPoint)offset{
//    if (offset.y < -kOffsetY) {
//        [self upswipeCancelRecordVoice:self.recordBtn];
//    }
}

- (void)textViewDidChange:(TMUITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(demandInput:text:heightChange:height:indexPath:)]) {
        [self.delegate demandInput:textView text:textView.text heightChange:NO height:0 indexPath:self.indexPath];
    }
}

/**
 *  输入框高度发生变化时的回调，当实现了这个方法后，文字输入过程中就会不断去计算输入框新内容的高度，并通过这个方法通知到 delegate
 *  @note 只有当内容高度与当前输入框的高度不一致时才会调用到这里，所以无需在内部做高度是否变化的判断。
 */
- (void)textView:(TMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height{
    if ([self.delegate respondsToSelector:@selector(demandInput:text:heightChange:height:indexPath:)]) {
        [self.delegate demandInput:textView text:textView.text heightChange:YES height:height indexPath:self.indexPath];
    }
}


/**
 *  用户点击键盘的 return 按钮时的回调（return 按钮本质上是输入换行符“\n”）
 *  @return 返回 YES 表示程序认为当前的点击是为了进行类似“发送”之类的操作，所以最终“\n”并不会被输入到文本框里。返回 NO 表示程序认为当前的点击只是普通的输入，所以会继续询问 textView:shouldChangeTextInRange:replacementText: 方法，根据该方法的返回结果来决定是否要输入这个“\n”。
 *  @see maximumTextLength
 */
- (BOOL)textViewShouldReturn:(TMUITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

/**
 *  配合 `maximumTextLength` 属性使用，在输入文字超过限制时被调用（此时文字已被自动裁剪到符合最大长度要求）。
 *
 *  @param textView 触发的 textView
 *  @param range 要变化的文字的位置，length > 0 表示文字被自动裁剪前，输入框已有一段文字被选中。
 *  @param replacementText 要变化的文字
 */
- (void)textView:(TMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText{
//    if ([self.delegate respondsToSelector:@selector(demandInput:text:heightChange:height:indexPath:)]) {
//        [self.delegate demandInput:textView text:textView.text heightChange:YES height:height indexPath:self.indexPath];
//    }
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

- (THKSwipVoiceButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [[THKSwipVoiceButton alloc] init];
        _recordBtn.tmui_titleColor = UIColorDark;
        _recordBtn.tmui_font = UIFontSemibold(14);
        _recordBtn.tmui_text = @"按住说话";
        _recordBtn.tmui_image = UIImageMake(@"od_record_black");
        _recordBtn.spacingBetweenImageAndTitle = 6;
        _recordBtn.delegate = self;
        
        [_recordBtn addTarget:self action:@selector(recordBtnTouchDown:) forControlEvents:UIControlEventTouchDown]; //开始录音
        [_recordBtn addTarget:self action:@selector(recordBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside]; //录音结束
        [_recordBtn addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside]; //取消录音
        [_recordBtn addTarget:self action:@selector(upswipeCancelRecordVoice:) forControlEvents:UIControlEventTouchDragExit]; //向上滑动 提示松开取消录音
        [_recordBtn addTarget:self action:@selector(downSwipeContinueRecordVoice:) forControlEvents:UIControlEventTouchDragEnter]; //手指重新滑动到范围内 提示向上取消录音
        
    }
    return _recordBtn;
}


@end
