//
//  THKSelectMaterialCommunicationVM.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/24.
//

#import "THKViewModel.h"
#import "THKStateMechanismsViewModel.h"
#import "THKMaterialV3CommunicateListRequest.h"
#import "THKMaterialV3CommunicateLabelRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKSelectMaterialCommunicationVM : THKStateMechanismsViewModel
@property (nonatomic, assign) NSInteger categoryId; ///<品类id
@property (nonatomic, assign) NSInteger wholeCode; ///<标签全码

@property (nonatomic, strong, readonly) THKRequestCommand *labelRequest;


@end

NS_ASSUME_NONNULL_END
