//
//  THKRecordTool.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKRecordTool.h"
#import <AVFoundation/AVFoundation.h>
#import "LameTool.h"

#if TARGET_OS_SIMULATOR
#define kRecordDirectory @"/Users/joe.cheng/Desktop"
#else
#define kRecordDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#endif

@interface THKRecordTool ()<AVAudioRecorderDelegate>{
    NSMutableDictionary *_recordSettings;
}

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation THKRecordTool
SHARED_INSTANCE_FOR_CLASS;


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize{
    // 录音会话设置
    NSError *errorSession = nil;
    AVAudioSession * audioSession = [AVAudioSession sharedInstance]; // 得到AVAudioSession单例对象
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &errorSession];// 设置类别,表示该应用同时支持播放和录音
    [audioSession setActive:YES error: &errorSession];// 启动音频会话管理,此时会阻断后台音乐的播放.
    
    // 设置成扬声器播放
    UInt32 doChangeDefault = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);
    
    _recordSettings = [[NSMutableDictionary alloc] init];
    [_recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    [_recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];
    [_recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    [_recordSettings setValue :[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
}

- (void)setupRecorder:(NSString *)fileName{
    //----------------AVAudioRecorder----------------
    NSURL *url = [NSURL URLWithString:[kRecordDirectory stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"caf"]]];
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:_recordSettings error:nil];
    _audioRecorder.delegate = self;
    _audioRecorder.meteringEnabled = YES;
    [_audioRecorder prepareToRecord];
}

- (void)setupPlayer:(NSString *)urlString{
    //----------------AVAudioPlayer----------------
    NSError *playerError;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:urlString] error:&playerError];
    if (_audioPlayer) {
        _audioPlayer.volume = 1.0;
    } else {
        NSLog(@"Error: %@", [playerError localizedDescription]);
    }
}

#pragma mark - Public

- (void)startRecord:(NSString *)fileName{
    [self setupRecorder:fileName];
    [_audioRecorder record];
}

- (void)stopRecord{
    [_audioRecorder stop];
}

- (void)play:(NSString *)urlString{
    [self setupPlayer:urlString];
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
}


#pragma mark - Delegate
#pragma mark <AVAudioRecorderDelegate>
/* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSString *path = [LameTool audioToMP3:recorder.url.absoluteString isDeleteSourchFile:YES];
    NSLog(@"path = %@",path);
    if (self.recordFinish) {
        self.recordFinish(path);
    }
}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
    
}

/* AVAudioRecorder INTERRUPTION NOTIFICATIONS ARE DEPRECATED - Use AVAudioSession instead. */

/* audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was recording. The recorded file will be closed. */
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    [self stopRecord];
}


@end
