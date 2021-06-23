//
//  THKMaterialHotRankVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/23.
//

#import "THKMaterialHotRankVM.h"

@interface THKMaterialHotRankVM ()

@property (nonatomic, strong) THKRequestCommand *requestCommand;

@property (nonatomic, strong, nullable) NSArray <THKMaterialHotListModel *> *data;

@property (nonatomic, strong) NSArray <NSArray *> *headerTitles;
@property (nonatomic, strong) NSArray <NSArray *> *icons;
@property (nonatomic, strong) NSArray <NSArray *> *titles;
@property (nonatomic, strong) NSArray <NSArray *> *subtitles;

@end

@implementation THKMaterialHotRankVM

- (void)initialize{
    @weakify(self);
    [self.requestCommand.nextSignal subscribeNext:^(THKMaterialHotListResponse *x) {
        @strongify(self);
        self.data = x.data;
    }];
    
    [self.requestCommand.errorSignal subscribeNext:^(id  _Nullable x) {
        self.data = nil;
    }];
    
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

@end
