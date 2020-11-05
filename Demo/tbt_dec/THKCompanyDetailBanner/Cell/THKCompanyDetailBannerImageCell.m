//
//  THKCompanyDetailBannerImageCell.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "THKCompanyDetailBannerImageCell.h"
#import <SDWebImage.h>

@interface THKCompanyDetailBannerImageCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation THKCompanyDetailBannerImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setUrl:(NSString *)url{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:url]];
}


@synthesize url;

@end
