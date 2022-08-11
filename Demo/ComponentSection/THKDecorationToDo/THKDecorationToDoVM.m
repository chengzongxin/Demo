//
//  THKDecorationToDoVM.m
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKDecorationToDoVM.h"
#import "THKDecorationUpcomingListRequest.h"
#import "THKDecorationUpcomingEditRequest.h"
#import "THKDecorationUpcomingEditResponse.h"

#define kTHKDecToDoCacheFilePath tmui_filePathAtDocumentWithName(@"DecorationToDo.txt")

@interface THKDecorationToDoVM ()

@property (nonatomic, strong) NSString *subtitle;

@property (nonatomic, copy) NSArray <THKDecorationUpcomingModel *> *stageList;

@property (nonatomic, copy) NSArray <THKDecorationUpcomingListModel *> *upcomingList;

@property (nonatomic, strong) RACSubject *emptySignal;

@property (nonatomic, strong) RACSubject *nodataSignal;

@property (nonatomic, strong) THKRequestCommand *editCommand;

@end

@implementation THKDecorationToDoVM


- (void)initialize{
    [super initialize];
    
    self.emptySignal = RACSubject.subject;
    self.nodataSignal = RACSubject.subject;
    
    @weakify(self);
    [self.requestCommand.nextSignal subscribeNext:^(THKDecorationUpcomingListResponse *  _Nullable x) {
        @strongify(self);
        
        self.subtitle = x.data.desc;
        self.stageList = x.data.stageList;
        NSMutableArray <THKDecorationUpcomingListModel *>*upcomingList = [NSMutableArray array];
        
        [self.stageList enumerateObjectsUsingBlock:^(THKDecorationUpcomingModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            [obj.upcomingList tmui_forEach:^(THKDecorationUpcomingListModel *model) {
                @strongify(self);
                // 是否打开
                // 如果有缓存，使用缓存
                THKDecorationUpcomingListCacheModel *cache = [self readUpcomingListCachWithMainId:model.mainId];
                if (cache) {
                    model.isOpen = cache.isOpen;
                }else{
                    model.isOpen = (model.completedNum < model.totalNum);
//                    // 保存缓存
                    [self saveUpcomingListCachWithMainId:model.mainId isOpen:model.isOpen];
                }
                
                // 把阶段名称透传主项
                model.serialNumber = obj.serialNumber;
                model.stageId = obj.stageId;
                model.stageName = obj.stageName;
                // 把阶段名称透传子项
                [model.childList tmui_forEach:^(THKDecorationUpcomingChildListModel *child) {
                    child.stageId = model.stageId;
                    child.stageName = model.stageName;
                }];
            }];
            
            [upcomingList addObjectsFromArray:obj.upcomingList];
        }];
        
        self.upcomingList = upcomingList;
        
    }];
    
    [self.requestCommand.errorSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.emptySignal sendNext:nil];
    }];
    
}

- (THKBaseRequest *)requestWithInput:(id)input{
    THKDecorationUpcomingListRequest *request = [[THKDecorationUpcomingListRequest alloc] init];
    return request;
}

- (void)editModelRequest:(THKDecorationUpcomingChildListModel *)model success:(void (^)(void))success fail:(void (^)(void))fail{
    THKDecorationUpcomingEditRequest *request = [[THKDecorationUpcomingEditRequest alloc] init];
    request.childId = model.childId;
    request.todoStatus = @(model.todoStatus).stringValue;
    [request sendSuccess:^(THKDecorationUpcomingEditResponse *  _Nonnull response) {
        if (response.status == THKStatusSuccess && response.data && (response.data.status == 0 || response.data.status == 200)) {
            !success?:success();
        }else{
            !fail?:fail();
        }
    } failure:^(NSError * _Nonnull error) {
        !fail?:fail();
    }];
}

- (THKRequestCommand *)editCommand{
    if (!_editCommand) {
        _editCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(THKDecorationUpcomingChildListModel * _Nonnull input) {
            THKDecorationUpcomingEditRequest *request = [[THKDecorationUpcomingEditRequest alloc] init];
            request.childId = input.childId;
            request.todoStatus = @(input.todoStatus).stringValue;
            return request;
        }];
    }
    return _editCommand;
}


- (void)saveUpcomingListCachWithMainId:(NSInteger)mainId isOpen:(BOOL)isOpen{
    if (mainId == 0) {
        return;
    }
    
    NSMutableArray <THKDecorationUpcomingListCacheModel *>* cacheModels;
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:kTHKDecToDoCacheFilePath];
    if ([arr isKindOfClass:NSArray.class]) {
        cacheModels = [arr mutableCopy];
    }else{
        cacheModels = [NSMutableArray array];
    }
    
    __block BOOL hasModel = NO;
    
    [cacheModels enumerateObjectsUsingBlock:^(THKDecorationUpcomingListCacheModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.mainId == mainId) {
            obj.isOpen = isOpen;
            hasModel = YES;
            *stop = YES;
        }
    }];
    
    if (!hasModel) {
        THKDecorationUpcomingListCacheModel *model = [[THKDecorationUpcomingListCacheModel alloc] init];
        model.mainId = mainId;
        model.isOpen = isOpen;
        [cacheModels addObject:model];
    }
    
    
    [NSKeyedArchiver archiveRootObject:cacheModels toFile:kTHKDecToDoCacheFilePath];
}

- (THKDecorationUpcomingListCacheModel *)readUpcomingListCachWithMainId:(NSInteger)mainId{
    
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:kTHKDecToDoCacheFilePath];
    if (![arr isKindOfClass:NSArray.class]) {
        return nil;
    }
    NSMutableArray <THKDecorationUpcomingListCacheModel *>* cacheModels = [arr mutableCopy];
    
    __block THKDecorationUpcomingListCacheModel *model = nil;
    [cacheModels enumerateObjectsUsingBlock:^(THKDecorationUpcomingListCacheModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.mainId == mainId) {
            model = obj;
            *stop = YES;
        }
    }];
    
    return model;
}

@end
