//
//  THKAvatarView.m
//
//
//  Created by Joe.cheng on 2021/2/5.
//

#import "THKAvatarView.h"

@interface THKAvatarView()
@property (nonatomic, strong) THKAvatarViewModel *viewModel;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) THKIdentityView *identityView;
@end

@implementation THKAvatarView
@dynamic viewModel;
@synthesize avatarImgView = _avatarImgView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupViews];
}

#pragma mark - ui layout
- (void)setupViews {
    // 初始化设置自身
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tap];
    // 初始化设置头像
    [self addSubview:self.avatarImgView];
    [_avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
     // 初始化设置标识
    [self addSubview:self.identityView];
    [_identityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 不剪切子视图
    self.clipsToBounds = NO;
    // 设置圆角
    float minWH = MIN(self.bounds.size.width, self.bounds.size.height);
    self.avatarImgView.layer.cornerRadius = minWH/2;
    // 头像
    [_avatarImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(minWH, minWH));
    }];
    // 标识
    if (_identityView.superview) {
        CGSize iconSize = self.viewModel.identityIconSize;
        if (iconSize.width == 0 || iconSize.height == 0) {
            // 默认取3.6倍
            iconSize = CGSizeMake(minWH/self.viewModel.identityRatio, minWH/self.viewModel.identityRatio);
        }
        [_identityView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.viewModel.identityIconCenterOffset.y);
            make.right.mas_equalTo(self.viewModel.identityIconCenterOffset.x);
            make.size.mas_equalTo(iconSize);
        }];
    }
}


/// MARK: 外部调用 -[view bindViewModel:vm] 后会调用这个方法，在这里设置数据 & 刷新UI
- (void)bindViewModel{
    [self.avatarImgView loadImageWithUrlStr:self.viewModel.avatarUrl placeHolderImage:self.viewModel.placeHolderImage ?: kDefaultHeadPortrait_60];
    
    if (self.viewModel.isHiddenIdentity) {
        self.identityView.hidden = YES;
    }else{
        self.identityView.hidden = NO;
        THKIdentityViewModel *vm = [[THKIdentityViewModel alloc] initWithType:self.viewModel.identityType subType:self.viewModel.identitySubType style:THKIdentityStyle_Icon];
        [_identityView bindViewModel:vm];
    }
}

#pragma mark - inner logics

- (void)tapView {
    if (self.viewModel.onTapSubject) {
        [self.viewModel.onTapSubject sendNext:self];
    }
}

#pragma mark - getters

- (UIImageView *)avatarImgView{
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc] init];
        _avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImgView.clipsToBounds = YES;
    }
    return _avatarImgView;
}

- (THKIdentityView *)identityView{
    if (!_identityView) {
        _identityView = [[THKIdentityView alloc] init];
    }
    return _identityView;
}

@end
