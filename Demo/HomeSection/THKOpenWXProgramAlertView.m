//
//  THKOpenWXProgramAlertView.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/29.
//

#import "THKOpenWXProgramAlertView.h"

@interface THKOpenWXProgramAlertView ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *contentLbl;

@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) TMUIModalPresentationViewController *modalViewController;

@property (nonatomic, strong) TMUIWeakObjectContainer *weakModalVC;

@end

@implementation THKOpenWXProgramAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubview];
    }
    return self;
}


- (void)setupSubview{
    self.backgroundColor = UIColor.whiteColor;
    self.cornerRadius = 12;
    [self addSubview:self.titleLbl];
    [self addSubview:self.contentLbl];
    [self addSubview:self.cancleBtn];
    [self addSubview:self.confirmBtn];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.equalTo(self).inset(30);
        make.right.mas_greaterThanOrEqualTo(-30);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(30);
        make.left.equalTo(self).inset(30);
        make.right.mas_greaterThanOrEqualTo(-30);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLbl.mas_bottom).offset(30);
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(130, 48));
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLbl.mas_bottom).offset(30);
        make.right.mas_equalTo(-30);
        make.size.mas_equalTo(CGSizeMake(130, 48));
    }];
#if DEBUG
    MASAttachKeys(self,self.titleLbl, self.contentLbl, self.cancleBtn, self.confirmBtn);
#endif
}

+ (void)showAlertWithConfirmBlock:(void (^)(THKOpenWXProgramAlertView * _Nonnull))confirmBlock cancelBlock:(void (^)(THKOpenWXProgramAlertView * _Nonnull))cancelBlock{
    THKOpenWXProgramAlertView *alert = [THKOpenWXProgramAlertView new];
    [alert handleShowingConfirmBlock:confirmBlock cancelBlock:cancelBlock];
}

- (void)dismiss{
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)animated{
    @weakify(self);
    [self.modalViewController hideInView:TMUI_AppWindow animated:animated completion:^(BOOL finished) {
        @strongify(self);
        self.modalViewController.contentView = nil;
    }];
}


- (void)handleShowingConfirmBlock:(void (^)(THKOpenWXProgramAlertView * _Nonnull))confirmBlock cancelBlock:(void (^)(THKOpenWXProgramAlertView * _Nonnull))cancelBlock{
    
    
    
    TMUIModalPresentationViewController *modalViewController = [[TMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = self;
    modalViewController.dimmingView.backgroundColor = [UIColorBlack colorWithAlphaComponent:0.6];
    // 以 UIWindow 的形式来展示
//    [modalViewController showWithAnimated:YES completion:nil];
    [modalViewController showInView:TMUI_AppWindow animated:YES completion:nil];
    
    @weakify(self);
    [self.cancleBtn tmui_addActionBlock:^(NSInteger tag) {
        @strongify(self);
        cancelBlock(self);
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.confirmBtn tmui_addActionBlock:^(NSInteger tag) {
        @strongify(self);
        confirmBlock(self);
    } forControlEvents:UIControlEventTouchUpInside];
    
    modalViewController.willHideByDimmingViewTappedBlock = ^{
        @strongify(self);
        [self dismiss:NO];
    };
    
    
    self.modalViewController = modalViewController;
//    TMUIWeakObjectContainer *weakModalVC = [[TMUIWeakObjectContainer alloc] initWithObject:modalViewController];
}

- (CGSize)sizeThatFits:(CGSize)size{
    return CGSizeMake(335, 246);
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorDark;
        _titleLbl.font = UIFontSemibold(18);
        _titleLbl.text = @"开启微信小程序消息提醒";
    }
    return _titleLbl;
}

- (UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] init];
        _contentLbl.textColor = UIColorDark;
        _contentLbl.font = UIFont(16);
        _contentLbl.numberOfLines = 0;
        _contentLbl.text = @"1. 打开小程序\n2. 订阅消息通知";
        [_contentLbl tmui_setAttributeslineSpacing:20];
    }
    return _contentLbl;
}

- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton tmui_button];
        _cancleBtn.tmui_text = @"暂不开启";
        _cancleBtn.tmui_titleColor = UIColorGreen;
        _cancleBtn.backgroundColor = UIColorBackgroundLight;
        _cancleBtn.cornerRadius = 6;
    }
    return _cancleBtn;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton tmui_button];
        _confirmBtn.tmui_text = @"开启提醒";
        _confirmBtn.tmui_titleColor = UIColorWhite;
        _confirmBtn.backgroundColor = UIColorGreen;
        _confirmBtn.cornerRadius = 6;
    }
    return _confirmBtn;
}

@end
