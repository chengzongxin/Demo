//
//  TBTNetworkPrivate.h
//  TBTNetwork
//
//  Created by 荀青锋 on 2019/6/28.
//

#import <Foundation/Foundation.h>
#import "TBTNetworkConfig.h"
#import "TBTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface TBTNetworkUtils : NSObject

+ (BOOL)validateJSON:(id)json withValidator:(id)jsonValidator;

+ (void)addDoNotBackupAttribute:(NSString *)path;

+ (NSString *)md5StringFromString:(NSString *)string;

+ (NSString *)appVersionString;

+ (NSStringEncoding)stringEncodingWithRequest:(TBTBaseRequest *)request;

+ (BOOL)validateResumeData:(NSData *)data;

@end


@interface TBTBaseRequest (Setter)

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite, nullable) NSData *responseData;
@property (nonatomic, strong, readwrite, nullable) id responseJSONObject;
@property (nonatomic, strong, readwrite, nullable) id responseObject;
@property (nonatomic, strong, readwrite, nullable) NSString *responseString;
@property (nonatomic, strong, readwrite, nullable) NSError *error;

@property (nonatomic, strong, readwrite, nullable) NSProgress *uploadProgress;
@property (nonatomic, strong, readwrite, nullable) NSProgress *downLoadProgress;

@end

NS_ASSUME_NONNULL_END
