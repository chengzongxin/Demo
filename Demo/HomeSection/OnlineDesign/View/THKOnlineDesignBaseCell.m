//
//  THKOnlineDesignCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignBaseCell.h"

@implementation THKOnlineDesignBaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{}

- (void)bindWithModel:(id)model{}

@end
