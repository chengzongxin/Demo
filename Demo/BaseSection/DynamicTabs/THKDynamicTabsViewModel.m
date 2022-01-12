//
//  THKDynamicTabsViewModel.m
//  HouseKeeper
//
//  Created by amby.qin on 2020/7/10.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKDynamicTabsViewModel.h"
#import "THKTabClearBadgeRequest.h"
#import "THKCompanyDetailTabRequest.h"

@interface THKDynamicTabsViewModel()

@property (nonatomic, strong)   RACSubject                          *tabsResultSubject;
@property (nonatomic, strong)   RACSubject                          *segmentValueChangedSubject;
@property (nonatomic, strong)   RACSubject                          *tabsLoadFinishSignal;

@property (nonatomic, copy)     NSArray<THKDynamicTabsModel *>      *segmentTabs;
@property (nonatomic, copy)     NSArray<NSString *>                 *segmentTitles;
@property (nonatomic, copy)     NSArray<UIViewController *>         *arrayChildVC;

/// 请求全码
@property (nonatomic, copy)     NSString            *wholeCode;
/// 请求参数
@property (nonatomic, copy)     NSDictionary        *extraParam;

@property (nonatomic, assign)   NSInteger           sliderBarDefaultSelected;

@property (nonatomic, assign)   BOOL                isRequestSuccess;
/// 加载数据方式
@property (nonatomic, assign) THKDynamicTabsLoadType loadType;
/// 使用外部数据源
//@property (nonatomic, assign)   BOOL isUseExternalDataSource;

@property (nonatomic, weak) __kindof THKBaseRequest *curReq;
@end

@implementation THKDynamicTabsViewModel

- (instancetype)initWithWholeCode:(NSString *)wholeCode defualtTabs:(NSArray<THKDynamicTabsModel *> *)tabs {
    return [self initWithWholeCode:wholeCode extraParam:nil defualtTabs:tabs];
}

- (instancetype)initWithWholeCode:(NSString *)wholeCode extraParam:(NSDictionary *)extraParam defualtTabs:(NSArray<THKDynamicTabsModel *> *)tabs {
    if (self = [super init]) {
        self.loadType = THKDynamicTabsLoadType_API;
        self.wholeCode = wholeCode;
        self.extraParam = extraParam;
        self.segmentTabs = tabs;
    }
    return self;
}

- (instancetype)initWithTabs:(NSArray<THKDynamicTabsModel *> *)tabs{
    if (self = [super init]) {
        [self setTabs:tabs];
    }
    return self;
}

- (instancetype)initWithVCs:(NSArray<UIViewController *> *)childVCs titles:(NSArray<NSString *> *)childTitles{
    if (self = [super init]) {
        [self setVCs:childVCs titles:childTitles];
    }
    return self;
}

- (void)setTabs:(NSArray<THKDynamicTabsModel *> *)tabs{
    self.loadType = THKDynamicTabsLoadType_Model;
    if (tabs && tabs.count > 0) {
        self.segmentTabs = tabs;
    }
}


- (void)setVCs:(NSArray<UIViewController *> *)childVCs titles:(NSArray<NSString *> *)childTitles{
    self.loadType = THKDynamicTabsLoadType_Data;
    self.segmentTitles = childTitles;
    self.arrayChildVC = childVCs;
}

- (void)initialize {
    [super initialize];
    
    self.sliderBarHeight = 44;
    self.tabsResultSubject = [RACSubject subject];
    self.segmentValueChangedSubject = [RACSubject subject];
    self.tabsLoadFinishSignal = [RACSubject subject];
}

- (void)loadTabs{
    switch (self.loadType) {
        case THKDynamicTabsLoadType_API:
            [self requestConfigTabs];
            break;
        case THKDynamicTabsLoadType_Model:
            [self parseTabs:self.segmentTabs];
            break;
        case THKDynamicTabsLoadType_Data:
            [self praseData];
            break;
        default:
            break;
    }
}

