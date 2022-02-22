//
//  THKSelectMaterialMainVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKSelectMaterialHomeVM.h"
@interface THKSelectMaterialHomeVM ()

@property (nonatomic, strong) RACCommand *requestTab;
@property (nonatomic, strong) NSArray<THKDynamicTabsModel *> *segmentTitles;
@end

@implementation THKSelectMaterialHomeVM

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
            model.targetUrl = [NSString stringWithFormat:@"%@://%@%@?categoryId=1", TRouter_Scheme, TRouter_Build_Host,THKRouterPage_MaterialHomeTab];
            model.origin = THKDynamicConfigOriginType_HomePage;
            [arrayTemp addObject:model];
        }];
        _segmentTitles = arrayTemp;
    }
    return _segmentTitles;
}


- (void)initialize{
    [super initialize];
    
    THKMaterialV3IndexTopTabRequest *request = [[THKMaterialV3IndexTopTabRequest alloc] init];
    [request.rac_requestSignal subscribeNext:^(THKMaterialV3IndexTopTabResponse *x) {
        NSLog(@"%@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}

//- (THKRequestCommand *)requestTab{
//    if (!_requestTab) {
//        _requestTab = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
//            return [THKMaterialV3IndexTopTabRequest new];
//        }];
//    }
//    return _requestTab;
//}


- (RACCommand *)requestTab{
    if (!_requestTab) {
        _requestTab = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                THKMaterialV3IndexTopTabRequest *request = [[THKMaterialV3IndexTopTabRequest alloc] init];
                [request.rac_requestSignal subscribeNext:^(id  _Nullable x) {
                    [subscriber sendNext:x];
                } error:^(NSError * _Nullable error) {
                    [subscriber sendError:error];
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    [request cancel];
                }];
            }];
        }];
        return _requestTab;
    }
    return _requestTab;
}

@end
