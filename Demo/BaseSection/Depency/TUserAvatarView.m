//
//  TUserAvatarView.m
//  UIComponentSamples
//
//  Created by nigel.ning on 2019/2/20.
//  Copyright © 2019 t8t. All rights reserved.
//

#import "TUserAvatarView.h"

@interface TUserAvatarView()
@property (nonatomic, strong)UIImageView *avatarImgView;
@property (nonatomic, strong)UIImageView *identityIconView;
@property (nonatomic, strong)UIControl *tapBtn;
@end

@implementation TUserAvatarView
@synthesize avatarImgView = _avatarImgView;
@synthesize identityIconView = _identityIconView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _identityIconSize = CGSizeMake(10, 10);
        _identityIconCenterOffset = CGPointZero;
        [self loadUIs];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _identityIconSize = CGSizeMake(10, 10);
        _identityIconCenterOffset = CGPointZero;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadUIs];
}

#pragma mark - ui layout
- (void)loadUIs {
    self.backgroundColor = [UIColor clearColor];
    float minV = MIN(self.bounds.size.width, self.bounds.size.height);
    CGRect rt = CGRectMake((self.bounds.size.width - minV)/2, (self.bounds.size.height - minV)/2, minV, minV);
    self.avatarImgView = [[UIImageView alloc] initWithFrame:rt];
    self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImgView.clipsToBounds = YES;
    self.avatarImgView.layer.cornerRadius = minV/2;
    [self addSubview:self.avatarImgView];        
    
    self.tapBtn = [[UIControl alloc] initWithFrame:self.bounds];
    [self.tapBtn addTarget:self action:@selector(tapBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.tapBtn];
    self.tapBtn.enabled = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.clipsToBounds = NO;
    
    float minV = MIN(self.bounds.size.width, self.bounds.size.height);
    self.avatarImgView.frame = CGRectMake((self.bounds.size.width - minV)/2, (self.bounds.size.height - minV)/2, minV, minV);
    self.avatarImgView.layer.cornerRadius = minV/2;
    
    self.tapBtn.frame = self.bounds;
    
    [self reLayoutIconView];
}

- (void)reLayoutIconView {
    if (_identityIconView) {
        _identityIconView.frame = [self iconCorrectRect];
    }
}

- (CGRect)iconCorrectRect {
    float radius = self.avatarImgView.bounds.size.width/2;
    CGPoint showCenter = CGPointMake(radius / sqrt(2), radius / sqrt(2));
    showCenter.x += CGRectGetMidX(self.avatarImgView.frame);
    showCenter.y += CGRectGetMidY(self.avatarImgView.frame);
    
    showCenter.x += self.identityIconCenterOffset.x;
    showCenter.y += self.identityIconCenterOffset.y;
    
    return CGRectMake(showCenter.x - self.identityIconSize.width/2, showCenter.y - self.identityIconSize.height/2, self.identityIconSize.width, self.identityIconSize.height);
}

#pragma mark - inner logics

- (void)tapBtnClick {
    if (self.onTap) {
        self.onTap(self);
    }
}

#pragma mark - getters

- (UIImageView *)identityIconView {
    if (!_identityIconView) {
        _identityIconView = [[UIImageView alloc] initWithFrame:[self iconCorrectRect]];
        _identityIconView.clipsToBounds = YES;
        [self insertSubview:_identityIconView aboveSubview:self.avatarImgView];
    }
    return _identityIconView;
}

#pragma mark - setters
- (void)setIdentityIconSize:(CGSize)identityIconSize {
    _identityIconSize = identityIconSize;
    [self reLayoutIconView];
}

- (void)setIdentityIconCenterOffset:(CGPoint)identityIconCenterOffset {
    _identityIconCenterOffset = identityIconCenterOffset;
    [self reLayoutIconView];
}

- (void)setOnTap:(void (^)(__kindof TUserAvatarView * _Nonnull))onTap {
    _onTap = onTap;
    if (_onTap) {
        self.tapBtn.enabled = YES;
    }else {
        self.tapBtn.enabled = NO;
    }
}

@end