/// 方式1.解析模型
- (void)parseTabs:(NSArray<THKDynamicTabsModel *> *)tabs {

    NSMutableArray *arrayVC = [NSMutableArray arrayWithCapacity:tabs.count];
    NSMutableArray *arraySegment = [NSMutableArray arrayWithCapacity:tabs.count];
    NSMutableArray *arrayTitles = [NSMutableArray arrayWithCapacity:tabs.count];
    
    self.sliderBarDefaultSelected = 0;
    [tabs enumerateObjectsUsingBlock:^(THKDynamicTabsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.targetUrl && obj.targetUrl.length > 0) {
            UIViewController *vc = [self existInOldTabsWithPath:obj.targetUrl];
            if (vc == nil) {
                if ([obj.targetUrl hasPrefix:TRouter_Scheme] || [obj.targetUrl hasPrefix:@"http"]) {
                    vc = [[TRouter routerFromUrl:obj.targetUrl] build];
                } else {
                    vc = [[TRouter routerWithName:obj.targetUrl] build];
                }
            } else {
                //如果是已存在的页面，则通知刷新
                if ([vc conformsToProtocol:@protocol(THKDynamicTabsProtocol)]) {
                    UIViewController<THKDynamicTabsProtocol> *pVC = (UIViewController<THKDynamicTabsProtocol> *)vc;
                    if ([pVC respondsToSelector:@selector(needReloadData)]) {
                        //延迟执行刷新动作，如果立即刷新的话，在刷新的同时tab又在做切换，导致看不到下拉刷新的动画
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [pVC needReloadData];
                        });
                    }
                }
            }
            if (self.dynamicTabsModelViewControllerBlock) {
                self.dynamicTabsModelViewControllerBlock(vc,obj);
            }
            
            if (obj.style == THKDynamicTabButtonStyle_ImageOnly) {
                obj.iconImage.width = (14 / obj.iconImage.height) * obj.iconImage.width;
                obj.iconImage.height = 14;
            } else if (obj.style == THKDynamicTabButtonStyle_TextAndImage) {
                obj.iconImage.height = 16;
                obj.iconImage.width = 16;
            }
            if (!obj.displayModel) {
                obj.displayModel = [[THKDynamicTabDisplayModel alloc] init];
            }
            if (self.configDynamicTabButtonModelBlock) {
                self.configDynamicTabButtonModelBlock(obj.displayModel,obj.tabId, obj.title);
            }

            if (vc) {
                [arrayVC addObject:vc];
                [arraySegment addObject:obj];
                [arrayTitles addObject:obj.title?:@""];
                if (obj.selected) {
                    self.sliderBarDefaultSelected = idx;
                }
            }
        }
    }];
    self.segmentTabs = arraySegment;
    self.segmentTitles = arrayTitles;
    self.arrayChildVC = arrayVC;
    [self.tabsResultSubject sendNext:nil];
}

/// 方式2. 静态数据
- (void)praseData{
    @weakify(self);
    NSArray <THKDynamicTabsModel *>* tabs = [self.segmentTitles tmui_map:^id _Nonnull(NSString * _Nonnull item) {
        @strongify(self);
        THKDynamicTabsModel *m = [[THKDynamicTabsModel alloc] init];
        m.displayModel = [THKDynamicTabDisplayModel new];
        m.displayModel.normalFont = UIFont(16);
        m.displayModel.selectedFont = UIFontMedium(16);
        m.title = item;
        if (self.configDynamicTabButtonModelBlock) {
            self.configDynamicTabButtonModelBlock(m.displayModel,m.tabId, m.title);
        }
        return m;
    }];
    self.segmentTabs = tabs;
    
    [self.tabsResultSubject sendNext:nil];
}

