//
//  THKCalcSubmitDemandRequest.h
//  Demo
//
//  Created by 程宗鑫 on 2022/10/12.
//

#import "THKBaseRequest.h"
#import "THKCalcSubmitDemandResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKCalcSubmitDemandRequest : THKBaseRequest

//@ApiModelProperty(value = "yid")
@property (nonatomic, assign) NSInteger yid;

//@ApiModelProperty(value = "装企id")
@property (nonatomic, assign) NSInteger companyId;

//@ApiModelProperty(value = "城市", example = "深圳")
@property (nonatomic, strong) NSString *city;

//@ApiModelProperty(value = "城市id", example = "1130")
@property (nonatomic, assign) NSInteger cityId;

//@ApiModelProperty(value = "区id", example = "南山区的id:1131")
@property (nonatomic, assign) NSInteger townId;

//@ApiModelProperty(value = "装修类型 1-简装 2-精装 3-豪装", example = "1")
@property (nonatomic, assign) NSInteger decoType;

//@ApiModelProperty(value = "面积", example = "120")
@property (nonatomic, assign) NSInteger square;

//@ApiModelProperty(value = "卧室数量", example = "3")
@property (nonatomic, assign) NSInteger fang;

//@ApiModelProperty(value = "客厅数量", example = "2")
@property (nonatomic, assign) NSInteger ting;

//@ApiModelProperty(value = "厨房数量", example = "2")
@property (nonatomic, assign) NSInteger chu;

//@ApiModelProperty(value = "卫生间数量", example = "1")
@property (nonatomic, assign) NSInteger wei;

//@ApiModelProperty(value = "阳台数量", example = "1")
@property (nonatomic, assign) NSInteger yangtai;

//@ApiModelProperty(value = "新旧房 1-新房 2-旧房 默认新房", example = "1")
@property (nonatomic, assign) NSInteger houseRough;

@end

NS_ASSUME_NONNULL_END
