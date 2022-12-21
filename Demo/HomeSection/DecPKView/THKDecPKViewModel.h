//
//  THKDecPKViewModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class THKDecPKCompanyModel;

@interface THKDecPKViewModel : NSObject


@property (nonatomic, strong) NSString *firstTitle;
@property (nonatomic, strong) NSString *firstButtonTip;//(router)
@property (nonatomic, strong) NSString *firstContentImgUrl;
@property (nonatomic, strong) NSString *secondTitle;
@property (nonatomic, strong) NSString *secondButtonTip;//(router)

@property (nonatomic, strong) NSArray <THKDecPKCompanyModel *> *secondContent;
//secondContent : [
//    decName
//    decIcon
//    score(text)
//    caseNum(text)
//    consultNum(text)
//]
@property (nonatomic, strong) NSString *bigButtonTip;//(router)
@property (nonatomic, strong) NSString *bottomTipIcon;
@property (nonatomic, strong) NSString *bottomTip;//(router)


@end



@interface THKDecPKCompanyModel : NSObject

@property (nonatomic, strong) NSString *decName;
@property (nonatomic, strong) NSString *decIcon;
@property (nonatomic, strong) int score;
@property (nonatomic, strong) int caseNum;
@property (nonatomic, strong) int consultNum;
@property (nonatomic, strong) NSString *scoreText;
@property (nonatomic, strong) NSString *caseNumText;
@property (nonatomic, strong) NSString *consultNumText;

@end

NS_ASSUME_NONNULL_END
