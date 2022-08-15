//
//  THKOnlineDesignSectionHeader.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignSectionHeader.h"

@interface THKOnlineDesignSectionHeader ()

@property (nonatomic, strong) UILabel *numLbl;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *selectLbl;

@property (nonatomic, strong) UIButton *editBtn;

@end



@implementation THKOnlineDesignSectionHeader


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    [self addSubview:self.numLbl];
    [self addSubview:self.titleLbl];
    [self addSubview:self.selectLbl];
    [self addSubview:self.editBtn];
    
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.numLbl.mas_right).offset(4);
    }];
    
    [self.selectLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-65);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-40);
    }];
}

- (void)setSelectString:(NSString *)selectString{
    _selectString = selectString;
    
    if (tmui_isNullString(selectString)) {
        self.selectLbl.text = nil;
        self.editBtn.hidden = YES;
    }else{
        self.selectLbl.text = selectString;
        self.editBtn.hidden = NO;
    }
}

- (UILabel *)numLbl{
    if (!_numLbl) {
        _numLbl = [UILabel new];
        _numLbl.font = UIFontDINAlt(9);
        _numLbl.textColor = UIColorWhite;
        _numLbl.backgroundColor = UIColorDark;
        _numLbl.cornerRadius = 7;
        _numLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _numLbl;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = UIFont(14);
        _titleLbl.textColor = UIColorDark;
    }
    return _titleLbl;
}

- (UILabel *)selectLbl{
    if (!_selectLbl) {
        _selectLbl = [UILabel new];
        _selectLbl.font = UIFontSemibold(14);
        _selectLbl.textColor = UIColorDark;
    }
    return _selectLbl;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton tmui_button];
        _editBtn.tmui_image = UIImageMake(@"od_house_edit");
        @weakify(self);
        [_editBtn tmui_addActionBlock:^(NSInteger tag) {
            @strongify(self);
            if (self.editBlock) {
                self.editBlock(self.editBtn);
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

@end
