//
//  THKOnlineDesignVM.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignDispatchVM.h"

@interface THKOnlineDesignDispatchVM ()

@property (nonatomic, strong) THKRequestCommand *requestCommand;

@property (nonatomic, strong) RACCommand *selectHouseTypeCommand;

@property (nonatomic, strong) RACCommand *addAudioCommand;

@property (nonatomic, strong) RACCommand *deleteAudioCommand;

@property (nonatomic, strong) RACSubject *refreshSignal;

@property (nonatomic, strong) RACSubject *emptySignal;

@property (nonatomic, strong) RACCommand *commitCommand;

@property (nonatomic, strong) RACCommand *configRequest;

@property (nonatomic, strong) RACCommand *detailRequest;

@property (nonatomic, strong) RACSubject *selectItem;

@property (nonatomic, strong) NSArray <THKOnlineDesignSectionModel *> *datas;

@property (nonatomic, strong) TMUIOrderedDictionary *cellDict;


@property (nonatomic, strong) NSString *topImgUrl;
@property (nonatomic, strong) NSString *topContent1;
@property (nonatomic, strong) NSString *topContent2;
@property (nonatomic, strong) NSString *topContent3;
@property (nonatomic, strong) NSArray <THKOnlineDesignHomeConfigColumnList *> *dataColumnList;


#pragma mark - API Request
/// 面积(单位m²)
@property (nonatomic, assign) NSInteger area;

/// 栏目列表
@property (nonatomic, strong) NSArray <THKOnlineDesignHomeConfigColumnList *> *columnList;

/// 小区名称
@property (nonatomic, strong) NSString *communityName;

/// 户型信息全码
@property (nonatomic, strong) NSString *houseTag;

/// 主键id
@property (nonatomic, assign) NSInteger id;

/// 户型图信息
@property (nonatomic, strong) NSArray <THKOnlineDesignHomeEditPlanImgList *>*planImgList;

/// 语音信息列表
@property (nonatomic, strong) NSArray *recordingInfoList;

/// 需求描述
@property (nonatomic, strong) NSString *requirementDesc;

/// 来源 0-默认 1-用户手动新增 2-3d
@property (nonatomic, assign) NSString *planSource;

/// 来源id
@property (nonatomic, assign) NSInteger planSourceId;



@property (nonatomic, strong) NSArray <NSString *> *imageFilePath;


@end

