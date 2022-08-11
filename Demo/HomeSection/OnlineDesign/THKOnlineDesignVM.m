//
//  THKOnlineDesignVM.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignVM.h"

@interface THKOnlineDesignVM ()

@property (nonatomic, strong) THKRequestCommand *requestCommand;

@property (nonatomic, strong) NSArray <THKOnlineDesignSectionModel *> *datas;

@end

@implementation THKOnlineDesignVM

- (THKRequestCommand *)requestCommand{
    if (!_requestCommand) {
        _requestCommand = [THKRequestCommand commandMake:^(id  _Nonnull input, id<RACSubscriber>  _Nonnull subscriber) {
            NSMutableArray *arr = [NSMutableArray array];
            
            THKOnlineDesignSectionModel *section1 = [[THKOnlineDesignSectionModel alloc] init];
            section1.title = @"我家小区户型";
            THKOnlineDesignItemModel *item1 = [[THKOnlineDesignItemModel alloc] init];
            item1.type = 1;
            item1.picUrl = @"https://pic.to8to.com/live/day_210918/20210918_a4256baeb11537c067e8ksHmwDZgxbxI.jpg";
            section1.item = item1;
            [arr addObject:section1];
            
            THKOnlineDesignSectionModel *section2 = [[THKOnlineDesignSectionModel alloc] init];
            section2.title = @"我家小区名称";
            THKOnlineDesignItemModel *item2 = [[THKOnlineDesignItemModel alloc] init];
            item2.type = 2;
            item2.houseAreaName = @"瑞雪春堂";
            section2.item = item2;
            [arr addObject:section2];
            
            THKOnlineDesignSectionModel *section3 = [[THKOnlineDesignSectionModel alloc] init];
            section3.title = @"我喜欢的装修风格";
            THKOnlineDesignItemModel *item3 = [[THKOnlineDesignItemModel alloc] init];
            item3.type = 3;
            item3.houseStyles = @[@"现代简约",@"日式",@"原木"];
            section3.item = item3;
            [arr addObject:section3];
            
            THKOnlineDesignSectionModel *section4 = [[THKOnlineDesignSectionModel alloc] init];
            section4.title = @"我的装修预算";
            THKOnlineDesignItemModel *item4 = [[THKOnlineDesignItemModel alloc] init];
            item4.type = 4;
            item4.houseBudget = @[@"3-5",@"6-10",@"11-20"];
            section4.item = item4;
            [arr addObject:section4];
            
            THKOnlineDesignSectionModel *section5 = [[THKOnlineDesignSectionModel alloc] init];
            section5.title = @"需求描述";
            THKOnlineDesignItemModel *item5 = [[THKOnlineDesignItemModel alloc] init];
            item5.type = 5;
            item5.demandDesc = @[@"123",@"345"];
            section5.item = item5;
            [arr addObject:section5];
            
            self.datas = arr;
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
    }
    return _requestCommand;
}

@end
