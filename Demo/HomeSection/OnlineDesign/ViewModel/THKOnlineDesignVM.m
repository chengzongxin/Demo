//
//  THKOnlineDesignVM.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignVM.h"

typedef enum : NSUInteger {
    THKOnlineDesignAudioOperateType_None,
    THKOnlineDesignAudioOperateType_Add,
    THKOnlineDesignAudioOperateType_Del,
} THKOnlineDesignAudioOperateType;

@interface THKOnlineDesignVM ()

@property (nonatomic, strong) THKRequestCommand *requestCommand;

@property (nonatomic, strong) RACCommand *addAudioCommand;

@property (nonatomic, strong) RACCommand *deleteAudioCommand;

@property (nonatomic, strong) RACSubject *refreshSignal;

@property (nonatomic, strong) RACSubject *emptySignal;

@property (nonatomic, strong) NSArray <THKOnlineDesignSectionModel *> *datas;

@property (nonatomic, strong) TMUIOrderedDictionary *cellDict;

@end

@implementation THKOnlineDesignVM

- (void)initialize{
    [super initialize];
    
    self.refreshSignal = RACSubject.subject;
    self.emptySignal = RACSubject.subject;
    
    @weakify(self);
    [self.requestCommand.nextSignal subscribe:self.refreshSignal];
    [self.requestCommand.errorSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.emptySignal sendNext:@(TMEmptyContentTypeNetErr)];
    }];
}



- (TMUIOrderedDictionary *)cellDict{
    if (!_cellDict) {
        _cellDict = [[TMUIOrderedDictionary alloc] initWithKeysAndObjects:
                     @0,THKOnlineDesignBaseCell.class,
                     @1,THKOnlineDesignHouseSearchAreaCell.class,
//                     @1,THKOnlineDesignHouseTypeCell.class,
                     @2,THKOnlineDesignHouseStyleCell.class,
                     @3,THKOnlineDesignHouseBudgetCell.class,
                     @4,THKOnlineDesignHouseDemandCell.class,
                     @5,THKOnlineDesignHouseNameCell.class, //  废弃
        nil];
    }
    return _cellDict;
}


