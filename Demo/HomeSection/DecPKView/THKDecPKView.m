//
//  THKDecPKView.m
//  Demo
//
//  Created by Joe.cheng on 2022/12/21.
//

#import "THKDecPKView.h"
#import "THKDecPKSrcollView.h"
#import "FLRadarChartView.h"
@interface THKDecPKView ()

@property (nonatomic, strong) UIImageView *topBgImgV;
@property (nonatomic, strong) UILabel *firstTitle;
@property (nonatomic, strong) UIButton *firstButtonTip;
@property (nonatomic, strong) UIImageView *firstContentImgV;
@property (nonatomic, strong) UILabel *secondTitle;
@property (nonatomic, strong) UIButton *secondButtonTip;
@property (nonatomic, strong) THKDecPKSrcollView *pkView;
@property (nonatomic, strong) FLRadarChartView *radarView;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) UILabel *bottomTipLabel;
//secondContent : [
//    decName
//    decIcon
//    score(text)
//    caseNum(text)
//    consultNum(text)
//]
//bigButtonTip(router)
//bottomTipIcon
//bottomTip(router)


@end

@implementation THKDecPKView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
}


@end
