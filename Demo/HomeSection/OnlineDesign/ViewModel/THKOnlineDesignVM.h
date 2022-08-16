//
//  THKOnlineDesignVM.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKViewModel.h"
#import "THKRequestCommand.h"
#import "THKOnlineDesignModel.h"
// cells 
#import "THKOnlineDesignBaseCell.h"
#import "THKOnlineDesignHouseSearchAreaCell.h"
#import "THKOnlineDesignHouseTypeCell.h"
#import "THKOnlineDesignHouseNameCell.h"
#import "THKOnlineDesignHouseStyleCell.h"
#import "THKOnlineDesignHouseBudgetCell.h"
#import "THKOnlineDesignHouseDemandCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignVM : THKViewModel

@property (nonatomic, strong, readonly) THKRequestCommand *requestCommand;

@property (nonatomic, strong, readonly) TMUIOrderedDictionary *cellDict;

@property (nonatomic, strong, readonly) NSArray <THKOnlineDesignSectionModel *> *datas;

@property (nonatomic, strong, readonly) RACCommand *selectHouseTypeCommand;

@property (nonatomic, strong, readonly) RACCommand *addAudioCommand;

@property (nonatomic, strong, readonly) RACCommand *deleteAudioCommand;

@property (nonatomic, strong, readonly) RACSubject *refreshSignal;

@property (nonatomic, strong, readonly) RACSubject *emptySignal;

@property (nonatomic, strong) UICollectionViewFlowLayout *vcLayout;

@end

NS_ASSUME_NONNULL_END
