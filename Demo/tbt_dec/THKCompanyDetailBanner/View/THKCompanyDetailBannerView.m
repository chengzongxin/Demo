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


@interface THKCompanyDetailBannerView ()
/// 主轮播图
@property (nonatomic, strong) THKCompanyDetailBannerMainView *cycleView;
/// 动态滚动图
@property (nonatomic, strong) THKCompanyDetailBannerRollingView *rollingView;
/// 进入视频和图片入口
@property (nonatomic, strong) THKCompanyDetailBannerEntryView *entryView;

@end

@implementation THKCompanyDetailBannerView

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}


- (void)setupSubviews{
    self.backgroundColor = UIColor.orangeColor;
    
}


#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Getters and Setters


#pragma mark - Supperclass

#pragma mark - NSObject




@end
