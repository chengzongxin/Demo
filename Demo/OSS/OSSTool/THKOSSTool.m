//
//  THKOSSTool.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/9/17.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKOSSTool.h"
#import <THKOSSManager.h>

@implementation THKOSSTool

+ (void)uploadImage:(NSArray <UIImage *> *)images type:(THKOSSModuleType)type success:(OSSToolUploadSuccess)success fail:(OSSToolUploadFail)fail{
    
    THKOSSManager.sharedInstance.debugModel = YES;
    NSMutableArray <THKOSSUploadFileModel *> *fileModes = [NSMutableArray array];
    
    for (int i = 0; i < images.count; i++) {
        UIImage *img = images[i];
        THKOSSUploadFileModel *aModel = [[THKOSSUploadFileModel alloc] init];
        aModel.filePath = [self getFilePathWithType:type originFileName:@(i).stringValue];
        aModel.fileData = [img tmui_imageData];
        aModel.tag = i;
        [fileModes addObject:aModel];
    }
    
    [[THKOSSManager sharedInstance] uploadOSSFiles:fileModes progress:nil resultBlock:^(NSInteger code, NSString * _Nullable result) {
        success(@[result]);
    } failBlock:^(NSInteger code, NSString * _Nullable result) {
        fail([NSError errorWithDomain:result code:code userInfo:nil]);
    }];
}


/*
 目录名规则：/live/day_当前年月日(年只取后两位)
 文件名规则：当前年月日_MD5（文件名+当前 Unix 时间戳和微秒数）（MD5后的哈希值以0开始，从12号开始取至末尾）+ 12位随机码
 具体线上图片地址：http://pic.to8to.com/live/day_210727/20210727_16e499feb7eeb79c69d6pFjgKP0oVVxx.jpg

 module 对应目录
 diary -> live       ugc -> social   ask -> ask    personal -> personal     gongdiPic -> gongdi_pic
 （公有PUBLIC）
 */
+ (NSString *)getFilePathWithType:(THKOSSModuleType)type originFileName:(NSString *)originFileName{
    NSString *directory1 = nil;
    NSString *filePath = nil;
    // 1级目录
    switch (type) {
        case THKOSSModuleType_Diary:
            directory1 = @"live";
            break;
        case THKOSSModuleType_UGC:
            directory1 = @"social";
            break;
        case THKOSSModuleType_Ask:
            directory1 = @"ask";
            break;
        case THKOSSModuleType_Personal:
            directory1 = @"personal";
            break;
        case THKOSSModuleType_GONGDI_PIC:
            directory1 = @"gongdi_pic";
            break;
        default:
            break;
    }
    NSDate *nowDate = [NSDate date];
    // 2级目录
    NSString *dateStr = [nowDate tmui_stringWithFormat:@"yyMMdd"];
    NSString *directory2 = [NSString stringWithFormat:@"day_%@",dateStr];
    // 3级文件名
    NSString *dateStr3 = [nowDate tmui_stringWithFormat:@"yyyyMMdd"];
    NSString *fileNamePrefix = [[[NSString stringWithFormat:@"%@%@",originFileName,[self getNowTimeTimestamp]] tmui_md5] substringFromIndex:12];
    NSString *randomSubfix = [self random:12];
    NSString *fileName3 = [NSString stringWithFormat:@"%@_%@%@",dateStr3,fileNamePrefix,randomSubfix];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@/%@.jpg",directory1,directory2,fileName3];
    return fullPath;
}


+ (NSString *)getNowTimeTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这一点对时间的处理有时很重要
    NSTimeZone*timeZone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}

//产生随机字符串
+ (NSString *)random:(NSInteger)bit{
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    for (int i = 0; i < bit; i++){
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    
    return resultStr;
}

@end
