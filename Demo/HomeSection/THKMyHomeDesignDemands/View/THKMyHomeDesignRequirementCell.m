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

@property (nonatomic, strong) THKMyHomeDesignDemandsModel *model;

@end

@implementation THKMyHomeDesignRequirementCell


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
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(16);
        make.left.right.equalTo(self.contentView).inset(16);
        make.height.mas_equalTo(84);
    }];
}


- (void)bindWithModel:(THKMyHomeDesignDemandsModel *)model{
    self.model = model;
    
    self.titleLbl.text = model.title;
    self.textView.text = model.content;
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
        _textView.backgroundColor = UIColorClear;
        _textView.delegate = self;
        _textView.placeholder = @"描述一下我家设计需求，例如学习习惯、个人偏好等，方便设计师更好出设计方案";
        _textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _textView.placeholderMargins = UIEdgeInsetsMake(-2, 0, 0, 0);
        _textView.font = UIFont(14);
        _textView.placeholderColor = UIColorPlaceholder;
        _textView.maximumTextLength = 500;
    }
    return _textView;
}

@end
