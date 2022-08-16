//
//  THKOnlineDesignVM.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignVM.h"

typedef enum : NSUInteger {
    THKOnlineDesignOperateType_None,
    THKOnlineDesignOperateType_SelectHouseType,
    THKOnlineDesignOperateType_AddAudio,
    THKOnlineDesignOperateType_DelAudio,
} THKOnlineDesignOperateType;

@interface THKOnlineDesignVM ()

@property (nonatomic, strong) THKRequestCommand *requestCommand;

@property (nonatomic, strong) RACCommand *selectHouseTypeCommand;

@property (nonatomic, strong) RACCommand *addAudioCommand;

@property (nonatomic, strong) RACCommand *deleteAudioCommand;

@property (nonatomic, strong) RACSubject *refreshSignal;

@property (nonatomic, strong) RACSubject *emptySignal;

@property (nonatomic, strong) NSArray <THKOnlineDesignSectionModel *> *datas;

@property (nonatomic, strong) TMUIOrderedDictionary *cellDict;


@property (nonatomic, strong) NSString *topImgUrl;
@property (nonatomic, strong) NSString *topContent1;
@property (nonatomic, strong) NSString *topContent2;
@property (nonatomic, strong) NSString *topContent3;

@end

@implementation THKOnlineDesignVM

- (void)initialize{
    [super initialize];
    
    self.refreshSignal = RACSubject.subject;
    self.emptySignal = RACSubject.subject;
    
    @weakify(self);
//    [self.requestCommand.nextSignal subscribe:self.refreshSignal];
    [self.requestCommand.nextSignal subscribeNext:^(id _Nullable x) {
        @strongify(self);
        [self.refreshSignal sendNext:nil];
    }];
    
    [self.requestCommand.errorSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.emptySignal sendNext:@(TMEmptyContentTypeNetErr)];
    }];
}



- (TMUIOrderedDictionary *)cellDict{
    if (!_cellDict) {
        _cellDict = [[TMUIOrderedDictionary alloc] initWithKeysAndObjects:
                     @(THKOnlineDesignItemDataType_None),THKOnlineDesignBaseCell.class,
                     @(THKOnlineDesignItemDataType_HouseType),THKOnlineDesignHouseSearchAreaCell.class,
                     @(THKOnlineDesignItemDataType_HouseStyle),THKOnlineDesignHouseStyleCell.class,
                     @(THKOnlineDesignItemDataType_HouseBudget),THKOnlineDesignHouseBudgetCell.class,
                     @(THKOnlineDesignItemDataType_HouseDemand),THKOnlineDesignHouseDemandCell.class,
                     @(THKOnlineDesignItemDataType_HouseTypeModel),THKOnlineDesignHouseTypeCell.class, // 有户型
                     @6,THKOnlineDesignHouseNameCell.class, //  废弃
        nil];
    }
    return _cellDict;
}


