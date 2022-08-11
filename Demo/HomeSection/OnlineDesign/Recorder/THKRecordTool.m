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
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];
    [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    NSURL *url = [NSURL URLWithString:kRecordFilePath];
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:nil];
    [_audioRecorder prepareToRecord];
}

- (void)setupPlayer{
    NSURL *url = [NSURL URLWithString:kRecordFilePath];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
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