/// 方式3. 调用接口
- (void)requestConfigTabs {
    {//重新请求时，取消上一次还未执行完的请求
        [self.curReq cancel];
        self.curReq = nil;
    }
    self.isRequestSuccess = NO;
    
    if (self.wholeCode == nil || self.wholeCode.length <= 0) {
        [self parseTabs:self.segmentTabs];
        return;
    }
    
    NSAssert((self.wholeCode && self.wholeCode.length > 0), @"you have to set the valid 'wholeCode'");
    THKDynamicTabsRequest *request = [[THKDynamicTabsRequest alloc] init];
    if ([self.wholeCode isEqualToString:kDynamicTabsWholeCodeCompanyDetail]) {
        request = [[THKCompanyDetailTabRequest alloc] init];
    }
    request.wholeCode = self.wholeCode;
    request.extraParam = self.extraParam;
    self.curReq = request;
    @weakify(self);
    [request sendSuccess:^(THKDynamicTabsResponse *response) {
        @strongify(self);
        if (response.status == THKStatusSuccess && response.data && response.data.count > 0) {
            self.isRequestSuccess = YES;
            [self parseTabs:response.data];
        } else {
            self.isRequestSuccess = NO;
            [self parseTabs:self.segmentTabs];
        }
        
    } failure:^(NSError * _Nonnull error) {
        @strongify(self);
        self.isRequestSuccess = NO;
        [self parseTabs:self.segmentTabs];
    }];
}

/**
 查找新的路由是否已经有对应的vc，如果有则用现有的，否则要新建一个vc
 */
- (UIViewController *)existInOldTabsWithPath:(NSString *)path {
    if (path == nil || path.length == 0) {
        return nil;
    }
    __block UIViewController *vc = nil;
    [self.segmentTabs enumerateObjectsUsingBlock:^(THKDynamicTabsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.targetUrl containsString:path]) {
            vc = [self.arrayChildVC safeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
    return vc;
}

- (NSArray<THKDynamicTabsModel *> *)segmentTabs {
    if (!_segmentTabs) {
        _segmentTabs = @[];
    }
    return _segmentTabs;
}

- (void)requestBadgeWithType:(THKTabBadgeType)type successBlock:(T8TObjBlock)successBlock failBlock:(T8TObjBlock)failBlock {
    if (![kCurrentUser isLoginStatus]) {
        return;
    }
    THKTabBadgeRequest  *request = [[THKTabBadgeRequest alloc] init];
    request.badgeType = type;
    @weakify(self);
    [request sendSuccess:^(THKTabBadgeResponse *response) {
        @strongify(self);
        if (response.status == THKStatusSuccess) {
            [self.segmentTabs enumerateObjectsUsingBlock:^(THKDynamicTabsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (type == THKTabBadgeType_Follow && [obj.targetUrl containsString:THKRouterPage_CommunityFollowList]) {
                    obj.displayModel.showBadge = response.data.hasUnread;
                    if (successBlock) {
                        successBlock(obj);
                    }
                    *stop = YES;
                }
            }];
            
        } else {
            if (failBlock) {
                failBlock(response.errorMsg?:k_toast_msg_reqFail);
            }
        }
    } failure:^(NSError * _Nonnull error) {
        if (failBlock) {
            failBlock(k_toast_msg_weakNet);
        }
    }];
}

- (void)requestClearBadgeWithType:(THKTabBadgeType)type successBlock:(T8TObjBlock)successBlock failBlock:(T8TObjBlock)failBlock {
    
    if (![kCurrentUser isLoginStatus]) {
        return;
    }
    THKTabClearBadgeRequest  *request = [[THKTabClearBadgeRequest alloc] init];
    request.badgeType = type;
    [request sendSuccess:^(THKResponse *response) {
        if (response.status == THKStatusSuccess) {
        } else {
            if (failBlock) {
                failBlock(response.errorMsg?:k_toast_msg_reqFail);
            }
        }
    } failure:^(NSError * _Nonnull error) {
        if (failBlock) {
            failBlock(k_toast_msg_weakNet);
        }
    }];
}

@end
