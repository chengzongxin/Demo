//
//  THKComponentView.m
//  HouseKeeper
//
//  Created by ben.gan on 2021/4/30.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKComponentView.h"

@interface THKComponentView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation THKComponentView

- (instancetype)init {
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = _THKColorWithHexString(@"f5f7fa");
//    self.alpha = 0.7;
    self.layer.cornerRadius = 3;
//    [self.layer addSublayer:self.gradientLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.gradientLayer.bounds =
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [[CAGradientLayer alloc] init];
    }
    return _gradientLayer;
}

@end
