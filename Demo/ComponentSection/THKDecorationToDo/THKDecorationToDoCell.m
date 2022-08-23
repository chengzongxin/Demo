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

@property (nonatomic, strong) UILabel *descLbl;

@property (nonatomic, strong) UILabel *strategyLbl;

@property (nonatomic, strong) UILabel *serviceLbl;

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
    [self.containerView addSubview:self.descLbl];
    [self.containerView addSubview:self.strategyLbl];
    [self.containerView addSubview:self.serviceLbl];
    
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
        make.right.mas_lessThanOrEqualTo(-15);
        make.height.mas_equalTo(22);
    }];
    
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(1);
        make.left.equalTo(self.titleLbl);
        make.right.mas_lessThanOrEqualTo(-15);
    }];
    
    [self.strategyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15.5);
        make.left.equalTo(self.titleLbl);
        make.right.mas_lessThanOrEqualTo(-15);
    }];
    
    [self.serviceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15.5);
        make.left.equalTo(self.strategyLbl.mas_right).offset(15);
        make.right.mas_lessThanOrEqualTo(-15);
    }];
}

- (void)setModel:(THKDecorationUpcomingChildListModel *)model{
    _model = model;
    
    _titleLbl.attributedText = [self titleAttrStr:model.todoStatus];
    _descLbl.text = model.childDesc;
    _strategyLbl.attributedText = [self stringAppendIcon:model.strategyTitle icon:UIImageMake(@"dec_todo_arrow")];
    _serviceLbl.attributedText = [self stringAppendIcon:model.toolTitle icon:UIImageMake(@"dec_todo_arrow")];
    
    [self.serviceLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.strategyLbl.mas_right).offset(_strategyLbl.attributedText.length?15:0);
    }];
    
    [self selectCell];
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
    !_tapSelectBlock?:_tapSelectBlock(btn);
}


- (void)selectCell{
    
    BOOL realSelect = self.model.todoStatus;
    
    if (realSelect) {
        _selectBtn.tmui_image = UIImageMake(@"dec_todo_select");
        _titleLbl.textColor = UIColorTextPlaceholder;
    }else{
        _selectBtn.tmui_image = UIImageMake(@"dec_todo_unselect");
        _titleLbl.textColor = UIColorTextImportant;
    }
    
    _titleLbl.attributedText = [self titleAttrStr:realSelect];
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//
//    BOOL realSelect = self.model.todoStatus || selected;
//
//    if (realSelect) {
//        _selectBtn.tmui_image = UIImageMake(@"dec_todo_select");
//        _titleLbl.textColor = UIColorTextPlaceholder;
//    }else{
//        _selectBtn.tmui_image = UIImageMake(@"dec_todo_unselect");
//        _titleLbl.textColor = UIColorTextImportant;
//    }
//
//    _titleLbl.attributedText = [self titleAttrStr:realSelect];
//}

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

- (NSAttributedString *)stringAppendIcon:(NSString *)str icon:(UIImage *)icon{
    if (tmui_isNullString(str)) {
        return nil;
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    if (icon) {
        [attr appendAttributedString:[NSAttributedString tmui_attributedStringWithImage:icon baselineOffset:-3 leftMargin:0 rightMargin:0]];
    }
    return attr;
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
        _titleLbl.font = [UIFont fontWithName:@"DINAlternate-Bold" size:16];
    }
    return _titleLbl;
}

- (UILabel *)descLbl{
    if (!_descLbl) {
        _descLbl = [[UILabel alloc] init];
        _descLbl.textColor = UIColorTextPlaceholder;
        _descLbl.font = UIFont(12);
    }
    return _descLbl;
}

- (UILabel *)strategyLbl{
    if (!_strategyLbl) {
        _strategyLbl = [[UILabel alloc] init];
        _strategyLbl.textColor = UIColorGreen;
        _strategyLbl.font = UIFont(14);
        @weakify(self);
        [_strategyLbl tmui_addSingerTapWithBlock:^{
            @strongify(self);
            if (self.tapStragegyBlock) {
                self.tapStragegyBlock(self.strategyLbl);
            }
        }];
    }
    return _strategyLbl;
}

- (UILabel *)serviceLbl{
    if (!_serviceLbl) {
        _serviceLbl = [[UILabel alloc] init];
        _serviceLbl.textColor = UIColorGreen;
        _serviceLbl.font = UIFont(14);
        @weakify(self);
        [_serviceLbl tmui_addSingerTapWithBlock:^{
            @strongify(self);
            if (self.tapServiceBlock) {
                self.tapServiceBlock(self.serviceLbl);
            }
        }];
    }
    return _serviceLbl;
}



@end
