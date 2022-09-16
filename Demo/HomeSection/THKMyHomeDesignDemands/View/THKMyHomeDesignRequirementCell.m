//
//  THKMyHomeDesignRequirementCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/16.
//

#import "THKMyHomeDesignRequirementCell.h"

@interface THKMyHomeDesignRequirementCell () <TMUITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) TMUITextView *textView;

@end

@implementation THKMyHomeDesignRequirementCell
@synthesize delegate = _delegate;
@synthesize model = _model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.textView];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
//        make.centerY.equalTo(self.contentView);
        make.top.mas_equalTo(20);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(16);
        make.left.right.equalTo(self.contentView).inset(16);
        make.height.mas_equalTo(84);
    }];
}

+ (CGFloat)cellHeightWithModel:(THKMyHomeDesignDemandsModel *)model{
    return 200;
}

- (void)bindWithModel:(THKMyHomeDesignDemandsModel *)model{
    self.model = model;
    
    self.titleLbl.text = model.title;
    self.textView.text = model.content;
}

- (void)textViewDidChange:(TMUITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(editCell:type:model:data:)]) {
        [self.delegate editCell:self type:self.model.type model:self.model data:textView.text];
    }
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorDark;
        _titleLbl.font = UIFont(16);
        _titleLbl.text = @"小区名称";
    }
    return _titleLbl;
}

- (TMUITextView *)textView{
    if (!_textView) {
        _textView = [[TMUITextView alloc] init];
        _textView.backgroundColor = UIColorBackgroundLight;
        _textView.delegate = self;
        _textView.placeholder = @"待补充";
        _textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _textView.placeholderMargins = UIEdgeInsetsMake(-2, 0, 0, 0);
        _textView.font = UIFont(14);
        _textView.placeholderColor = UIColorPlaceholder;
        _textView.maximumTextLength = 500;
        _textView.cornerRadius = 8;
    }
    return _textView;
}

@end