- (THKRequestCommand *)requestCommand{
    if (!_requestCommand) {
        _requestCommand = [THKRequestCommand commandMake:^(id  _Nonnull input, id<RACSubscriber>  _Nonnull subscriber) {
            
            if (input == nil) {
               
                THKOnlineDesignHomeConfigRequest *request = [THKOnlineDesignHomeConfigRequest new];
                [request.rac_requestSignal subscribeNext:^(THKOnlineDesignHomeConfigResponse * _Nullable x) {
                    
                    THKOnlineDesignHomeConfigModel *data = x.data;
                    
                    self.topImgUrl = data.topImgUrl;
                    self.topContent1 = data.topContent1;
                    self.topContent2 = data.topContent2;
                    self.topContent3 = data.topContent3;
                    
                    NSMutableArray *arr = [NSMutableArray array];
                    for (THKOnlineDesignHomeConfigColumnList *list in data.columnList) {
                        if ([list.columnType isEqualToString:@"housePlan"]) {
                            THKOnlineDesignSectionModel *section1 = [[THKOnlineDesignSectionModel alloc] init];
                            section1.title = list.title;// @"匹配我家小区的户型";
                            THKOnlineDesignItemModel *item1 = [[THKOnlineDesignItemModel alloc] init];
                            item1.type = THKOnlineDesignItemDataType_HouseType;
                            item1.cellClass = self.cellDict[@(item1.type)];
                            item1.itemSize = CGSizeMake(TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.vcLayout.sectionInset), 75);
                            section1.item = item1;
                            [arr addObject:section1];
                        }else if ([list.columnType isEqualToString:@"styleTag"]) {
                            CGFloat column = 4;
                            CGFloat width = floor((TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.vcLayout.sectionInset) - (self.vcLayout.minimumInteritemSpacing)*(column - 1))/column);
                            CGSize item3Size = CGSizeMake(width, 50);
                            
                            THKOnlineDesignSectionModel *section2 = [[THKOnlineDesignSectionModel alloc] init];
                            section2.title = list.title; //@"我喜欢的装修风格";
                            THKOnlineDesignItemModel *item2 = [[THKOnlineDesignItemModel alloc] init];
                            item2.type = THKOnlineDesignItemDataType_HouseStyle;
                            item2.cellClass = self.cellDict[@(item2.type)];
                            item2.itemSize = item3Size;
                            item2.houseStyles = [list.optionList tmui_map:^id _Nonnull(THKOnlineDesignHomeConfigColumnOptionList * _Nonnull item) {
                                return item.name;
                            }];
                            section2.item = item2;
                            [arr addObject:section2];
                        }else if ([list.columnType isEqualToString:@"budgetTag"]) {
                            CGFloat column = 4;
                            CGFloat width = floor((TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.vcLayout.sectionInset) - (self.vcLayout.minimumInteritemSpacing)*(column - 1))/column);
                            CGSize item3Size = CGSizeMake(width, 50);
                            
                            THKOnlineDesignSectionModel *section3 = [[THKOnlineDesignSectionModel alloc] init];
                            section3.title = list.title; //@"我的装修预算";
                            THKOnlineDesignItemModel *item3 = [[THKOnlineDesignItemModel alloc] init];
                            item3.type = THKOnlineDesignItemDataType_HouseBudget;
                            item3.cellClass = self.cellDict[@(item3.type)];
                            item3.itemSize = item3Size;
                            item3.houseBudget =  [list.optionList tmui_map:^id _Nonnull(THKOnlineDesignHomeConfigColumnOptionList * _Nonnull item) {
                                return item.name;
                            }];
                            section3.item = item3;
                            [arr addObject:section3];
                        }else if ([list.columnType isEqualToString:@"desc"]) {
                            
                            THKOnlineDesignSectionModel *section4 = [[THKOnlineDesignSectionModel alloc] init];
                            section4.title = list.title; //@"需求描述";
                            THKOnlineDesignItemModel *item4 = [[THKOnlineDesignItemModel alloc] init];
                            item4.type = THKOnlineDesignItemDataType_HouseDemand;
                            item4.cellClass = self.cellDict[@(item4.type)];
                            item4.demandModel = [THKOnlineDesignItemDemandModel new];
                            item4.demandModel.demandPlacehoder = list.desc;
                            
                            CGSize item4Size = [self demandSize:item4.demandModel.demandDesc];
                            item4.itemSize = item4Size;
                            section4.item = item4;
                            [arr addObject:section4];
                        }
                    }
                    self.datas = arr;
                    
                    [subscriber sendNext:nil];
                } error:^(NSError * _Nullable error) {
                    [subscriber sendError:error];
                } completed:^{
                    [subscriber sendCompleted];
                }];
                
            }else{
//                RACTuple *tuple = (RACTuple *)input;
                RACTupleUnpack(id typeID,id data) = input;
                THKOnlineDesignOperateType type = [typeID integerValue];
                if (type == THKOnlineDesignOperateType_SelectHouseType) {
                    THKOnlineDesignItemHouseTypeModel *model = data;
                    
                    THKOnlineDesignItemModel *item1 = [self getHouseTypeModel].item;
                    item1.type = THKOnlineDesignItemDataType_HouseTypeModel;
                    item1.houseType = model;
                    item1.cellClass = self.cellDict[@(item1.type)];
                    item1.itemSize = CGSizeMake(TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.vcLayout.sectionInset), 80);
                    
                } else if (type == THKOnlineDesignOperateType_AddAudio) {
                    THKAudioDescription *audioData = data;
                    // 增加录音
                    THKOnlineDesignSectionModel *section4 = [self getDemandSection];
                    if (section4.item.demandModel.demandDesc.count == 0) {
                        section4.item.demandModel.demandDesc = [NSMutableArray array];
                    }
                    section4.item.demandModel.demandDesc = [section4.item.demandModel.demandDesc tmui_arrayByAddObject:audioData];
                    CGSize item4Size = [self demandSize:section4.item.demandModel.demandDesc];
                    section4.item.itemSize = item4Size;
                    
                }else if (type == THKOnlineDesignOperateType_DelAudio){
                    NSInteger idx = [data integerValue];
                    // 删除录音
                    THKOnlineDesignSectionModel *section4 = [self getDemandSection];
                    section4.item.demandModel.demandDesc = [section4.item.demandModel.demandDesc tmui_arrayByRemovingObjectAtIndex:idx];
                    CGSize item4Size = [self demandSize:section4.item.demandModel.demandDesc];
                    section4.item.itemSize = item4Size;
                }
                
                
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
            
        }];
    }
    return _requestCommand;
}

- (THKOnlineDesignSectionModel *)getHouseTypeModel{
    THKOnlineDesignSectionModel *model = nil;
    for (THKOnlineDesignSectionModel *aModel in self.datas) {
        if (aModel.item.type == THKOnlineDesignItemDataType_HouseType || aModel.item.type == THKOnlineDesignItemDataType_HouseTypeModel ) {
            model = aModel;
            break;
        }
    }
    return model;
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
                [self.requestCommand execute:RACTuplePack(@(THKOnlineDesignOperateType_AddAudio),input)];
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
                [self.requestCommand execute:RACTuplePack(@(THKOnlineDesignOperateType_DelAudio),input)];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _deleteAudioCommand;
}

- (RACCommand *)selectHouseTypeCommand{
    if (!_selectHouseTypeCommand) {
        @weakify(self);
        _selectHouseTypeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [self.requestCommand execute:RACTuplePack(@(THKOnlineDesignOperateType_SelectHouseType),input)];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _selectHouseTypeCommand;
}

@end
