//
//  THKPKPlanDetailContainerVM.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2023/8/18.
//  Copyright © 2023 binxun. All rights reserved.
//

#import "THKPKPlanDetailContainerVM.h"

@interface THKPKPlanDetailContainerVM ()

@property (nonatomic, copy) NSArray<THKDynamicTabsModel *> *segmentTitles;

@end

@implementation THKPKPlanDetailContainerVM
- (NSArray<THKDynamicTabsModel *> *)segmentTitles {
    if (!_segmentTitles) {
        NSArray *defaultTitles = @[@"推荐",@"热门"];
        NSMutableArray *arrayTemp = @[].mutableCopy;
        [defaultTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            THKDynamicTabsModel *model = [[THKDynamicTabsModel alloc] init];
            model.title = obj;
            model.targetType = THKDynamicTabTargetType_Origin;
            model.position = idx;
            model.selected = (idx == 0);
            model.origin = THKDynamicConfigOriginType_HomePage;
//            model.targetUrl = [NSString stringWithFormat:@"%@://%@%@?ugc_id=257603", TRouter_Scheme, TRouter_Build_Host,THKRouterPage_PKPlanDetailContent,idx];
            [arrayTemp addObject:model];
        }];
        _segmentTitles = arrayTemp;
    }
    return _segmentTitles;
}
@end
