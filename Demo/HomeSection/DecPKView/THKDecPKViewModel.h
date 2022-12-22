//
//  THKDecPKViewModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/12/21.
//

#import <Foundation/Foundation.h>
#import "THKDecPKCompanyModel.h"
NS_ASSUME_NONNULL_BEGIN

@class THKDecPKCompanyModel;

@interface THKDecPKViewModel : NSObject


@property (nonatomic, strong) NSString *firstTitle;
@property (nonatomic, strong) NSString *firstButtonTip;//(router)
@property (nonatomic, strong) NSString *firstContentImgUrl;
@property (nonatomic, strong) NSString *secondTitle;
@property (nonatomic, strong) NSString *secondButtonTip;//(router)

@property (nonatomic, strong) NSArray <THKDecPKCompanyModel *> *secondContent;

@property (nonatomic, strong) NSString *bigButtonTip;//(router)
@property (nonatomic, strong) NSString *bottomTipIcon;
@property (nonatomic, strong) NSString *bottomTip;//(router)



@property (nonatomic, strong) NSArray <NSString *> *companyTexts;

@end


NS_ASSUME_NONNULL_END
