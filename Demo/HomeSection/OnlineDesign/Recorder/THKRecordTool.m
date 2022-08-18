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
#define kRecordDirectory @"/Users/joe.cheng/Desktop/AudioRecord"
#else
#define kRecordDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#endif

@implementation THKAudioDescription @end

@interface THKRecordTool ()<AVAudioRecorderDelegate>{
    NSDictionary *_recordSettings;
    BOOL _isDeleteFile;
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
    
    _recordSettings = @{
        AVFormatIDKey : @(kAudioFormatLinearPCM),// 音频格式
        AVSampleRateKey : @44100.0f,// 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
        AVNumberOfChannelsKey : @2,// 音频通道数 1 或 2
        AVEncoderBitDepthHintKey : @16,// 线性音频的位深度 8、16、24、32
        AVEncoderAudioQualityKey : @(AVAudioQualityHigh)// 录音的质量
    };
}

- (AVAudioRecorder *)setupRecorder:(NSString *)fileName{
    //----------------AVAudioRecorder----------------
    NSURL *url = [NSURL URLWithString:[kRecordDirectory stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"caf"]]];
    AVAudioRecorder *audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:_recordSettings error:nil];
    audioRecorder.delegate = self;
    audioRecorder.meteringEnabled = YES;
    [audioRecorder prepareToRecord];
    return audioRecorder;
}

- (AVAudioPlayer *)setupPlayer:(NSString *)urlString{
    //----------------AVAudioPlayer----------------
    NSError *playerError;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:urlString] error:&playerError];
    if (audioPlayer) {
        audioPlayer.volume = 1.0;
    } else {
        NSLog(@"Error: %@", [playerError localizedDescription]);
    }
    return audioPlayer;
}

#pragma mark - Public

- (void)startRecord:(NSString *)fileName{
    _audioRecorder = [self setupRecorder:fileName];
    [_audioRecorder recordForDuration:60];
}

- (void)stopRecord{
    [_audioRecorder stop];
}

- (BOOL)deleteRecording{
    _isDeleteFile = YES;
    [self stopRecord];
    return [_audioRecorder deleteRecording];
}

- (void)deleteFilePath:(NSString *)filePath{
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

- (void)play:(NSString *)urlString{
    _audioPlayer = [self setupPlayer:urlString];
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
}


#pragma mark - Delegate
#pragma mark <AVAudioRecorderDelegate>
/* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (_isDeleteFile) {
        _isDeleteFile = NO;
        return;
    }
    NSString *path = [LameTool audioToMP3:recorder.url.absoluteString isDeleteSourchFile:YES];
    NSLog(@"path = %@",path);
    AVAudioPlayer *player = [self setupPlayer:path];
    if (self.recordFinish && player) {
        THKAudioDescription *desc = [[THKAudioDescription alloc] init];
        desc.filePath = path;
        desc.duration = player.duration;
        self.recordFinish(desc);
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