- (THKRequestCommand *)requestCommand{
    if (!_requestCommand) {
        _requestCommand = [THKRequestCommand commandMake:^(id  _Nonnull input, id<RACSubscriber>  _Nonnull subscriber) {
            
            if (self.datas.count == 0) {
                
                NSMutableArray *arr = [NSMutableArray array];
                THKOnlineDesignSectionModel *section1 = [[THKOnlineDesignSectionModel alloc] init];
                section1.title = @"我家小区户型";
                THKOnlineDesignItemModel *item1 = [[THKOnlineDesignItemModel alloc] init];
                item1.type = THKOnlineDesignItemDataType_HouseType;
                item1.cellClass = self.cellDict[@(item1.type)];
                item1.picUrl = @"https://pic.to8to.com/live/day_210918/20210918_a4256baeb11537c067e8ksHmwDZgxbxI.jpg";
                item1.itemSize = CGSizeMake(TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.vcLayout.sectionInset), 50);
                section1.item = item1;
                [arr addObject:section1];
                
//                THKOnlineDesignSectionModel *section2 = [[THKOnlineDesignSectionModel alloc] init];
//                section2.title = @"我家小区名称";
//                THKOnlineDesignItemModel *item2 = [[THKOnlineDesignItemModel alloc] init];
//                item2.type = 2;
//                item2.houseAreaName = @"瑞雪春堂";
//                section2.item = item2;
//                [arr addObject:section2];
                
                CGFloat column = 4;
                CGFloat width = floor((TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.vcLayout.sectionInset) - (self.vcLayout.minimumInteritemSpacing)*(column - 1))/column);
                CGSize item3Size = CGSizeMake(width, 50);
                
                THKOnlineDesignSectionModel *section2 = [[THKOnlineDesignSectionModel alloc] init];
                section2.title = @"我喜欢的装修风格";
                THKOnlineDesignItemModel *item2 = [[THKOnlineDesignItemModel alloc] init];
                item2.type = THKOnlineDesignItemDataType_HouseStyle;
                item2.cellClass = self.cellDict[@(item2.type)];
                item2.itemSize = item3Size;
                item2.houseStyles = @[@"现代简约",@"日式",@"原木",@"日式",@"原木",@"日式"];
                section2.item = item2;
                [arr addObject:section2];
                
                THKOnlineDesignSectionModel *section3 = [[THKOnlineDesignSectionModel alloc] init];
                section3.title = @"我的装修预算";
                THKOnlineDesignItemModel *item3 = [[THKOnlineDesignItemModel alloc] init];
                item3.type = THKOnlineDesignItemDataType_HouseBudget;
                item3.cellClass = self.cellDict[@(item3.type)];
                item3.itemSize = item3Size;
                item3.houseBudget = @[@"3-5",@"6-10",@"11-20",@"6-10",@"11-20",@"6-10"];
                section3.item = item3;
                [arr addObject:section3];
                
                
                
                THKOnlineDesignSectionModel *section4 = [[THKOnlineDesignSectionModel alloc] init];
                section4.title = @"需求描述";
                THKOnlineDesignItemModel *item4 = [[THKOnlineDesignItemModel alloc] init];
                item4.type = THKOnlineDesignItemDataType_HouseDemand;
                item4.cellClass = self.cellDict[@(item4.type)];
                
                CGSize item4Size = [self demandSize:item4.demandDesc];
                item4.itemSize = item4Size;
                section4.item = item4;
                [arr addObject:section4];
                
                self.datas = arr;
            }else{
//                RACTuple *tuple = (RACTuple *)input;
                RACTupleUnpack(id typeID,id data) = input;
                THKOnlineDesignAudioOperateType type = [typeID integerValue];
                
                if (type == THKOnlineDesignAudioOperateType_Add) {
                    THKAudioDescription *audioData = data;
                    // 增加录音
                    THKOnlineDesignSectionModel *section4 = [self getDemandSection];
                    if (section4.item.demandDesc.count == 0) {
                        section4.item.demandDesc = [NSMutableArray array];
                    }
                    section4.item.demandDesc = [section4.item.demandDesc tmui_arrayByAddObject:audioData];
                    CGSize item4Size = [self demandSize:section4.item.demandDesc];
                    section4.item.itemSize = item4Size;
                }else if (type == THKOnlineDesignAudioOperateType_Del){
                    NSInteger idx = [data integerValue];
                    // 删除录音
                    THKOnlineDesignSectionModel *section4 = [self getDemandSection];
                    section4.item.demandDesc = [section4.item.demandDesc tmui_arrayByRemovingObjectAtIndex:idx];
                    CGSize item4Size = [self demandSize:section4.item.demandDesc];
                    section4.item.itemSize = item4Size;
                }
                
            }
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
    }
    return _requestCommand;
}

- (THKOnlineDesignSectionModel *)getDemandSection{
    THKOnlineDesignSectionModel *model = nil;
    for (THKOnlineDesignSectionModel *aModel in self.datas) {
        if (aModel.item.type == THKOnlineDesignItemDataType_HouseDemand) {
            model = aModel;
            break;
        }
    }
    return model;
}

- (CGSize)demandSize:(NSArray *)demands{
    // 32 高度，14的间隙
    CGFloat audioH = 0;
    NSInteger count = demands.count;
    if (count) {
        audioH = count * 32 + (count - 1) * 14 + 17;
    }
    return CGSizeMake(TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.vcLayout.sectionInset), audioH + 95 + 48);
}

- (RACCommand *)addAudioCommand{
    if (!_addAudioCommand) {
        @weakify(self);
        _addAudioCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [self.requestCommand execute:RACTuplePack(@(THKOnlineDesignAudioOperateType_Add),input)];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _addAudioCommand;
}

- (RACCommand *)deleteAudioCommand{
    if (!_deleteAudioCommand) {
        @weakify(self);
        _deleteAudioCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [self.requestCommand execute:RACTuplePack(@(THKOnlineDesignAudioOperateType_Del),input)];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _deleteAudioCommand;
}

@end
