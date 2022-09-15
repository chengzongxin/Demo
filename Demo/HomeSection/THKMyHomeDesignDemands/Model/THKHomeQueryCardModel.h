//
//  THKHomeQueryCardModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKHomeQueryCardModel : NSObject
@property (nonatomic , assign) NSInteger              area;
@property (nonatomic , copy) NSString              * decorateTypeName;
@property (nonatomic , copy) NSString              * houseTag;
@property (nonatomic , copy) NSString              * areaStr;
@property (nonatomic , copy) NSString              * budgetTagName;
@property (nonatomic , copy) NSString              * budgetTag;
@property (nonatomic , copy) NSString              * styleTagName;
@property (nonatomic , copy) NSString              * populationTypeName;
@property (nonatomic , assign) NSInteger              populationType;
@property (nonatomic , copy) NSString              * communityName;
@property (nonatomic , assign) NSInteger              decorateType;
@property (nonatomic , copy) NSString              * styleTag;
@property (nonatomic , copy) NSString              * houseTagName;
@property (nonatomic , copy) NSString              * requirementDesc;
@end

NS_ASSUME_NONNULL_END
