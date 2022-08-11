//
//  THKOnlineDesignHouseTypeCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignHouseTypeCell.h"

@interface THKOnlineDesignHouseTypeCell ()

@property (nonatomic, strong) UIImageView *picImgV;

@end

@implementation THKOnlineDesignHouseTypeCell

- (void)setupSubviews{
    [self.contentView addSubview:self.picImgV];
    
    [self.picImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)bindWithModel:(NSString *)model{
    [self.picImgV loadImageWithUrlStr:model];
}

- (UIImageView *)picImgV{
    if (!_picImgV) {
        _picImgV = [[UIImageView alloc] init];
    }
    return _picImgV;
}

@end
