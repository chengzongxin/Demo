//
//  THKCalculateQuotationViewModel.h
//  Demo
//
//  Created by 程宗鑫 on 2022/10/12.
//

#import "THKViewModel.h"
#import "THKRequestCommand.h"
#import "THKCalcSubmitDemandRequest.h"
#import "THKCalcConfigRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKCalculateQuotationViewModel : THKViewModel

@property (nonatomic, strong, readonly) THKRequestCommand *requestConfigCommand;

@property (nonatomic, strong, readonly) RACSubject *refreshSignal;

@property (nonatomic, strong, readonly) RACSubject *errorMsgSignal;

@property (nonatomic, strong, readonly) NSArray <NSArray *> *houseTypeArray;

@property (nonatomic, strong, readonly) NSArray *shiArray;

@property (nonatomic, strong, readonly) NSArray *tingArray;

@property (nonatomic, strong, readonly) NSArray *weiArray;

@property (nonatomic, strong, readonly) NSArray *yangArray;

@property (nonatomic, strong, readonly) NSArray <NSArray *> *cityModels;

@end

NS_ASSUME_NONNULL_END
