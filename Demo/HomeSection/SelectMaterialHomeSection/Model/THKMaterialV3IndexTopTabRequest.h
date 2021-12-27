//
//  THKMaterialV3IndexTopTabRequest.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/25.
//

#import "THKBaseRequest.h"
#import "THKDynamicTabsModel.h"
NS_ASSUME_NONNULL_BEGIN
@class MaterialV3IndexTopTabModel;
@interface THKMaterialV3IndexTopTabRequest : THKBaseRequest

@end

@interface THKMaterialV3IndexTopTabResponse : THKResponse

//@property (nonatomic, strong) MaterialV3IndexTopTabModel *data;
@property (nonatomic, strong) NSArray <THKDynamicTabsModel *> *data;

@end

@interface MaterialV3IndexTopTabModel : NSObject
//@property (nonatomic, strong) NSArray <THKDynamicTabsModel *> *;
@end

NS_ASSUME_NONNULL_END
