//
//  THKMyHomeDesignDemandsBaseCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/16.
//

#import "THKMyHomeDesignDemandsBaseCell.h"

@interface THKMyHomeDesignDemandsBaseCell ()

@end

@implementation THKMyHomeDesignDemandsBaseCell

+ (CGFloat)cellHeightWithModel:(THKMyHomeDesignDemandsModel *)model{
    return 0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}


- (void)setupSubviews{}

@end
