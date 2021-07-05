//
//  THKSearchAnimation+UI.m
//  HouseKeeper
//
//  Created by ben.gan on 2020/12/1.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKSearchAnimation+UI.h"

#define kCustomNavH  44.0
#define kSearchBarH  36.0
#define kOffset      16.0
#define kBtnW        45.0

@implementation THKSearchAnimation (UI)

+ (UIView *)navBkgView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, tmui_navigationBarHeight() - kCustomNavH, kScreenWidth, kCustomNavH)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

+ (THKSearchView *)searchView:(BOOL)highlighted {
    THKSearchView *searchView = [THKSearchView searchViewWithHomeStyle];
    if (highlighted) {
        searchView.searchLabel.textColor = THKColor_TextImportantColor;
    } else {
        searchView.searchLabel.textColor = THKColor_999999;
    }
    [searchView.searchLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if([[UIDevice currentDevice].systemVersion doubleValue] < 14.0){
            make.centerY.equalTo(searchView).offset(-0.666);
        }
    }];
    return searchView;
}

+ (TMSearchBar *)searchBar {
    //kTNavigationBarHeight() - kCustomNavH +
    TMSearchBar *searchBar = [[TMSearchBar alloc] initWithFrame:CGRectMake(kOffset,  (kCustomNavH - kSearchBarH) * 0.5, kScreenWidth - kOffset * 2 - kBtnW, kSearchBarH)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.textField.returnKeyType = UIReturnKeySearch;
    searchBar.textField.tintColor = kTo8toGreen;
    searchBar.textField.backgroundColor = [UIColor whiteColor];
    searchBar.clipsToBounds = YES;
    searchBar.layer.borderColor = [[UIColor colorWithHexString:@"e9e9e9"] colorWithAlphaComponent:1].CGColor;
    searchBar.layer.borderWidth = 2;
    searchBar.font = [UIFont systemFontOfSize:14];
    searchBar.textColor = THKColor_TextImportantColor;
    searchBar.placeholderColor = THKColor_999999;
    searchBar.layer.cornerRadius = 18;
    searchBar.textField.clearButtonMode = UITextFieldViewModeNever;
    searchBar.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12);
    for (UIView *v in searchBar.textField.subviews) {
        for (UIView *v_ in v.subviews) {
            if ([v_ isKindOfClass:[UIImageView class]]) {
                ((UIImageView *)v_).image = [UIImage imageNamed:@"icon_search_left"];
                [v_ mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.centerY.equalTo(@(0));
                    make.size.mas_equalTo(v_.bounds.size);
                }];
                [v_.superview layoutIfNeeded];
                break;
            }
        }
    }
    return searchBar;
}

+ (UIButton *)cancelBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button setTitleColor:THKColor_TextImportantColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(kScreenWidth - kBtnW - kOffset, 0, kBtnW, kCustomNavH);
    return button;
}

+ (UIButton *)backBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:kImgAtBundle(@"nav_back_black") forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(0, 0, kBtnW + kOffset, kCustomNavH);
    return button;
}

@end
