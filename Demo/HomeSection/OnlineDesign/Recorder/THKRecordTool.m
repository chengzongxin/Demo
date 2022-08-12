//
//  THKRecordTool.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKRecordTool.h"
#import <AVFoundation/AVFoundation.h>

//#define kRecordFilePath @"/Users/joe.cheng/Desktop/TMUIKit_AssociateProject/OnlineDesign.caf"
#define kRecordFilePath tmui_filePathAtDocumentWithName(@"OnlineDesign.caf")

@interface THKRecordTool ()
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation THKRecordTool
SHARED_INSTANCE_FOR_CLASS;


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupRecorder];
    }
    return self;
}

- (void)setupRecorder{
    //----------------AVAudioRecorder----------------
    // 录音会话设置
    NSError *errorSession = nil;
    AVAudioSession * audioSession = [AVAudioSession sharedInstance]; // 得到AVAudioSession单例对象
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &errorSession];// 设置类别,表示该应用同时支持播放和录音
    [audioSession setActive:YES error: &errorSession];// 启动音频会话管理,此时会阻断后台音乐的播放.
    
    // 设置成扬声器播放
    UInt32 doChangeDefault = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];
    [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    [recordSettings setValue :[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:kRecordFilePath] settings:recordSettings error:nil];
    _audioRecorder.meteringEnabled = YES;
    [_audioRecorder prepareToRecord];
}

- (void)setupPlayer{
    //----------------AVAudioPlayer----------------
    NSError *playerError;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:kRecordFilePath] error:&playerError];
    if (_audioPlayer) {
        _audioPlayer.volume = 1.0;
    } else {
        NSLog(@"Error: %@", [playerError localizedDescription]);
    }
}

- (void)startRecord{
    [_audioRecorder record];
}

- (void)stopRecord{
    [_audioRecorder stop];
}


- (void)play{
    
    [self setupPlayer];
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
}

@end
