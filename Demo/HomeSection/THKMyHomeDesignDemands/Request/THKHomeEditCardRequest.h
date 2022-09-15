//
//  THKHomeEditCardRequest.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKBaseRequest.h"
#import "THKHomeEditCardResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKHomeEditCardRequest : THKBaseRequest

//房屋面积
@property (nonatomic, assign) NSInteger area;

//装修预算全码
@property (nonatomic, strong) NSString *budgetTag;

//小区名称
@property (nonatomic, strong) NSString *communityName;

//装修方式
@property (nonatomic, assign) NSInteger decorateType;

//房屋户型全码
@property (nonatomic, strong) NSString *houseTag;

//居住人口
@property (nonatomic, assign) NSInteger populationType;

//特殊需求
@property (nonatomic, strong) NSString *requirementDesc;

//装修风格全码
@property (nonatomic, strong) NSString *styleTag;

@end

NS_ASSUME_NONNULL_END
