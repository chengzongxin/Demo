//
//  THKCompanyDetailBannerVideoCell.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "THKCompanyDetailBannerVideoCell.h"
#import <AVFoundation/AVFoundation.h>

@interface THKCompanyDetailBannerVideoCell ()
/* 播放器 */
@property (nonatomic, strong) AVPlayer *player;
// 播放器的Layer
@property (weak, nonatomic) AVPlayerLayer *playerLayer;

@end

@implementation THKCompanyDetailBannerVideoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.player = [[AVPlayer alloc] init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.contentView.layer addSublayer:self.playerLayer];
    [RACObserve(self.player, rate) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - 设置播放的视频
- (void)setUrl:(NSString *)url{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.player play];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

@synthesize url;

@end
