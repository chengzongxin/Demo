//
//  THKDecorationToDoVM.m
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKDecorationToDoVM.h"
#import "THKMaterialHotListRequest.h"
@interface THKDecorationToDoVM ()

@property (nonatomic, copy) NSArray <THKDecorationToDoSection *>*sections;

@end

@implementation THKDecorationToDoVM


- (void)initialize{
    [super initialize];
    
    @weakify(self);
    [self.requestCommand.nextSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        NSMutableArray <THKDecorationToDoSection *>*sections = [NSMutableArray array];
        
        for (int i = 0; i < 8; i++) {
            THKDecorationToDoSection *section = [[THKDecorationToDoSection alloc] init];
            NSMutableArray *items = [NSMutableArray array];
            for (int j = 0; j < 10; j++) {
                THKDecorationToDoItem *item = [[THKDecorationToDoItem alloc] init];
                item.title = [NSString stringWithFormat:@"二级阶段-%d",j];
                item.subtitle = [NSString stringWithFormat:@"阶段描述-%d",j];
                [items addObject:item];
            }
            section.stageName = [NSString stringWithFormat:@"阶段%d",i];
            section.items = items;
            [sections addObject:section];
        }
        self.sections = sections;
        
        
        
        
    }];
}

- (THKBaseRequest *)requestWithInput:(id)input{
    THKMaterialHotListRequest *request = [[THKMaterialHotListRequest alloc] init];
    request.page = 1;
    request.size = 10;
    return request;
}


@end
