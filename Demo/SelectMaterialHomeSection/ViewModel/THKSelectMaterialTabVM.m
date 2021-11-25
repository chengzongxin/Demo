//
//  THKSelectMaterialVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialTabVM.h"

@interface THKSelectMaterialTabVM ()
@property (nonatomic, strong) THKRequestCommand *requestTab;
@property (nonatomic, strong) NSArray<THKDynamicTabsModel *> *segmentTitles;
@end

@implementation THKSelectMaterialTabVM

#pragma mark - lazy

- (NSArray<THKDynamicTabsModel *> *)segmentTitles {
    if (!_segmentTitles) {
        NSArray *defaultTitles = @[@"交流圈",@"爆款好货"];
        NSMutableArray *arrayTemp = @[].mutableCopy;
        [defaultTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            THKDynamicTabsModel *model = [[THKDynamicTabsModel alloc] init];
            model.title = obj;
            model.targetType = THKDynamicTabTargetType_Origin;
            model.position = idx;
            model.selected = (idx == 0);
            model.targetUrl = [NSString stringWithFormat:@"%@://%@%@?wholeCode=index", TRouter_Scheme, TRouter_Build_Host,THKRouterPage_MaterialHomeTabCommunication];
            model.origin = THKDynamicConfigOriginType_HomePage;
            [arrayTemp addObject:model];
        }];
        _segmentTitles = arrayTemp;
    }
    return _segmentTitles;
}


- (THKRequestCommand *)requestTab{
    if (!_requestTab) {
        @weakify(self);
        _requestTab = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            @strongify(self);
            THKMaterialV3IndexEntranceRequest *request = [THKMaterialV3IndexEntranceRequest new];
            request.categoryId = self.categoryId;
            return request;
        }];
    }
    return _requestTab;
}


@end
