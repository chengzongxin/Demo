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
@property (nonatomic, strong) NSString *firstButtonTip;
@property (nonatomic, strong) NSString *firstButtonTipRouter;
@property (nonatomic, strong) NSString *firstContentImgUrl;
@property (nonatomic, strong) NSString *secondTitle;
@property (nonatomic, strong) NSString *secondButtonTip;
@property (nonatomic, strong) NSString *secondButtonTipRouter;
@property (nonatomic, strong) NSArray <THKDecPKCompanyModel *> *secondContent;

@property (nonatomic, strong) NSString *bigButtonTip;
@property (nonatomic, strong) NSString *bigButtonTipRouter;
@property (nonatomic, strong) NSString *bottomTipIcon;
@property (nonatomic, strong) NSString *bottomTip;
@property (nonatomic, strong) NSString *bottomTipRouter;


@property (nonatomic, strong) NSArray <NSString *> *companyTexts;

//- (void)bindWithModel:(THKDecPKModel *)model;

@property (nonatomic, strong) THKDecPKModel *model;

- (instancetype)initWithModel:(THKDecPKModel *)model;

@end


NS_ASSUME_NONNULL_END
