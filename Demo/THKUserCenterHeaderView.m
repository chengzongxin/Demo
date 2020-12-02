//
//  THKUserCenterHeaderView.m
//  Demo
//
//  Created by Joe.cheng on 2020/12/1.
//

#import "THKUserCenterHeaderView.h"
#import "UIButton+Convenient.h"
#import "TMContentAlert.h"
#import "BeCollectThumbupView.h"
#import "UIViewController+Convenient.h"

@interface THKUserCenterHeaderView ()

@property (nonatomic, strong, readwrite) THKUserCenterHeaderViewModel *viewModel;
/// 背景主图
@property (nonatomic, strong) UIImageView *bgImageView;
/// 圆角视图
@property (nonatomic, strong) UIView *cornerView;
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
@property (nonatomic, strong) UIButton *beCollectCountButton;
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
    [self addSubview:self.bgImageView];
    [self addSubview:self.cornerView];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.tagButton];
    [self addSubview:self.tipsButton];
    [self addSubview:self.followButton];
    [self addSubview:self.signatureLabel];
    [self addSubview:self.followCountButton];
    [self addSubview:self.fansCountButton];
    [self addSubview:self.beCollectCountButton];
    [self addSubview:self.storeButton];
    [self addSubview:self.ecologicalView];
    [self addSubview:self.serviceInfoView];
    
    [self makeConstraints];
}

- (void)makeConstraints{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(_viewModel.bgImageH);
    }];
    
    [self.cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(165);
        make.height.mas_equalTo(40);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(_viewModel.avatarTop);
        make.left.equalTo(self).inset(16);
        make.size.mas_equalTo(CGSizeMake(_viewModel.avatarH, _viewModel.avatarH));
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(186);
        make.right.equalTo(self).inset(16);
        make.size.mas_equalTo(CGSizeMake(80, 36));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(_viewModel.nameTop);
        make.left.equalTo(self.avatarImageView);
    }];
    
    [self.tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(_viewModel.tagTop);
        make.size.mas_equalTo(CGSizeMake(80, _viewModel.tagH));
    }];
    
    [self.tipsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagButton.mas_right).offset(10);
        make.centerY.equalTo(self.tagButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).inset(16);
        make.top.equalTo(self.tagButton.mas_bottom).offset(_viewModel.signatureTop);
        make.height.mas_equalTo(_viewModel.signatureH);
    }];
    
    [self.followCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView);
        make.top.equalTo(self.signatureLabel.mas_bottom).offset(_viewModel.followCountTop);
        make.size.mas_equalTo(CGSizeMake(60, _viewModel.followCountH));
    }];
    
    [self.fansCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followCountButton.mas_right).offset(20);
        make.top.equalTo(self.signatureLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, _viewModel.followCountH));
    }];
    
    [self.beCollectCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fansCountButton.mas_right).offset(20);
        make.top.equalTo(self.signatureLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, _viewModel.followCountH));
    }];
    
    [self.storeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView);
        make.top.equalTo(self.followCountButton.mas_bottom).offset(_viewModel.storeTop);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [self.ecologicalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storeButton.mas_bottom).offset(_viewModel.ecologicalTop);
        make.left.right.equalTo(self).inset(16);
        make.height.mas_equalTo(_viewModel.ecologicalH);
    }];
    
    [self.serviceInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).inset(16);
        make.top.equalTo(self.ecologicalView.mas_bottom).offset(_viewModel.serviceTop);
        make.height.mas_equalTo(_viewModel.serviceH);
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
    self.followCountButton.attrText = self.viewModel.followAttrText;
    self.fansCountButton.attrText = self.viewModel.fansAttrText;
    self.beCollectCountButton.attrText = self.viewModel.befollowAttrText;
    
    [self.followCountButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_viewModel.followCountW);
    }];
    
    [self.fansCountButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_viewModel.fansCountW);
    }];
    
    [self.beCollectCountButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_viewModel.beFollowCountW);
    }];
}

#pragma mark - Public

#pragma mark - Event Respone
- (void)clickBeCollect{
    BeCollectThumbupView *alert = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(BeCollectThumbupView.class) owner:self options:nil].lastObject;
    
    [TMContentAlert showFromViewController:[UIViewController getCurrentVC] loadContentView:^(__kindof UIViewController * _Nonnull toShowVc) {
        [toShowVc.view addSubview:alert];
        alert.frame = toShowVc.view.bounds;
        alert.alpha = 0;
    } didShowBlock:^{
        //alpha渐变显示
        [UIView animateWithDuration:0.15 animations:^{
            alert.alpha = 1;
        }];
    }];
}
#pragma mark - Delegate

#pragma mark - Private


