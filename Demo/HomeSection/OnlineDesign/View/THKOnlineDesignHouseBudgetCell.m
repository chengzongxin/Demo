//
//  THKOnlineDesignHouseBudgetCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignHouseBudgetCell.h"

@interface THKOnlineDesignHouseBudgetCell ()

@property (nonatomic, strong) UILabel *budgetLbl;

@end

@implementation THKOnlineDesignHouseBudgetCell

- (void)setupSubviews{
    [self.contentView addSubview:self.budgetLbl];
    
    [self.budgetLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}


- (void)bindWithModel:(NSString *)model{
    self.budgetLbl.text = model;
}

- (UILabel *)budgetLbl{
    if (!_budgetLbl) {
        _budgetLbl = [[UILabel alloc] init];
        _budgetLbl.font = UIFont(18);
        _budgetLbl.textColor = UIColorDark;
    }
    return _budgetLbl;
}

@end
