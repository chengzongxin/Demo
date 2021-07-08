//
//  THKIdentityConfigManager.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/2/5.
//

#import "THKIdentityConfigManager.h"
#import "THKIdentityTypeModel.h"
#import <YYCache.h>
#import "THKPersonalDesignerConfigRequest.h"
//#import "THKConfiguration.h"
#import "THKHttpDNSManager.h"
static NSString * const kTHK_identity_config = @"kTHK_identity_config";
static NSString * const kConfig_file = @"kConfig_file";

@interface THKIdentityConfigManager ()

@property(nonatomic, strong) YYCache *cache;

@property(nonatomic, assign) BOOL hadLoadConfig;

@property(nonatomic, strong) THKIdentityTypeModel *configFile;

@property (nonatomic, assign) BOOL loadFinishDNS;

///重试次数
@property (nonatomic, assign) NSInteger retryCount;
@end

@implementation THKIdentityConfigManager


+ (instancetype)shareInstane {
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[[self class] alloc] init];
    });
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cache = [YYCache cacheWithName:kTHK_identity_config];
//        NSLog(@"kTHK_identity_config %@",self.cache.diskCache.path);
    }
    return self;
}

/// 加载配置
- (void)loadConfig{
    if (self.hadLoadConfig) {
        return;
    }
    // 加载本地配置 memery or disk
    THKIdentityTypeModel *model = [self loadLocalConfigFile];
    if (model) {
        self.configFile = model;
    }
    
    // 加载缓存配置 assets
    if (!model) {
        self.configFile = [self loadAssetConfigFile];
    }
    
    // 加载远程配置
    [self loadRemoteConfigFileWithResultBlock:nil];
    
    self.hadLoadConfig = YES;
}

- (THKIdentityTypeModel *)loadAssetConfigFile{
    return [THKIdentityTypeModel modelDefault];
}

- (THKIdentityTypeModel *)loadLocalConfigFile{
    return (THKIdentityTypeModel *)[self.cache objectForKey:kConfig_file];
}

- (void)loadRemoteConfigFileWithResultBlock:(T8TBasicBlock)resultBlock{
    self.hadLoadConfig = YES;
    THKPersonalDesignerConfigRequest *request = [[THKPersonalDesignerConfigRequest alloc] init];
    request.accessType = ([self needConfigRequestIP] ? 1 : 0);
    @weakify(self);
    [request.rac_requestSignal subscribeNext:^(THKPersonalDesignerConfigResponse *response) {
        if (response.status == THKStatusSuccess) {
            @strongify(self);
            //每次进入前台会请求数据，所以成功后初始化为0
            self.retryCount = 0;
            THKIdentityTypeModel *data = response.data;
            NSDictionary *dic = [data getDecryptedData];
            if (dic) {
                data = [THKIdentityTypeModel mj_objectWithKeyValues:dic];
            }
            if (data.identify.count > 0) {
                self.configFile = data;
                [self.cache setObject:data forKey:kConfig_file];
            }
            if(data.domainConfig){
                [self saveDomains:data.domainConfig.mj_keyValues];
                [[THKHttpDNSManager shareInstane] configDomainDic:data.domainConfig.domainMapping];
                [[THKHttpDNSManager shareInstane] configDomainSwitch:data.domainConfig.domainMappingSwitch];
                if ([self needConfigRequestIP]) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotice_refreshBottomTabPageAfterDomainConfigRetryLoadSuc object:nil];
                }
            }
        }
        if (resultBlock) {
            resultBlock();
        }
    } error:^(NSError * _Nullable error) {
        if (resultBlock) {
            resultBlock();
        }
        @strongify(self);
        if ([AFNetworkReachabilityManager sharedManager].isReachable) {
            //有网络，重试操作
            [self retryLoadConfig];
        }else{
            //无网络，通知重试
            [self startNetMonitor];
        }
    }];
}

- (void)startNetMonitor
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}


- (void)reachabilityDidChange:(NSNotification *)not
{
    NSDictionary *userInfo = not.userInfo;
    AFNetworkReachabilityStatus reachabilityStatus = [userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    BOOL netConnected = reachabilityStatus > 0;
    if (netConnected ) {
        self.retryCount = 0;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
        
        [self loadRemoteConfigFileWithResultBlock:nil];
    }
}

-(void)retryLoadConfig{
    //重试次数太多了，直接返回
    if (self.retryCount >= 2) {
        return;
    }
    //如果是to8to域名，不需要重试
    if(![[THKHttpDNSManager shareInstane] needConvertUrl] ){
        return;
    }
    self.retryCount++;
    [self loadRemoteConfigFileWithResultBlock:nil];
}

-(BOOL)needConfigRequestIP{
    //次数大于2 && 不是to8to的域名，则需要替换成ip直连
    if (self.retryCount >= 2 && [[THKHttpDNSManager shareInstane] needConvertUrl]) {
        return YES;
    }
    return NO;
}
/// 是否需要配置请求的ip
-(BOOL)needConfigRequestIPForUrl:(NSString*)url{
    //url有值 && url是启动配置接口 && 重试次数>=2 && 不是to8to域名
    if (url.length >= 1 && [url containsString:[THKPersonalDesignerConfigRequest thk_requestPath]]
        && [self needConfigRequestIP]) {
        return YES;
    }
    return NO;
}

-(void)saveDomains:(NSDictionary*)domains{
    if (domains.count == 0) {
        return;
    }
    NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.czx.demo"];
    NSURL *fileURL = [groupURL URLByAppendingPathComponent:@"thk_domainsMapping.txt"];
    [domains writeToURL:fileURL atomically:YES];
    
}

- (void)configDNS{
    THKIdentityTypeModel *model = [self loadLocalConfigFile];
    if (!model.domainConfig) {
        model = [THKIdentityTypeModel modelDefault];
    }
    if(model.domainConfig){
        [[THKHttpDNSManager shareInstane] configDomainDic:model.domainConfig.domainMapping];
        [[THKHttpDNSManager shareInstane] configDomainSwitch:model.domainConfig.domainMappingSwitch];
    }
}

- (void)loadConfigWithResultBlock:(T8TBasicBlock)resultBlock{
    [self configDNS];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.loadFinishDNS) {
            self.loadFinishDNS = YES;
            if (resultBlock) {
                resultBlock();
            }
        }
    });
//    if ([THKConfiguration shareInstane].isFirstInstallOrUpgrade) {
        @weakify(self);
        [self loadRemoteConfigFileWithResultBlock:^{
            @strongify(self);
            if (!self.loadFinishDNS) {
                self.loadFinishDNS = YES;
                if (resultBlock) {
                    resultBlock();
                }
            }
        }];
//    }else{
//        [self loadRemoteConfigFileWithResultBlock:^{}];
//        if (resultBlock) {
//            resultBlock();
//        }
//    }
}

- (THKIdentityTypeModelSubCategory *)fetchConfigWithType:(NSInteger)type subType:(NSInteger)subType{
    /// 空数组
    NSArray *models = self.configFile.identify;
    if (models.count == 0) return nil;
    
    THKIdentityTypeModelSubCategory *model;

    for (THKIdentityTypeModelIdentify *m in models) {
        if (m.identificationType == type) {
            for (THKIdentityTypeModelSubCategory *category in m.subCategory) {
                if (category.subCategory == subType) {
                    model = category;
                }
            }
            // 没找到subCategory，取第一个
            if (!model) {
                model = m.subCategory.firstObject;
            }
            break;
        }
    }
    return model;
}

@end