#pragma mark - Getters and Setters
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"dec_banner_def"];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UIView *)cornerView{
    if (!_cornerView) {
        _cornerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 40)];
        _cornerView.backgroundColor = UIColor.whiteColor;
        _cornerView.layer.cornerRadius = 12;
    }
    return _cornerView;
}

- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.image = [UIImage imageNamed:@"com_preload_head_img"];
        _avatarImageView.layer.cornerRadius = _viewModel.avatarH/2 ?: 36;
        _avatarImageView.layer.borderColor = UIColor.whiteColor.CGColor;
        _avatarImageView.layer.borderWidth = 2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarImageView;
}


- (UIButton *)followButton{
    if (!_followButton) {
        _followButton = [[UIButton alloc] init];
        _followButton.backgroundColor = UIColor.grayColor;
        [_followButton setTitle:@"+ 关注" forState:UIControlStateNormal];
        _followButton.titleLabel.font = UIFontMedium(16);
        [_followButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _followButton.backgroundColor = UIColorHexString(@"#24C77E");
        _followButton.layer.cornerRadius = 6;
    }
    return _followButton;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = UIFontMedium(22);
        _nameLabel.textColor = UIColorHexString(@"111111");
    }
    return _nameLabel;
}

- (UIButton *)tagButton{
    if (!_tagButton) {
        _tagButton = [[UIButton alloc] init];
        [_tagButton setImage:[UIImage imageNamed:@"user_tag_icon"] forState:UIControlStateNormal];
        [_tagButton setTitleColor:UIColorHexString(@"#878B99") forState:UIControlStateNormal];
        _tagButton.titleLabel.font = UIFont(12);
        _tagButton.backgroundColor = UIColorHexString(@"#F0F1F5");
        _tagButton.layer.cornerRadius = _viewModel.tagH/2?:12;
        _tagButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    }
    return _tagButton;
}

- (UIButton *)tipsButton{
    if (!_tipsButton) {
        _tipsButton = [[UIButton alloc] init];
        [_tipsButton setTitle:@"?" forState:UIControlStateNormal];
        [_tipsButton setTitleColor:UIColorHexString(@"#BABDC6") forState:UIControlStateNormal];
        _tipsButton.titleLabel.font = UIFont(12);
        _tipsButton.layer.cornerRadius = 8;
        _tipsButton.layer.borderColor = UIColorHexString(@"#BABDC6").CGColor;
        _tipsButton.layer.borderWidth = 0.5;
    }
    return _tipsButton;
}

- (UILabel *)signatureLabel{
    if (!_signatureLabel) {
        _signatureLabel = [[UILabel alloc] init];
        _signatureLabel.numberOfLines = 0;
        _signatureLabel.textColor = UIColorHexString(@"#878B99");
        _signatureLabel.font = UIFont(12);
    }
    return _signatureLabel;
}


- (UIButton *)followCountButton{
    if (!_followCountButton) {
        _followCountButton = [[UIButton alloc] init];
    }
    return _followCountButton;
}

- (UIButton *)fansCountButton{
    if (!_fansCountButton) {
        _fansCountButton = [[UIButton alloc] init];
    }
    return _fansCountButton;
}

- (UIButton *)beCollectCountButton{
    if (!_beCollectCountButton) {
        _beCollectCountButton = [[UIButton alloc] init];
        [_beCollectCountButton addTarget:self action:@selector(clickBeCollect) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beCollectCountButton;
}

- (UIButton *)storeButton{
    if (!_storeButton) {
        _storeButton = [[UIButton alloc] init];
        [_storeButton setImage:[UIImage imageNamed:@"user_tag_icon"] forState:UIControlStateNormal];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"TA的店铺  ＞" attributes:@{NSFontAttributeName:UIFont(12),NSForegroundColorAttributeName:UIColorHexString(@"#111111")}];
        [attrStr addAttributes:@{NSFontAttributeName:UIFont(10),
                                 NSForegroundColorAttributeName:UIColorHexString(@"#878B99"),
                                 NSBaselineOffsetAttributeName:@1
        } range:NSMakeRange(7, 1)];
        [_storeButton setAttributedTitle:attrStr forState:UIControlStateNormal];
        _storeButton.titleLabel.font = UIFont(12);
        _storeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _storeButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    return _storeButton;
}

- (UIImageView *)ecologicalView{
    if (!_ecologicalView) {
        _ecologicalView = [[UIImageView alloc] init];
        _ecologicalView.image = [UIImage imageNamed:@"dec_banner_def"];
        _ecologicalView.contentMode = UIViewContentModeScaleAspectFill;
        _ecologicalView.layer.cornerRadius = 4;
        _ecologicalView.layer.masksToBounds = YES;
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
