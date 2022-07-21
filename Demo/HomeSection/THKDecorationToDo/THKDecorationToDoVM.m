//
//  THKDecorationToDoVM.m
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKDecorationToDoVM.h"
#import "THKDecorationUpcomingListRequest.h"
#import "THKDecorationUpcomingEditRequest.h"

@interface THKDecorationToDoVM ()


@property (nonatomic, copy) NSArray <THKDecorationUpcomingModel *> *stageList;

@property (nonatomic, copy) NSArray <THKDecorationUpcomingListModel *> *upcomingList;

@property (nonatomic, strong) RACSubject *emptySignal;

@property (nonatomic, strong) RACSubject *nodataSignal;

@property (nonatomic, strong) THKRequestCommand *editCommand;
//
//@property (nonatomic, strong, readwrite) THKRequestCommand *listCommand;

@end

@implementation THKDecorationToDoVM


- (void)initialize{
    [super initialize];
    
    self.emptySignal = RACSubject.subject;
    self.nodataSignal = RACSubject.subject;
    
    @weakify(self);
    [self.requestCommand.nextSignal subscribeNext:^(THKDecorationUpcomingListResponse *  _Nullable x) {
        @strongify(self);
        
        self.stageList = x.data;
        NSMutableArray <THKDecorationUpcomingListModel *>*upcomingList = [NSMutableArray array];
        
        [self.stageList enumerateObjectsUsingBlock:^(THKDecorationUpcomingModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [upcomingList addObjectsFromArray:obj.upcomingList];
        }];
        
        [upcomingList tmui_forEach:^(THKDecorationUpcomingListModel * model) {
            model.isOpen = (model.completedNum < model.totalNum);
        }];
        
        self.upcomingList = upcomingList;
        
        
//        NSMutableArray <THKDecorationToDoSection *>*sections = [NSMutableArray array];
//
//        for (int i = 0; i < 8; i++) {
//            THKDecorationToDoSection *section = [[THKDecorationToDoSection alloc] init];
//            NSMutableArray *items = [NSMutableArray array];
//            for (int j = 0; j < 10; j++) {
//                THKDecorationToDoItem *item = [[THKDecorationToDoItem alloc] init];
//                item.title = [NSString stringWithFormat:@"二级阶段-%d",j];
//                item.subtitle = [NSString stringWithFormat:@"阶段描述-%d",j];
//                [items addObject:item];
//            }
//            section.stageName = [NSString stringWithFormat:@"阶段%d",i];
//            section.items = items;
//            [sections addObject:section];
//        }
//        self.sections = sections;
    }];
    
    [self.requestCommand.errorSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.emptySignal sendNext:nil];
    }];
    
    
//    [self.stageCommand.nextSignal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
//    [self.listCommand.nextSignal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
}

- (THKBaseRequest *)requestWithInput:(id)input{
    THKDecorationUpcomingListRequest *request = [[THKDecorationUpcomingListRequest alloc] init];
    return request;
}



- (THKRequestCommand *)editCommand{
    if (!_editCommand) {
        _editCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            THKDecorationUpcomingEditRequest *request = [[THKDecorationUpcomingEditRequest alloc] init];
            RACTupleUnpack(NSNumber *childId,NSString *todoStatus) = input;
            request.childId = childId.integerValue;
            request.todoStatus = todoStatus;
            return request;
        }];
    }
    return _editCommand;
}


//- (THKRequestCommand *)listCommand{
//    if (!_listCommand) {
//        _listCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
//            return THKDecorationUpcomingListRequest.new;
//        }];
//    }
//    return _listCommand;
//}

@end
