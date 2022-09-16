//
//  THKHomeQueryCardModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKHomeQueryCardModelColumnListModel : NSObject

@property (nonatomic, strong) NSString *columnType;
@property (nonatomic , copy) NSArray <NSString *>              * idList;

@end

@interface THKHomeQueryCardModel : NSObject
@property (nonatomic , assign) NSInteger              area;
@property (nonatomic , copy) NSString              * decorateTypeName;
@property (nonatomic , copy) NSString              * houseTag;
@property (nonatomic , copy) NSString              * areaStr;
@property (nonatomic , copy) NSString              * budgetName;
@property (nonatomic , copy) NSArray <NSString *>              * budgetTagArray;
@property (nonatomic , copy) NSString              * styleName;
@property (nonatomic , copy) NSString              * populationTypeName;
@property (nonatomic , assign) NSInteger              populationType;
@property (nonatomic , copy) NSString              * communityName;
@property (nonatomic , assign) NSInteger              decorateType;
@property (nonatomic , copy) NSArray <NSString *>              * styleTagArray;
@property (nonatomic , copy) NSString              * houseName;
@property (nonatomic , copy) NSString              * requirementDesc;

/// 来源 0-默认 1-用户手动新增 2-3d
@property (nonatomic, assign) NSString *planSource;

/// 来源id
@property (nonatomic, assign) NSInteger planSourceId;

@property (nonatomic, strong) NSArray <THKHomeQueryCardModelColumnListModel *>*columnList;

@property (nonatomic, assign) NSInteger id;


@end

NS_ASSUME_NONNULL_END
