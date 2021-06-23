//
//  THKDecorationHomeDiaryListResponse.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/5/24.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKResponse.h"
@class THKDecorationDiaryListModel;
NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationHomeDiaryListResponse : THKResponse

@property (nonatomic, copy)     NSArray<THKDecorationDiaryListModel *> *data;

@end


@interface THKDecorationDiaryBookInfo :NSObject
@property (nonatomic , assign) NSInteger              area;
@property (nonatomic , copy) NSString              * styleName;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * routeUrl;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , assign) NSInteger              budget;

@end


@interface THKDecorationDiaryUserInfo :NSObject
@property (nonatomic , assign) NSInteger              uid;
@property (nonatomic , assign) NSInteger              accountId;
@property (nonatomic , copy) NSString              * routeUrl;
@property (nonatomic , assign) NSInteger              subCategory;
@property (nonatomic , assign) NSInteger              identificationStatus;
@property (nonatomic , copy) NSString              * identificationDesc;
@property (nonatomic , copy) NSString              * authorName;
@property (nonatomic , copy) NSString              * authorType;
@property (nonatomic , assign) NSInteger              identificationType;
@property (nonatomic , copy) NSString              * identificationPic;
@property (nonatomic , assign) NSInteger              authorIdentity;
@property (nonatomic , copy) NSString              * authorAvatar;

@end


@interface THKDecorationDiaryCompanyInfo :NSObject
@property (nonatomic , copy) NSString              * routeUrl;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSString              * logoURL;
@property (nonatomic , copy) NSString              * shortName;
@end


@interface THKDecorationDiaryImages :NSObject
@property (nonatomic , assign) NSInteger              imageWidth;
@property (nonatomic , assign) NSInteger              deleted;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) NSInteger              diaryId;
@property (nonatomic , copy) NSString              * imageUrl;
@property (nonatomic , copy) NSString              * originUrl;
@property (nonatomic , assign) NSInteger              updateTime;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , assign) NSInteger              imageHeight;
@property (nonatomic , copy) NSString              * thumbnailUrl;

@end


@interface THKDecorationDiaryDiaryInfo :NSObject
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , strong) NSArray <THKDecorationDiaryImages *>              * images;
@property (nonatomic , assign) NSInteger              imageNum;
@property (nonatomic , copy) NSString              * stageBigName;


@end


@interface THKDecorationDiaryListModel :NSObject
@property (nonatomic , strong) THKDecorationDiaryBookInfo              * bookInfo;
@property (nonatomic , strong) THKDecorationDiaryUserInfo              * userInfo;
@property (nonatomic , strong) THKDecorationDiaryCompanyInfo              * companyInfo;
@property (nonatomic , strong) THKDecorationDiaryDiaryInfo              * diaryInfo;

// 本地造数据
@property (nonatomic, strong) NSAttributedString *houseInfoAttrString;
@property (nonatomic, strong) NSAttributedString *contentAttrString;
@property (nonatomic, assign) BOOL isContentAllShow;// (string, optional): 内容 ,


@property (nonatomic, assign) BOOL isFold;
// 是否曝光
@property (nonatomic, assign) BOOL isExpose;

@end



NS_ASSUME_NONNULL_END