@implementation THKOnlineDesignDispatchVM

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
    
    [self.selectItem subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
//         RACTuplePack(@(sectionModel.item.type),@(indexPath.item))
        THKOnlineDesignItemDataType type = [x.first intValue];
        NSInteger item = [x.second integerValue];
        __block NSMutableArray <THKOnlineDesignHomeConfigColumnList *>*columnList = [self.columnList mutableCopy];
        [self.dataColumnList enumerateObjectsUsingBlock:^(THKOnlineDesignHomeConfigColumnList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (type == THKOnlineDesignItemDataType_HouseStyle && [obj.columnType isEqualToString:@"styleTag"]) {
                columnList = [[columnList tmui_filter:^BOOL(THKOnlineDesignHomeConfigColumnList * _Nonnull item) {
                    return ![item.columnType isEqualToString:@"styleTag"];
                }] mutableCopy];
                THKOnlineDesignHomeConfigColumnList *data = [THKOnlineDesignHomeConfigColumnList new];
                data.columnType = @"styleTag";
                THKOnlineDesignHomeConfigColumnOptionList *optionList = [THKOnlineDesignHomeConfigColumnOptionList new];
                optionList.id = obj.optionList[item].id;
                optionList.name = obj.optionList[item].name;
                data.optionList = @[optionList];
                [columnList addObject:data];
            }else if (type == THKOnlineDesignItemDataType_HouseBudget && [obj.columnType isEqualToString:@"budgetTag"]) {
                columnList = [[columnList tmui_filter:^BOOL(THKOnlineDesignHomeConfigColumnList * _Nonnull item) {
                    return ![item.columnType isEqualToString:@"budgetTag"];
                }] mutableCopy];
                THKOnlineDesignHomeConfigColumnList *data = [THKOnlineDesignHomeConfigColumnList new];
                data.columnType = @"budgetTag";
                THKOnlineDesignHomeConfigColumnOptionList *optionList = [THKOnlineDesignHomeConfigColumnOptionList new];
                optionList.id = obj.optionList[item].id;
                optionList.name = obj.optionList[item].name;
                data.optionList = @[optionList];
                [columnList addObject:data];
            }
        }];
        self.columnList = columnList;
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

- (RACCommand *)detailRequest{
    if (!_detailRequest) {
        _detailRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                THKOnlineDesignHomeDetailRequest *request = [[THKOnlineDesignHomeDetailRequest alloc] init];
                [request.rac_requestSignal subscribeNext:^(id  _Nullable x) {
                    [subscriber sendNext:x];
                } error:^(NSError * _Nullable error) {
                    [subscriber sendError:error];
                } completed:^{
                    [subscriber sendCompleted];
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _detailRequest;
}


- (RACCommand *)configRequest{
    if (!_configRequest) {
        _configRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                THKOnlineDesignHomeConfigRequest *request = [[THKOnlineDesignHomeConfigRequest alloc] init];
                [request.rac_requestSignal subscribeNext:^(id  _Nullable x) {
                    [subscriber sendNext:x];
                } error:^(NSError * _Nullable error) {
                    [subscriber sendError:error];
                } completed:^{
                    [subscriber sendCompleted];
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _configRequest;
}


- (THKRequestCommand *)requestCommand{
    if (!_requestCommand) {
        _requestCommand = [THKRequestCommand commandMake:^(id  _Nonnull input, id<RACSubscriber>  _Nonnull subscriber) {
            RACTupleUnpack(id typeID,id data) = input;
            THKOnlineDesignOperateType type = [typeID integerValue];
            if (type == THKOnlineDesignOperateType_AddPlan || type == THKOnlineDesignOperateType_Edit) {
                // 请求接口
                [self requestDataWithType:type nextBlock:^(id x) {
                    [subscriber sendNext:x];
                } error:^(NSError *error) {
                    [subscriber sendError:error];
                } completed:^{
                    [subscriber sendCompleted];
                }];
            } else{
                // 编辑
                if (type == THKOnlineDesignOperateType_SelectHouseType) {
                    THKOnlineDesignItemHouseTypeModel *model = data;
                    
#pragma mark - 接口数据
                    self.area = model.buildArea;
                    self.communityName = model.houseArea;
                    self.houseTag = model.houseTag;
                    self.planSource = model.planSource;
                    self.planSourceId = model.planSourceId;
                    self.planImgList = model.planImgList;
                    self.imageFilePath = model.imageFilePath;
                    
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

- (void)handleData:(THKOnlineDesignHomeConfigResponse *)data1 data2:(THKOnlineDesignHomeDetailResponse *)data2{
    
    THKOnlineDesignHomeConfigModel *data = data1.data;
    
    self.topImgUrl = data.topImgUrl;
    self.topContent1 = data.topContent1;
    self.topContent2 = data.topContent2;
    self.topContent3 = data.topContent3;
    self.dataColumnList = data.columnList;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (THKOnlineDesignHomeConfigColumnList *list in data.columnList) {
        if ([list.columnType isEqualToString:@"housePlan"]) {
            
            if (data2.data) {
                
                // 接口数据
                THKOnlineDesignHomeDetailModel *model = data2.data;
                self.area = model.area;
                self.communityName = model.communityName;
                self.houseTag = model.houseTag;
                self.planSource = @"1";
                self.planSourceId = 0;
                self.planImgList = model.planImgList;
                //            self.imageFilePath = model.imageFilePath;
                
                THKOnlineDesignItemHouseTypeModel *houseTypeModel = [THKOnlineDesignItemHouseTypeModel new];
                houseTypeModel.houseArea = model.communityName;
                houseTypeModel.buildArea = model.area;
                houseTypeModel.houseType = model.houseTag;
                
                THKOnlineDesignSectionModel *section1 = [[THKOnlineDesignSectionModel alloc] init];
                section1.title = list.title;// @"匹配我家小区的户型";
                THKOnlineDesignItemModel *item1 = [[THKOnlineDesignItemModel alloc] init];
                item1.type = THKOnlineDesignItemDataType_HouseTypeModel;
                item1.houseType = houseTypeModel;
                item1.cellClass = self.cellDict[@(item1.type)];
                item1.itemSize = CGSizeMake(TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.vcLayout.sectionInset), 80);
                section1.item = item1;
                [arr addObject:section1];
            }else{
                
                THKOnlineDesignSectionModel *section1 = [[THKOnlineDesignSectionModel alloc] init];
                section1.title = list.title;// @"匹配我家小区的户型";
                THKOnlineDesignItemModel *item1 = [[THKOnlineDesignItemModel alloc] init];
                item1.type = THKOnlineDesignItemDataType_HouseType;
                item1.cellClass = self.cellDict[@(item1.type)];
                item1.itemSize = CGSizeMake(TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.vcLayout.sectionInset), 75);
                section1.item = item1;
                [arr addObject:section1];
            }
            
        }else if ([list.columnType isEqualToString:@"styleTag"]) {
            
//            if (data2.data) {
//
//            }else{
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
               
            if (data2.data) {
                [data2.data.columnList enumerateObjectsUsingBlock:^(THKOnlineDesignHomeEditColumnList * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop) {
                    if ([obj1.columnType isEqualToString:@"styleTag"]) {
                        [list.optionList enumerateObjectsUsingBlock:^(THKOnlineDesignHomeConfigColumnOptionList * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop) {
                            if ([obj2.id isEqualToString:obj1.idList.firstObject]) {
                                section2.isFold = YES;
                                section2.selectIdx = idx2;
                                [self.selectItem sendNext:RACTuplePack(@(THKOnlineDesignItemDataType_HouseStyle),@(idx2))];
                            }
                        }];
                    }
                }];
            }
//            }
            
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
            
            if (data2.data) {
                [data2.data.columnList enumerateObjectsUsingBlock:^(THKOnlineDesignHomeEditColumnList * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop) {
                    if ([obj1.columnType isEqualToString:@"budgetTag"]) {
                        [list.optionList enumerateObjectsUsingBlock:^(THKOnlineDesignHomeConfigColumnOptionList * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop) {
                            if ([obj2.id isEqualToString:obj1.idList.firstObject]) {
                                section3.isFold = YES;
                                section3.selectIdx = idx2;
                                [self.selectItem sendNext:RACTuplePack(@(THKOnlineDesignItemDataType_HouseBudget),@(idx2))];
                            }
                        }];
                    }
                }];
            }
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
            
            if (data2.data.requirementDesc.length > 0) {
                item4.demandModel.text = data2.data.requirementDesc;
            }
        }
    }
    self.datas = arr;
    
}

- (void)requestDataWithType:(THKOnlineDesignOperateType)type nextBlock:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock {
    
    if (type == THKOnlineDesignOperateType_AddPlan) {
        @weakify(self);
        [self.configRequest.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self handleData:x data2:nil];
            nextBlock(x);
            completedBlock();
        }];
        
        [self.configRequest execute:nil];
    }else{
        @weakify(self);
        [[RACSignal combineLatest:@[self.configRequest.executionSignals.switchToLatest,self.detailRequest.executionSignals.switchToLatest] reduce:^id _Nullable(THKOnlineDesignHomeConfigResponse *res1,THKOnlineDesignHomeDetailResponse *res2){
            @strongify(self);
            [self handleData:res1 data2:res2];
            return res1;
        }] subscribeNext:^(id  _Nullable x) {
            nextBlock(x);
            completedBlock();
        }];;
        
        [self.configRequest execute:nil];
        [self.detailRequest execute:nil];
    }
    
    
//    [request.rac_requestSignal subscribeNext:^(THKOnlineDesignHomeConfigResponse * _Nullable x) {
//
////        [subscriber sendNext:nil];
//        nextBlock(nil);
//    } error:^(NSError * _Nullable error) {
////        [subscriber sendError:error];
//        errorBlock(error);
//    } completed:^{
////        [subscriber sendCompleted];
//        completedBlock();
//    }];
    
}

- (void)updateDemandDesc:(NSString *)demandDesc{
    self.requirementDesc = demandDesc;
}


- (RACCommand *)commitCommand{
    if (!_commitCommand) {
        @weakify(self);
        _commitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                
                void (^uploadHouseList)(void) = ^void(void) {
                    
                    THKOnlineDesignHomeEditRequest *request = [THKOnlineDesignHomeEditRequest new];
                    request.area = self.area;
                    request.columnList = [self.columnList tmui_map:^id _Nonnull(THKOnlineDesignHomeConfigColumnList * _Nonnull item) {
                        THKOnlineDesignHomeEditColumnList *requestColoumnList = [[THKOnlineDesignHomeEditColumnList alloc] init];
                        requestColoumnList.columnType = item.columnType;
                        requestColoumnList.idList = [item.optionList tmui_map:^id _Nonnull(THKOnlineDesignHomeConfigColumnOptionList * _Nonnull item) {
                            return item.id;
                        }];
                        return requestColoumnList;
                    }];
                    
                    request.communityName = self.communityName;
                    request.houseTag = self.houseTag;
                    request.planSource = self.planSource;
                    request.planSourceId = self.planSourceId;
                    request.planImgList = self.planImgList;
    //                request.id = 123;
    //                request.planImgList = nil;
    //                request.recordingInfoList = @[@"123",@"456"];
                    request.requirementDesc = self.requirementDesc;
                    [request.rac_requestSignal subscribeNext:^(id  _Nullable x) {
                        [subscriber sendNext:x];
                    } error:^(NSError * _Nullable error) {
                        [subscriber sendError:error];
                    } completed:^{
                        [subscriber sendCompleted];
                    }];
                };
                
    
                
                if (self.imageFilePath) {
                    // 上传户型图片
                    self.planImgList = [self.imageFilePath tmui_map:^id _Nonnull(NSString * _Nonnull item) {
                        THKOnlineDesignHomeEditPlanImgList *imgList = [[THKOnlineDesignHomeEditPlanImgList alloc] init];
                        imgList.imgUrl = item;
                        imgList.imgWidth = 100;
                        imgList.imgHeight = 100;
                        return imgList;
                    }];
                    uploadHouseList();
                }else{
                    uploadHouseList();
                }
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _commitCommand;
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

TMUI_PropertyLazyLoad(RACSubject, selectItem);
TMUI_PropertyLazyLoad(NSMutableArray, columnList);

@end
