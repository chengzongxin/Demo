//
//  THKDecorationToDoCell.m
//  testTmuikit
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKDecorationToDoCell.h"

@interface THKDecorationToDoCell ()

@property (nonatomic, strong) TMUICustomCornerRadiusView *containerView;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *subtitleLbl;


@end

@implementation THKDecorationToDoCell

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

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}


- (void)setupSubviews{
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.line];
    [self.containerView addSubview:self.selectBtn];
    [self.containerView addSubview:self.titleLbl];
    [self.containerView addSubview:self.subtitleLbl];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(17);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectBtn);
        make.left.equalTo(self.selectBtn.mas_right).offset(8);
        make.height.mas_equalTo(22);
    }];
    
    [self.subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
        make.left.equalTo(self.titleLbl);
    }];
}

- (void)setModel:(THKDecorationUpcomingChildListModel *)model{
    _model = model;
    
    _titleLbl.attributedText = [self titleAttrStr:model.todoStatus];
    _subtitleLbl.text = model.strategyTitle;
}

//- (void)isFirstCell:(BOOL)isFirst{
//    if (isFirst) {
//        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(-12);
//        }];
//    }else{
//        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(0);
//        }];
//    }
//}

- (void)selectBtnClick:(UIButton *)btn{
    !_tapItem?:_tapItem(btn);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        _selectBtn.tmui_image = UIImageMake(@"dec_todo_select");
        _titleLbl.textColor = UIColorPlaceholder;
    }else{
        _selectBtn.tmui_image = UIImageMake(@"dec_todo_unselect");
        _titleLbl.textColor = UIColorTextImportant;
    }
    
    _titleLbl.attributedText = [self titleAttrStr:selected];
}

- (NSAttributedString *)titleAttrStr:(BOOL)selected{
    if (!self.model) {
        return nil;
    }
    NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:self.model.childName?:@""];
    if (selected) {
        [titleAttr tmui_setAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]];
    }
    return titleAttr;
}


- (TMUICustomCornerRadiusView *)containerView{
    if (!_containerView) {
        _containerView = [[TMUICustomCornerRadiusView alloc] init];
        _containerView.backgroundColor = UIColorWhite;
//        _containerView.customCornerRadius = TMUICustomCornerRadiusMake(12, 12, 12, 12);
    }
    return _containerView;
}


- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = UIColorHex(ECEEEC);
    }
    return _line;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        _selectBtn.tmui_image = UIImageMake(@"dec_todo_unselect");
        [_selectBtn tmui_addTarget:self action:@selector(selectBtnClick:)];
    }
    return _selectBtn;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorTextImportant;
        _titleLbl.font = [UIFont fontWithName:@"DINCondensed-Bold" size:16];
    }
    return _titleLbl;
}

- (UILabel *)subtitleLbl{
    if (!_subtitleLbl) {
        _subtitleLbl = [[UILabel alloc] init];
        _subtitleLbl.textColor = UIColorMain;
        _subtitleLbl.font = UIFont(14);
    }
    return _subtitleLbl;
}



@end
