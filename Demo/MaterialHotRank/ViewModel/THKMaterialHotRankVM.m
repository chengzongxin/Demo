//
//  THKMaterialHotRankVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/23.
//

#import "THKMaterialHotRankVM.h"

@interface THKMaterialHotRankVM ()

@property (nonatomic, strong) THKRequestCommand *requestCommand;

@property (nonatomic, strong) RACSubject *emptySignal;

@property (nonatomic, strong) RACReplaySubject *loadingSignal;

@property (nonatomic, strong) RACReplaySubject *refreshSignal;

@property (nonatomic, strong, nullable) NSArray <THKMaterialHotListModel *> *data;

@property (nonatomic, assign) NSInteger inputPage;

@end

@implementation THKMaterialHotRankVM

- (void)initialize{
    @weakify(self);
    [self.requestCommand.nextSignal subscribeNext:^(THKMaterialHotListResponse *x) {
        @strongify(self);
        if (x.status != THKStatusSuccess) {
            [self.emptySignal sendNext:@(TMEmptyContentTypeServerErr)];
        }else if (x.data.count == 0) {
            [self.emptySignal sendNext:@(TMEmptyContentTypeNoData)];
        }else{
            [self.emptySignal sendNext:nil];
        }
        
        if (self.inputPage == 1) {
            [self.refreshSignal sendNext:@(THKRefreshStatus_EndRefreshing)];
            [self.refreshSignal sendNext:@(THKRefreshStatus_ResetNoMoreData)];
        }else if (x.data == 0) {
            [self.refreshSignal sendNext:@(THKRefreshStatus_NoMoreData)];
        }
        
        self.data = x.data;
        [self.loadingSignal sendNext:@(THKLoadingStatus_Finish)];
    }];
    
    [self.requestCommand.errorSignal subscribeNext:^(id  _Nullable x) {
        self.data = nil;
        [self.emptySignal sendNext:@(TMEmptyContentTypeNetErr)];
        [self.loadingSignal sendNext:@(THKLoadingStatus_Finish)];
    }];
    
    [self.loadingSignal sendNext:@(THKLoadingStatus_Loading)];
    [self.requestCommand execute:nil];
}

- (THKRequestCommand *)requestCommand{
    if (!_requestCommand) {
        _requestCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            return [[THKMaterialHotListRequest alloc] init];
        }];
    }
    return _requestCommand;
}

TMUI_PropertyLazyLoad(RACSubject, emptySignal)
TMUI_PropertyLazyLoad(RACReplaySubject, loadingSignal)

@end
