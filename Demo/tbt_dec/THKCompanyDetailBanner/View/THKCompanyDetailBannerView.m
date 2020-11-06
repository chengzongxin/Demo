//
//  THKCompanyDetailBanner.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "THKCompanyDetailBannerView.h"
#import "THKCompanyDetailBannerMainView.h"
#import "THKCompanyDetailBannerRollingView.h"
#import "THKCompanyDetailBannerEntryView.h"
#import "TDecDetailFirstModel.h"


@interface THKCompanyDetailBannerView ()

@property (nonatomic, strong) THKCompanyDetailBannerViewModel *viewModel;
/// 主轮播图
@property (nonatomic, strong) THKCompanyDetailBannerMainView *mainView;
/// 动态滚动图
@property (nonatomic, strong) THKCompanyDetailBannerRollingView *rollingView;
/// 进入视频和图片入口
@property (nonatomic, strong) THKCompanyDetailBannerEntryView *entryView;

@end

@implementation THKCompanyDetailBannerView
TMUI_PropertySyntheSize(viewModel);

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self makeConstrans];
    }
    return self;
}


- (void)setupSubviews{
    self.backgroundColor = UIColor.orangeColor;
    [self addSubview:self.mainView];
    [self addSubview:self.rollingView];
    [self addSubview:self.entryView];
}

- (void)makeConstrans{
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.rollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.bottom.equalTo(self).inset(26);
        make.size.mas_equalTo(CGSizeMake(212, 54));
    }];
    [self.entryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).inset(16);
        make.bottom.equalTo(self).inset(26);
        make.size.mas_equalTo(CGSizeMake(96, 20));
    }];
}


#pragma mark - Public
- (void)bindViewModel{
    [super bindViewModel];
    
    // 设置model
    [self.mainView bindViewModel:self.viewModel.mainViewModel];
    [self.rollingView bindViewModel:self.viewModel.rollModel];
    [self.entryView bindViewModel:self.viewModel.entryModel];
    
    // 添加入口
//    [self.mainView.tapItemSubject subscribe:self.viewModel.tapItemSubject];
    [self.rollingView.tapRemindSignal subscribe:self.viewModel.tapRemindLiveSubject];
//    [self.entryView.tapVideoImageEntrySubject subscribe:self.viewModel.tapVideoImageTagSubject];
}

#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Getters and Setters

TMUI_PropertyLazyLoad(THKCompanyDetailBannerMainView, mainView);
TMUI_PropertyLazyLoad(THKCompanyDetailBannerRollingView, rollingView);
TMUI_PropertyLazyLoad(THKCompanyDetailBannerEntryView, entryView);

#pragma mark - Supperclass

#pragma mark - NSObject




@end
