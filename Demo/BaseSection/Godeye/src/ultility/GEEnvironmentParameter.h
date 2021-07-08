//
//  GEEnvironmentParameter.h
//  AFNetworking
//
//  Created by jerry.jiang on 2018/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GEEnvironmentParameter : NSObject

@property (nonatomic, copy) NSString *first_id;
@property (nonatomic, copy) NSString *user_id;
///账号id
@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *user_city;
@property (nonatomic, copy) NSString *app_name;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *debugInfo;

@property (nonatomic, assign) NSInteger isnew;

@property (nonatomic, readonly) NSString *session;
@property (nonatomic, readonly) NSDictionary *parameter;
@property (nonatomic, readonly) BOOL isInBackground;

/**
 add by amby.qin
 只要在这个列表中则不需要等待，立即上报
 */
@property (nonatomic, copy) NSArray *immediatelyReportList;

+ (instancetype)defaultParameter;

- (NSString *)userAgent;

#pragma mark - Private

- (void)appDidResignActive;
- (void)appDidBecomeActive;

@end

NS_ASSUME_NONNULL_END
