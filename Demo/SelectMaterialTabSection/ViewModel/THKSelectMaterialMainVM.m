//
//  THKSelectMaterialMainVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialMainVM.h"

@interface THKSelectMaterialMainVM ()

@property (nonatomic, strong) NSArray<THKDynamicTabsModel *> *segmentTitles;

@end

@implementation THKSelectMaterialMainVM

#pragma mark - lazy

- (NSArray<THKDynamicTabsModel *> *)segmentTitles {
    if (!_segmentTitles) {
        NSArray *defaultTitles = @[@"瓷砖",@"地板",@"门窗",@"涂料",@"全屋定制"];
        NSMutableArray *arrayTemp = @[].mutableCopy;
        [defaultTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            THKDynamicTabsModel *model = [[THKDynamicTabsModel alloc] init];
            model.title = obj;
            model.targetType = THKDynamicTabTargetType_Origin;
            model.position = idx;
            model.selected = (idx == 0);
            model.targetUrl = [NSString stringWithFormat:@"%@://%@%@?wholeCode=index", TRouter_Scheme, TRouter_Build_Host,THKRouterPage_MaterialHomeTab];
            model.origin = THKDynamicConfigOriginType_HomePage;
            [arrayTemp addObject:model];
        }];
        _segmentTitles = arrayTemp;
    }
    return _segmentTitles;
}

@end
