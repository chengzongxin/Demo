//
//  THKOnlineDesignUploadHouseTypeView.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKOnlineDesignUploadHouseTypeView.h"

@interface THKOnlineDesignUploadHouseTypeView ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *actionLbl;

@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation THKOnlineDesignUploadHouseTypeView


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
    [self addSubview:self.arrow];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"已有户型图？上传我家户型图" attributes:@{NSFontAttributeName:UIFont(14)}];
    self.titleLbl.attributedText = attr;
    @weakify(self);
    [self.titleLbl tmui_clickAttrTextWithStrings:@[@"上传我家户型图"]
                                      attributes:@{NSFontAttributeName:UIFontMedium(14),NSForegroundColorAttributeName:UIColorGreen}
                                     clickAction:^(NSString * _Nonnull string, NSRange range, NSInteger index) {
//        NSLog(@"%@",string);
        @strongify(self);
        if (self.clickUploadBlock) {
            self.clickUploadBlock();
        }
    }];
    
    CGFloat width = [self.titleLbl.attributedText tmui_sizeForWidth:TMUI_SCREEN_WIDTH].width;
    CGFloat x = CGFloatGetCenter(TMUI_SCREEN_WIDTH, width);
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
        make.left.mas_equalTo(x);
        make.centerY.equalTo(self);
    }];
    
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_right).offset(4);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLbl;
}

- (UIImageView *)arrow{
    if (!_arrow) {
        _arrow = [[UIImageView alloc] initWithImage:UIImageMake(@"od_arrow_icon@3x")];
        @weakify(self);
        [_arrow tmui_addSingerTapWithBlock:^{
            @strongify(self);
            if (self.clickUploadBlock) {
                self.clickUploadBlock();
            }
        }];
    }
    return _arrow;
}

@end
