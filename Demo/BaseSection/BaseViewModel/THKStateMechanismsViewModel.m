//
//  THKStateMechanismsViewModel.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/24.
//

#import "THKStateMechanismsViewModel.h"

@interface THKStateMechanismsViewModel ()

@property (nonatomic, weak) UIView *vcView;

@property (nonatomic, weak) UIScrollView *vcScrollView;

@property (nonatomic, strong) THKRequestCommand *requestCommand;

@property (nonatomic, strong) RACSubject *emptySignal;

@property (nonatomic, strong) RACReplaySubject *loadingSignal;

@property (nonatomic, strong) RACReplaySubject *refreshSignal;

@property (nonatomic, strong, nullable) NSArray *data;

@property (nonatomic, copy) AppendDataBlock appendBlock;

@end

@implementation THKStateMechanismsViewModel



- (void)bindWithView:(UIView *)view scrollView:(UIScrollView *)scrollView appenBlock:(NSArray * _Nonnull (^)(THKResponse * _Nonnull))appendBlock{
    @weakify(self);
    self.vcView = view;
    self.vcScrollView = scrollView;
    self.appendBlock = appendBlock;
    NSAssert(self.requestCommand, @"must lazy init requestCommand");
    /// 状态更新
    [self.requestCommand.nextSignal subscribeNext:^(THKResponse *x) {
        @strongify(self);
        // 拼接数据
        NSInteger input = [self.requestCommand.inputValue integerValue];
        NSArray *newData = nil;
        if (self.appendBlock) {
            newData = self.appendBlock(x);
            if (input == 1) {
                self.data = newData;
            }else{
                self.data = [self.data arrayByAddingObjectsFromArray:newData];
            }
        }
        // 刷新界面
        if ([self.vcScrollView respondsToSelector:@selector(reloadData)]) {
            [self.vcScrollView performSelector:@selector(reloadData)];
        }
        
        // 空页面更新
        if (x.status != THKStatusSuccess) {
            [self.emptySignal sendNext:@(TMEmptyContentTypeServerErr)];
        }else if (self.data.count == 0) {
            [self.emptySignal sendNext:@(TMEmptyContentTypeNoData)];
        }else{
            [self.emptySignal sendNext:nil];
        }
        
        // 刷新控件状态更新
        if (input == 1) {
            [self.refreshSignal sendNext:@(THKRefreshStatus_EndRefreshing)];
            [self.refreshSignal sendNext:@(THKRefreshStatus_ResetNoMoreData)];
        }else if (newData.count == 0) {
            [self.refreshSignal sendNext:@(THKRefreshStatus_NoMoreData)];
        }
        
        [self.loadingSignal sendNext:@(THKLoadingStatus_Finish)];
    }];
    
    // 接口错误状态更新
    [self.requestCommand.errorSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.data = nil;
        [self.emptySignal sendNext:@(TMEmptyContentTypeNetErr)];
        [self.loadingSignal sendNext:@(THKLoadingStatus_Finish)];
    }];
    
    // 发送请求
    [self.loadingSignal sendNext:@(THKLoadingStatus_Loading)];
    [self.requestCommand execute:@1];
    
    
    /// 订阅更新UI
    // 空视图界面订阅
    [self.emptySignal subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x) {
            [TMEmptyView showEmptyInView:self.vcView contentType:x.integerValue];
        }else{
            [self.vcView.tmui_emptyView remove];
        }
    }];
    // 加载状态订阅
    [self.loadingSignal subscribeNext:^(NSNumber *x) {
        @strongify(self);
        NSLog(@"%@",x);
        [TMToast toast:(x.integerValue == THKLoadingStatus_Loading)?@"努力加载中...":@"加载完成"];
    }];
    
    // 刷新状态订阅
    [self.refreshSignal subscribeNext:^(NSNumber *x) {
        @strongify(self);
        THKRefreshStatus status = x.integerValue;
        if (status == THKRefreshStatus_EndRefreshing) {
            NSLog(@"停止刷新");
        }else if (status == THKRefreshStatus_ResetNoMoreData) {
            NSLog(@"重置头部");
        }else if (status == THKRefreshStatus_NoMoreData) {
            NSLog(@"没有更多数据");
        }
    }];
}


- (NSInteger)numberOfRows{
    NSInteger numberOfRows = 0;
    if ([self.vcScrollView isKindOfClass:UICollectionView.class]) {
        UICollectionView *collectionView = (UICollectionView *)self.vcScrollView;
        NSInteger section = [collectionView numberOfSections];
        for (int i = 0; i < section; i++) {
            NSInteger item = [collectionView numberOfItemsInSection:i];
            numberOfRows += item;
        }
    }else if ([self.vcScrollView isKindOfClass:UITableView.class]) {
        UITableView *tableView = (UITableView *)self.vcScrollView;
        NSInteger section = [tableView numberOfSections];
        for (int i = 0; i < section; i++) {
            NSInteger item = [tableView numberOfRowsInSection:i];
            numberOfRows += item;
        }
    }
    return numberOfRows;
}

- (THKRequestCommand *)requestCommand{
    if (!_requestCommand) {
        _requestCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            return [self requestWithInput:input];
        }];
    }
    return _requestCommand;
}

- (THKBaseRequest *)requestWithInput:(id)input{return nil;}

TMUI_PropertyLazyLoad(NSArray, data);
TMUI_PropertyLazyLoad(RACSubject, emptySignal)
TMUI_PropertyLazyLoad(RACReplaySubject, loadingSignal)
TMUI_PropertyLazyLoad(RACReplaySubject, refreshSignal)

@end
