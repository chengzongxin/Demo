//
//  THKOnlineDesignUploadHouseHeader.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKOnlineDesignUploadHouseHeader.h"

@interface THKOnlineDesignUploadHouseHeader ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *subtitleLbl;
// THKChoosePhotoView 替换日记选择图片
@property (nonatomic, strong) UIView *choosePhotoListView;

@end

@implementation THKOnlineDesignUploadHouseHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self addSubview:self.titleLbl];
    [self addSubview:self.subtitleLbl];
    [self addSubview:self.choosePhotoListView];
    self.choosePhotoListView.backgroundColor = UIColor.tmui_randomColor;
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(20);
    }];
    
    
    [self.subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(6);
        make.left.mas_equalTo(20);
    }];
    
    [self.choosePhotoListView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.subtitleLbl.mas_bottom).offset(15);
        make.height.equalTo(@(0));
    }];
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorDark;
        _titleLbl.font = UIFontMedium(18);
        _titleLbl.text = @"上传我家户型图";
        [_titleLbl tmui_setAttributesString:@"（选填）" color:UIColorPlaceholder font:UIFont(12)];
    }
    return _titleLbl;
}

- (UILabel *)subtitleLbl{
    if (!_subtitleLbl) {
        _subtitleLbl = [[UILabel alloc] init];
        _subtitleLbl.textColor = UIColorPlaceholder;
        _subtitleLbl.font = UIFont(14);
        _subtitleLbl.text = @"上传户型图设计师更快出方案";
    }
    return _subtitleLbl;
}


TMUI_PropertyLazyLoad(UIView, choosePhotoListView);
/*
- (THKChoosePhotoView *)choosePhotoListView {
    if (!_choosePhotoListView) {
        _choosePhotoListView = [[THKChoosePhotoView alloc] init];
        _choosePhotoListView.canMove = YES;
        THKEditPhotoLayout *layout = [[THKEditPhotoLayout alloc] init];
        layout.row = 3;
        layout.offset = 8;
        layout.showDelBtn = YES;
        [_choosePhotoListView setWithLayout:layout];
//        //图片查看View-高度变化
//        @weakify(self);
//        [[[RACObserve(_choosePhotoListView, viewHeight) ignore:nil] distinctUntilChanged] subscribeNext:^(NSNumber   *value) {
//            @strongify(self);
//            CGFloat height = [value floatValue];
//            NSLog(@"高度变化:%f",height);
//            [self.choosePhotoListView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(@(height));
//            }];
//            _choosePhotoListView.height = height;
//            self.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth,kDiaDecStageViewHeight + [self textViewHeight] + [self headerOtherViewHeight] + height);
//            [self.tableView setTableHeaderView:self.tableHeaderView];
//        }];
    }
    
    return _choosePhotoListView;
}
*/


@end
