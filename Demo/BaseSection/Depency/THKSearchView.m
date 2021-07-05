//
//  THKSearchView.m
//  HouseKeeper
//
//  Created by 荀青锋 on 2019/11/12.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKSearchView.h"

@interface THKSearchView ()

@property (nonatomic, strong) UIImageView *searchIcon;
@property (nonatomic, strong) UILabel *searchLabel;

@end

@implementation THKSearchView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self thk_setupViews];
    }
    return self;
}

- (void)thk_setupViews {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.searchIcon];
    [self addSubview:self.searchLabel];
    
    [self setupViewConstraints];
}

#pragma mark - Constraints

- (void)setupViewConstraints {
        
    [self.searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.0);
        make.width.height.equalTo(@(16.0));
        make.centerY.equalTo(self);
    }];
    
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchIcon.mas_right).offset(8.0); 
        make.right.lessThanOrEqualTo(self);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - lazy

- (UIImageView *)searchIcon {
    
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc] init];
        _searchIcon.backgroundColor = [UIColor clearColor];
        _searchIcon.image = kImgAtBundle(@"icon_search_left");
    }
    
    return _searchIcon;
}

- (UILabel *)searchLabel {
    
    if (!_searchLabel) {
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.backgroundColor = [UIColor clearColor];
        _searchLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
        _searchLabel.textColor = THKColor_999999;
    }
    
    return _searchLabel;
}


+(instancetype)searchViewWithHomeStyle{
    THKSearchView *searchView = [[THKSearchView alloc] init];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 18.0;
    searchView.layer.borderWidth = 2.0;
    searchView.layer.borderColor = [[UIColor colorWithHexString:@"E9E9E9"] colorWithAlphaComponent:1].CGColor;
    searchView.clipsToBounds = YES;
    return searchView;     
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
