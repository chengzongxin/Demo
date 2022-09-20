//
//  THKGraphicDetailModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKGraphicDetailGeneratePicture :NSObject
@property (nonatomic , copy) NSString              * authorName;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * authorAvatar;

@end


@interface THKGraphicDetailReportData :NSObject
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , assign) NSInteger              type;

@end

@interface THKGraphicDetailShareData :NSObject
@property (nonatomic , strong) THKGraphicDetailGeneratePicture              * generatePicture;
@property (nonatomic , copy) NSString              * sinaContent;
@property (nonatomic , copy) NSString              * imageUrl;
@property (nonatomic , strong) THKGraphicDetailReportData              * reportData;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * webpageUrl;

@end


@interface THKGraphicDetailCategoryData :NSObject

@end

@interface THKGraphicDetailImgInfoItem :NSObject
@property (nonatomic , copy) NSString              * spaceTagName;
@property (nonatomic , assign) NSInteger              imgId;
@property (nonatomic , copy) NSString              * imgPath;
@property (nonatomic , assign) NSInteger              width;
@property (nonatomic , copy) NSString              * spaceTag;
@property (nonatomic , copy) NSString              * thumbnailUrl;
@property (nonatomic , assign) NSInteger              height;
@property (nonatomic , assign) NSInteger              imgOrder;

@end

@interface THKGraphicDetailContentListItem :NSObject
@property (nonatomic , copy) NSString              * anchor;
@property (nonatomic , copy) NSString              * anchorContent;

@end


@interface THKGraphicDetailModel : NSObject
@property (nonatomic , copy) NSString              * sharePic;
@property (nonatomic , assign) NSInteger              subCategory;
@property (nonatomic , strong) NSArray <NSString *>              * keywords;
@property (nonatomic , strong) THKGraphicDetailShareData              * shareData;
@property (nonatomic , assign) NSInteger              latitude;
@property (nonatomic , assign) NSInteger              collectNum;
@property (nonatomic , assign) NSInteger              praiseNum;
@property (nonatomic , assign) NSInteger              identificationType;
@property (nonatomic , assign) NSInteger              baseId;
@property (nonatomic , assign) NSInteger              source;
@property (nonatomic , assign) NSInteger              cityId;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , assign) NSInteger              authorIdentity;
@property (nonatomic , copy) NSString              * shareContent;
@property (nonatomic , assign) NSInteger              isShowConsultation;
@property (nonatomic , copy) NSString              * cityName;
@property (nonatomic , copy) NSString              * yiDunRejectReason;
@property (nonatomic , assign) NSInteger              longitude;
@property (nonatomic , assign) NSInteger              identificationStatus;
@property (nonatomic , assign) BOOL              original;
@property (nonatomic , copy) NSString              * identificationDesc;
@property (nonatomic , strong) THKGraphicDetailCategoryData              * categoryData;
@property (nonatomic , strong) NSArray <NSString *>              * brandMerchants;
@property (nonatomic , copy) NSString              * identificationPic;
@property (nonatomic , assign) NSInteger              praiseStatus;
@property (nonatomic , assign) NSInteger              updateTime;
@property (nonatomic , assign) NSInteger              authorId;
@property (nonatomic , strong) NSArray <THKGraphicDetailImgInfoItem *>              * imgInfo;
@property (nonatomic , copy) NSString              * authorAvatar;
@property (nonatomic , assign) NSInteger              commentNum;
@property (nonatomic , copy) NSString              * shareTitle;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , copy) NSString              * authorName;
@property (nonatomic , copy) NSString              * goodsData;
@property (nonatomic , assign) NSInteger              recommendType;
@property (nonatomic , copy) NSString              * shareUrl;
@property (nonatomic , copy) NSString              * location;
@property (nonatomic , strong) NSArray <THKGraphicDetailContentListItem *>              * contentList;
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , assign) NSInteger              collectStatus;
@end

NS_ASSUME_NONNULL_END
