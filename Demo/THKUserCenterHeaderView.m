//
//  THKUserCenterHeaderView.m
//  Demo
//
//  Created by Joe.cheng on 2020/12/1.
//

#import "THKUserCenterHeaderView.h"
#import "UIButton+Convenient.h"

@interface THKUserCenterHeaderView ()

@property (nonatomic, strong, readwrite) THKUserCenterHeaderViewModel *viewModel;
/// 背景主图
@property (nonatomic, strong) UIImageView *bgImageView;
/// 头像
@property (nonatomic, strong) UIImageView *avatarImageView;
/// 名字
@property (nonatomic, strong) UILabel *nameLabel;
/// 设计机构
@property (nonatomic, strong) UIButton *tagButton;
/// 问号提示
@property (nonatomic, strong) UIButton *tipsButton;
/// 关注按钮
@property (nonatomic, strong) UIButton *followButton;
/// 用户签名
@property (nonatomic, strong) UILabel *signatureLabel;
/// 关注数量
@property (nonatomic, strong) UIButton *followCountButton;
/// 粉丝数量
@property (nonatomic, strong) UIButton *fansCountButton;
/// 获赞和收藏
@property (nonatomic, strong) UIButton *beFollowCountButton;
/// TA的店铺
@property (nonatomic, strong) UIButton *storeButton;
/// 生态大会
@property (nonatomic, strong) UIImageView *ecologicalView;
/// 服务信息
@property (nonatomic, strong) UIView *serviceInfoView;

@end

@implementation THKUserCenterHeaderView
TMUI_PropertySyntheSize(viewModel);

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)
- (void)thk_setupViews {
    self.backgroundColor = UIColor.grayColor;
    [self addSubview:self.bgImageView];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.tagButton];
    [self addSubview:self.tipsButton];
    [self addSubview:self.followButton];
    [self addSubview:self.signatureLabel];
    [self addSubview:self.followCountButton];
    [self addSubview:self.fansCountButton];
    [self addSubview:self.beFollowCountButton];
    [self addSubview:self.storeButton];
    [self addSubview:self.ecologicalView];
    [self addSubview:self.serviceInfoView];
    
    [self makeConstraints];
}

- (void)makeConstraints{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(100);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(70);
        make.left.equalTo(self).inset(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(10);
        make.left.equalTo(self.avatarImageView);
    }];
    
    [self.tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [self.tipsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagButton.mas_right).offset(10);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).inset(10);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).inset(20);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    
    [self.followCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView);
        make.top.equalTo(self.signatureLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [self.fansCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followCountButton.mas_right).offset(20);
        make.top.equalTo(self.signatureLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [self.beFollowCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fansCountButton.mas_right).offset(20);
        make.top.equalTo(self.signatureLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [self.storeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView);
        make.top.equalTo(self.followCountButton.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [self.ecologicalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).inset(20);
        make.top.equalTo(self.storeButton.mas_bottom).offset(20);
        make.height.mas_equalTo(100);
    }];
    
    [self.serviceInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).inset(20);
        make.top.equalTo(self.ecologicalView.mas_bottom).offset(20);
        make.height.mas_equalTo(200);
    }];
}

- (void)bindViewModel{
    @weakify(self);
    [RACObserve(self.viewModel, model) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateUI];
    }];
}

- (void)updateUI{
    self.nameLabel.text = self.viewModel.name;
    self.tagButton.text = self.viewModel.tagName;
    self.signatureLabel.text = self.viewModel.signature;
    self.followCountButton.text = self.viewModel.followText;
    self.fansCountButton.text = self.viewModel.fansText;
    self.beFollowCountButton.text = self.viewModel.befollowText;
}

#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark - Private


#pragma mark - Getters and Setters
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"dec_banner_def"];
    }
    return _bgImageView;
}

- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.image = [UIImage imageNamed:@"com_preload_head_img"];
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UIButton *)tagButton{
    if (!_tagButton) {
        _tagButton = [[UIButton alloc] init];
    }
    return _tagButton;
}

- (UIButton *)tipsButton{
    if (!_tipsButton) {
        _tipsButton = [[UIButton alloc] init];
        [_tipsButton setTitle:@"?" forState:UIControlStateNormal];
    }
    return _tipsButton;
}

- (UIButton *)followButton{
    if (!_followButton) {
        _followButton = [[UIButton alloc] init];
        _followButton.backgroundColor = UIColor.grayColor;
        [_tipsButton setTitle:@"关注" forState:UIControlStateNormal];
    }
    return _followButton;
}

- (UILabel *)signatureLabel{
    if (!_signatureLabel) {
        _signatureLabel = [[UILabel alloc] init];
        _signatureLabel.numberOfLines = 0;
    }
    return _signatureLabel;
}


- (UIButton *)followCountButton{
    if (!_followCountButton) {
        _followCountButton = [[UIButton alloc] init];
        [_followCountButton setTitle:@"关注 2434" forState:UIControlStateNormal];
    }
    return _followCountButton;
}

- (UIButton *)fansCountButton{
    if (!_fansCountButton) {
        _fansCountButton = [[UIButton alloc] init];
    }
    return _fansCountButton;
}

- (UIButton *)followedCountButton{
    if (!_beFollowCountButton) {
        _beFollowCountButton = [[UIButton alloc] init];
    }
    return _beFollowCountButton;
}

- (UIButton *)storeButton{
    if (!_storeButton) {
        _storeButton = [[UIButton alloc] init];
        [_storeButton setTitle:@"TA的店铺" forState:UIControlStateNormal];
    }
    return _storeButton;
}

- (UIImageView *)ecologicalView{
    if (!_ecologicalView) {
        _ecologicalView = [[UIImageView alloc] init];
        _ecologicalView.image = [UIImage imageNamed:@"dec_banner_def"];
    }
    return _ecologicalView;
}

- (UIView *)serviceInfoView{
    if (!_serviceInfoView) {
        _serviceInfoView = [[UIView alloc] init];
        _serviceInfoView.backgroundColor = UIColor.orangeColor;
    }
    return _serviceInfoView;
}

#pragma mark - Supperclass

#pragma mark - NSObject




@end
