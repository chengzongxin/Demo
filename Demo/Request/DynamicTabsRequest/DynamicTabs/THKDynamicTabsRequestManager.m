//
//  THKDynamicTabsRequestManager.m
//  HouseKeeper
//
//  Created by amby.qin on 2020/11/16.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKDynamicTabsRequestManager.h"
#import "THKDynamicTabsRequest.h"
#import "THKDynamicTabsRequestProtocol.h"

@interface THKDynamicTabsRequestManager ()

@property (nonatomic, strong)   NSMutableDictionary *dictWholeCodeForRequest;

@end

@implementation THKDynamicTabsRequestManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static THKDynamicTabsRequestManager *tabRequestManager = nil;
    dispatch_once(&onceToken, ^{
        tabRequestManager = [[THKDynamicTabsRequestManager alloc] init];
        
    });
    return tabRequestManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.dictWholeCodeForRequest = [NSMutableDictionary dictionary];
        NSMutableDictionary *classes = [NSMutableDictionary dictionary];
        unsigned int classCount;
        Class* classList = objc_copyClassList(&classCount);
        
        int i;
        for (i=0; i<classCount; i++) {
            const char *className = class_getName(classList[i]);
            Class thisClass = objc_getClass(className);
            if (class_conformsToProtocol(thisClass, @protocol(THKDynamicTabsRequestProtocol))) {
                if ([thisClass performSelector:@selector(wholeCode)]) {
                    NSArray<NSString *> *codes = [thisClass wholeCode];
                    if (codes && [codes isKindOfClass:[NSArray<NSString *> class]]) {
                        [codes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [classes setObject:thisClass forKey:obj];
                        }];
                    }
                }
            }
        }
        free(classList);
    }
    return self;
}

- (void)sendRequestWithWholeCode:(NSString *)wholeCode success:(THKRequestSuccess)success failure:(THKRequestFailure)failure {
    if (wholeCode) {
        NSString    *className = [self.dictWholeCodeForRequest safeObjectForKey:wholeCode];
        if (className && [className isKindOfClass:[NSString class]]) {
            Class thisClass = NSClassFromString(className);
            if ([thisClass isKindOfClass:[THKDynamicTabsRequest class]]) {
                THKDynamicTabsRequest *request = [thisClass new];
                [request sendSuccess:success failure:failure];
            }
        }
    }
}

@end
