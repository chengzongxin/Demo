//
//  THKBaseNetworkManager.m
//  THKBaseNetwork
//
//  Created by 荀青锋 on 2019/11/5.
//

#import "THKBaseNetworkManager.h"

@interface THKBaseNetworkManager ()

@end

@implementation THKBaseNetworkManager

+ (THKBaseNetworkManager *)sharedManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {}
    return self;
}

- (void)requestStart:(THKRequestBlock)startRequestBlock
             success:(THKRequestBlock)successRequestBlock
             failure:(THKRequestBlock)failureRequestBlock {
    self.startRequestBlock = startRequestBlock;
    self.successRequestBlock = successRequestBlock;
    self.failureRequestBlock = failureRequestBlock;
}

#pragma mark - GET

- (NSString *)userId {
    if (self.userIdBlock) {
        return self.userIdBlock();
    }
    return _userId;
}

- (NSString *)token {
    if (self.tokenBlock) {
        return self.tokenBlock();
    }
    return _token;
}

- (NSString *)userAgent {
    if (self.userAgentBlock) {
        return self.userAgentBlock();
    }
    return _userAgent;
}

- (NSDictionary *)parameters {
    if (self.parametersBlock) {
        return self.parametersBlock();
    }
    return _parameters;
}

@end
