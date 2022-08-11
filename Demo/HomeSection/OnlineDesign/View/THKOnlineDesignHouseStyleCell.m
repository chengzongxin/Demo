//
//  THKOnlineDesignHouseStyleCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignHouseStyleCell.h"

@interface THKOnlineDesignHouseStyleCell ()

@property (nonatomic, strong) UILabel *styleLbl;

@end

@implementation THKOnlineDesignHouseStyleCell

- (void)setupSubviews{
    [self.contentView addSubview:self.styleLbl];
    
    [self.styleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}


- (void)bindWithModel:(NSString *)model{
    self.styleLbl.text = model;
}


- (UILabel *)styleLbl{
    if (!_styleLbl) {
        _styleLbl = [[UILabel alloc] init];
        _styleLbl.font = UIFont(18);
        _styleLbl.textColor = UIColorDark;
    }
    return _styleLbl;
}


@end
