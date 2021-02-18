//
//  THKAuthenticationView.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//


#import "THKIdentityView.h"

@interface THKIdentityView ()
/// 图标
@property (nonatomic, strong) UIImageView *iconImageView;
/// 文本
@property (nonatomic, strong) UILabel *textLabel;

@end


@implementation THKIdentityView
@dynamic viewModel;
#pragma mark - Life Cycle
- (void)dealloc{
    NSLog(@"THKIdentityView dealloc");
}

/// xib创建
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (!self) return nil;
    
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)addGesture{
    // 先清理所有手势
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }
    // 添加手势
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap.rac_gestureSignal subscribe:self.viewModel.onTapSubject];
    [self addGestureRecognizer:tap];
}

#pragma mark - Public
// initWithModel 和 bindViewModel: 方法来到这里
// MARK: 刷新数据和UI，初始化，xib，重新设置Type时调用
- (void)bindViewModel{
    if (self.viewModel.fetchConfigSuccess) {
        [self addGesture];
        
        [self updateData];
        
        [self updateUI];
    }else{
        // 需要清理内部约束，否则计算出来的size不准确
        [self clear];
    }
    
    [self invalidateIntrinsicContentSize];
}

- (void)clear{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }
    
    if (_iconImageView.superview) {
        [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeZero);
        }];
    }
    
    if (_textLabel.superview || self.viewModel.style == THKIdentityStyle_IconText) {
        _textLabel.text = nil;
        _textLabel.attributedText = nil;
        [_textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right);
            make.right.equalTo(self);
            make.centerY.equalTo(self.iconImageView.mas_centerY);
        }];
    }
    
}

- (void)updateData{
    if (self.viewModel.iconUrl) {
        [self.iconImageView loadImageWithUrlStr:self.viewModel.iconUrl placeHolderImage:self.viewModel.iconLocal];
    }else{
        self.iconImageView.image = self.viewModel.iconLocal;
    }
    
    if (self.viewModel.style == THKIdentityStyle_IconText) {
        self.textLabel.text = self.viewModel.text;
        self.textLabel.textColor = self.viewModel.textColor;
        self.textLabel.font = self.viewModel.font;
    }
}

- (void)updateUI{
    if (!self.iconImageView.superview) {
        [self addSubview:self.iconImageView];
    }
    
    if (self.viewModel.style == THKIdentityStyle_IconText) {
        self.backgroundColor = self.viewModel.backgroundColor;
        self.layer.cornerRadius = (self.viewModel.iconSize.height + self.viewModel.imageEdgeInsets.top + self.viewModel.imageEdgeInsets.bottom)/2;
        // 一开始是Icon,后来改成Full形式，需要添加
        if (!self.textLabel.superview) {
            [self addSubview:self.textLabel];
        }
        
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(self.viewModel.imageEdgeInsets.left + self.viewModel.contentOffset.x);
            make.centerY.equalTo(self.mas_centerY).offset(self.viewModel.contentOffset.y);
            make.size.mas_equalTo(self.viewModel.iconSize);
        }];
        
        [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(self.viewModel.imageTextSpace);
            make.right.equalTo(self).inset(self.viewModel.imageEdgeInsets.left).priorityHigh();
            make.centerY.equalTo(self.iconImageView.mas_centerY);
        }];
        
    }else{
        
        self.backgroundColor = UIColor.clearColor;
        self.layer.cornerRadius = 0;
        
        if (_textLabel) {
            [_textLabel removeFromSuperview];
            _textLabel = nil;
        }
        
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.equalTo(self);
        }];
    }
}

#pragma mark - Private
///  完整显示文字时，需要做Size计算处理自适应宽度
- (CGSize)intrinsicContentSize{
    // 只有图标的时候,直接返回icon尺寸
    if (self.viewModel.fetchConfigSuccess == NO) {
        return CGSizeZero;
    }
    
    if (!self.viewModel.iconLocal && !self.viewModel.iconUrl) {
        return CGSizeZero;
    }
    
    if (self.viewModel.style == THKIdentityStyle_Icon) {
        return self.frame.size;
    }
    
    // 完整显示的时候，计算图标和文本宽高
    CGFloat iconW = self.viewModel.iconSize.width;
    CGFloat iconH = self.viewModel.iconSize.height;
    //计算文本尺寸
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:_textLabel.attributedText];
    CGFloat textW = layout.textBoundingSize.width;
    
    CGFloat sizeH = iconH + self.viewModel.imageEdgeInsets.top + self.viewModel.imageEdgeInsets.bottom;
    CGFloat sizeW = self.viewModel.imageEdgeInsets.left + iconW + self.viewModel.imageTextSpace + textW + self.viewModel.imageEdgeInsets.right;
    
    return CGSizeMake(sizeW, sizeH);
}

#pragma mark - Getter && Setter

- (CGSize)viewSize{
    [self layoutIfNeeded];
    
    if (self.width*self.height > self.intrinsicContentSize.width*self.intrinsicContentSize.height) {
        return self.size;
    }else{
        return self.intrinsicContentSize;
    }
}


- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
    }
    return _textLabel;
}


@end
