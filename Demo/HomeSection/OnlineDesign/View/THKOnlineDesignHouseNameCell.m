//
//  THKOnlineDesignHouseNameCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignHouseNameCell.h"

@interface THKOnlineDesignHouseNameCell ()

@property (nonatomic, strong) UITextField *nameTF;

@end

@implementation THKOnlineDesignHouseNameCell

- (void)setupSubviews{
    [self.contentView addSubview:self.nameTF];
    
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)bindWithModel:(NSString *)model{
    self.nameTF.text = model;
}

- (UITextField *)nameTF{
    if (!_nameTF) {
        _nameTF = [[UITextField alloc] init];
        _nameTF.font = UIFont(18);
        _nameTF.placeholder = @"请输入小区名称";
        [_nameTF tmui_setPlaceholderColor:UIColorPlaceholder];
    }
    return _nameTF;
}

@end
