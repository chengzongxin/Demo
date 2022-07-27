//
//  TObject+TNSCodingHelp.m
//  TBasicLib
//
//  Created by to on 14-12-4.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import "TObject+TNSCodingHelp.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *const kDataKey = @"T8TObjCodingKey";

@implementation TObject (TNSCodingHelp)

+ (NSCache *)shareCache {
    static NSCache *cache = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * __unused notification) {
            [cache removeAllObjects];
        }];
    });
    
    return cache;
}

- (void)writeObjectForKey:(NSString *)key path:(TCodingPath)path {
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self forKey:kDataKey];
    
    [archiver finishEncoding];
    
    NSString *fileName = [[self class] pathWithKey:key path:path];
    [[[self class] shareCache] removeObjectForKey:fileName];
    
    [data writeToFile:fileName atomically:YES];
}

- (void)writeObjectForKey:(NSString *)key {
    [self writeObjectForKey:key path:TCodingPathDocument];
}

+ (id)getObjctForKey:(NSString *)key {
   return  [self getObjctForKey:key path:TCodingPathDocument];
}

+ (id)getObjctForKey:(NSString *)key path:(TCodingPath)path {
    NSString *fileName = [[self class] pathWithKey:key path:path];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {

        NSData *data = nil;
        NSData *cache = [[self shareCache] objectForKey:fileName];
        if (cache) {
            data = cache;
        }else{
           data = [[NSData alloc] initWithContentsOfFile:fileName];
           if(data)  [[self shareCache] setObject:data forKey:fileName];
        }
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        // 解档出数据模型Model
        TObject *model = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];

        return model;
    }
    
    return nil;
}

+ (void)removeCodingForKey:(NSString *)key {
    [self removeCodingForKey:key path:TCodingPathDocument];
}

+ (void)removeCodingForKey:(NSString *)key path:(TCodingPath)path {
    NSString *fileName = [[self class] pathWithKey:key path:path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:fileName]) {
        NSError *error = nil;
        [fileManager removeItemAtPath:fileName error:&error];
        if(error) printf("%s\n", error.description.UTF8String);
    }
}

+ (NSString *)md5String:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

#pragma mark - private

+ (NSString *)pathWithKey:(NSString *)key path:(TCodingPath)path {
    NSString *fileName = [self md5String:[NSString stringWithFormat:@"%@%@",NSStringFromClass([self class]),key]];
    
    return (path == TCodingPathCach) ? FilePathAtCachWithName(fileName) : FilePathAtDocumentWithName(fileName);
}

// 缓存路径-cach目录
NS_INLINE NSString *FilePathAtCachWithName(NSString *fileNAme){
    static NSString *cachFilePath = nil;
    if (!cachFilePath) {
        cachFilePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    }
    return [cachFilePath stringByAppendingPathComponent:fileNAme];
}

// 缓存路径-document目录
NS_INLINE NSString *FilePathAtDocumentWithName(NSString *fileNAme){
    static NSString *documentFilePath = nil;
    if (!documentFilePath) {
        documentFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    }
    return [documentFilePath stringByAppendingPathComponent:fileNAme];
}


@end
