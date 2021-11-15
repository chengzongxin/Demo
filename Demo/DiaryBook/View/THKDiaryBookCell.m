//
//  THKDiaryBookCell.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/24.
//

#import "THKDiaryBookCell.h"
#import "THKDiaryCircleView.h"

const UIEdgeInsets kDiaryContentInset = {0,36,0,20};

@interface THKDiaryBookCell ()
@property (nonatomic, strong) THKDiaryBookCellVM *viewModel;
@property (nonatomic, strong) THKDiaryCircleView *circleView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *imagesView;
@property (nonatomic, strong) UILabel *interactiveBar;


@end

@implementation THKDiaryBookCell
//@dynamic viewModel;

- (void)prepareForReuse{
    [super prepareForReuse];
 
    self.contentLabel.text = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

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
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.circleView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.interactiveBar];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView.mas_centerX);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(2);
    }];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(THKDiaryCircleWidth);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kDiaryContentInset.left);
        make.right.mas_equalTo(-kDiaryContentInset.right);
    }];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(kDiaryContentInset.left);
        make.right.mas_equalTo(-kDiaryContentInset.right);
        make.height.mas_equalTo(0);
    }];
    
    [self.interactiveBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imagesView.mas_bottom);
        make.left.mas_equalTo(kDiaryContentInset.left);
        make.right.mas_equalTo(-kDiaryContentInset.right);
        make.height.mas_equalTo(50);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindViewModel:(THKDiaryBookCellVM *)viewModel{
    self.viewModel = viewModel;
    
//    self.contentLabel.text = viewModel.model;
//    self.contentLabel.attributedText = [NSAttributedString tmui_attributedStringWithString:viewModel.model lineSpacing:10];
    [self.contentLabel tmui_setAttributesString:viewModel.model lineSpacing:0];
//    self.contentLabel.text = viewModel.model;
}

- (CGSize)sizeThatFits:(CGSize)size{
    if (self.contentLabel.text.length == 0) {
        return CGSizeZero;
    }
    CGSize resultSize = CGSizeMake(size.width, 0);
    CGFloat contentLabelWidth = size.width - UIEdgeInsetsGetHorizontalValue(kDiaryContentInset);
    
    CGFloat contentHeight = [self.contentLabel tmui_sizeForWidth:contentLabelWidth].height;
    
    resultSize.height = contentHeight + 50;
    
    return resultSize;
}

- (THKDiaryCircleView *)circleView{
    if (!_circleView) {
        _circleView = [[THKDiaryCircleView alloc] init];
        _circleView.type = THKDiaryCircleType_Row;
    }
    return _circleView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorHex(ECEEEC);
    }
    return _lineView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = UIColorHex(010101);
        _contentLabel.font = UIFont(16);
    }
    return _contentLabel;
}

- (UIView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIView alloc] init];
        _imagesView.backgroundColor = UIColor.tmui_randomColor;
    }
    return _imagesView;
}

- (UILabel *)interactiveBar{
    if (!_interactiveBar) {
        _interactiveBar = [[UILabel alloc] init];
//        _interactiveBar.backgroundColor = UIColor.tmui_randomColor;
    }
    return _interactiveBar;
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    self.interactiveBar.text = @(indexPath.row).stringValue;
}

@end
