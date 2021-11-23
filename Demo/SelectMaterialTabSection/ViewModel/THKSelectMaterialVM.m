//
//  THKSelectMaterialVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialVM.h"

@interface THKSelectMaterialVM ()
@property (nonatomic, strong) NSArray<THKDynamicTabsModel *> *segmentTitles;
@end

@implementation THKSelectMaterialVM

#pragma mark - lazy

- (NSArray<THKDynamicTabsModel *> *)segmentTitles {
    if (!_segmentTitles) {
        NSArray *defaultTitles = @[@"推荐1",@"推荐2",@"推荐3",@"推荐4",@"推荐5"];
        NSMutableArray *arrayTemp = @[].mutableCopy;
        [defaultTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            THKDynamicTabsModel *model = [[THKDynamicTabsModel alloc] init];
            model.title = obj;
            model.targetType = THKDynamicTabTargetType_Origin;
            model.position = idx;
            model.selected = (idx == 0);
            if ([obj isEqualToString:@"关注"]) {// 关注
                model.targetUrl = [NSString stringWithFormat:@"%@://%@%@", TRouter_Scheme, TRouter_Build_Host,THKRouterPage_CommunityFollowList];
                model.origin = THKDynamicConfigOriginType_CommunityFollow;
            }else{// 推荐
                model.targetUrl = [NSString stringWithFormat:@"%@://%@%@?wholeCode=index", TRouter_Scheme, TRouter_Build_Host,THKRouterPage_HomeRecommendNew];
                model.origin = THKDynamicConfigOriginType_HomePage;
            }
            [arrayTemp addObject:model];
        }];
        _segmentTitles = arrayTemp;
    }
    return _segmentTitles;
}

@end
