//
//  THKReferenPictureListCell.m
//  Demo
//
//  Created by Joe.cheng on 2023/7/6.
//

#import "THKReferenPictureListCell.h"

@interface THKReferenPictureListCell ()

@property (nonatomic, strong, readwrite) UIImageView *coverImgView;

@end

@implementation THKReferenPictureListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.coverImgView];
    
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}


- (UIImageView *)coverImgView{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImgView;
}


@end
