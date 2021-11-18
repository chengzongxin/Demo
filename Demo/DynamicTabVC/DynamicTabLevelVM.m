//
//  DynamicTabLevelVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/18.
//

#import "DynamicTabLevelVM.h"

@interface DynamicTabLevelVM ()
@property (nonatomic, strong) NSArray<THKDynamicTabsModel *> *segmentTitles;

@end

@implementation DynamicTabLevelVM

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
//            model.selected = NO;
//            if (idx == 0) {// 关注
//                model.targetUrl = [NSString stringWithFormat:@"%@://%@%@", TRouter_Scheme, TRouter_Build_Host,THKRouterPage_CommunityFollowList];
//                model.origin = THKDynamicConfigOriginType_CommunityFollow;
//            }
//            else if (idx == 1) {// 推荐
//                model.selected = YES;
//                model.targetUrl = [NSString stringWithFormat:@"%@://%@%@?wholeCode=index", TRouter_Scheme, TRouter_Build_Host,THKRouterPage_HomeRecommendNew];
//                model.origin = THKDynamicConfigOriginType_HomePage;
//            }else{// 推荐
                model.selected = idx == 0;
                model.targetUrl = [NSString stringWithFormat:@"%@://%@%@?wholeCode=index", TRouter_Scheme, TRouter_Build_Host,THKRouterPage_HomeRecommendNew];
                model.origin = THKDynamicConfigOriginType_HomePage;
//            }
            [arrayTemp addObject:model];
        }];
        _segmentTitles = arrayTemp;
    }
    return _segmentTitles;
}
@end
