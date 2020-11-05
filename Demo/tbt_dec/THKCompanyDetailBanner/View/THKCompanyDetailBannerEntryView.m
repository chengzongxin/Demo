//
//  THKCompanyDetailBannerEntryView.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "THKCompanyDetailBannerEntryView.h"
#import "UIImage+TCategory.h"

@implementation THKCompanyDetailBannerEntryView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = UIColorHexString(@"24242A");
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UIImageView *videoImgV = [[UIImageView alloc] initWithImage:kImgAtBundle(@"CompanyDetailBanner_video")];
    UIImageView *imageImgV = [[UIImageView alloc] initWithImage:kImgAtBundle(@"CompanyDetailBanner_img")];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"视频和图片";
    label.textColor = UIColor.whiteColor;
    label.font = UIFont(10);
    label.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:videoImgV];
    [self addSubview:imageImgV];
    [self addSubview:label];
    
    [videoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [imageImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(videoImgV.mas_right).offset(2);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).inset(8);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

- (void)bindViewModel{
    NSLog(@"entry %@",self.viewModel);
}



@end
