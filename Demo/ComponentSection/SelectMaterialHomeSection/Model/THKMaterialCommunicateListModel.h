//
//  THKMaterialCommunicateListModel.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class THKMaterialCommunicateImageListModel;
@interface THKMaterialCommunicateListModel : NSObject

@property (nonatomic , assign) NSInteger              subCategory;
@property (nonatomic , copy) NSString              * bizType;
@property (nonatomic , copy) NSString              * moduleCode;
@property (nonatomic , assign) NSInteger              followStatus;
@property (nonatomic , assign) BOOL              isCollect;
@property (nonatomic , assign) NSInteger              praiseNum;
@property (nonatomic , assign) NSInteger              collectNum;
@property (nonatomic , assign) NSInteger              identificationType;
@property (nonatomic , copy) NSString              * identityDesc;
@property (nonatomic , copy) NSString              * authorAvatar;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , assign) NSInteger              commentNum;
@property (nonatomic , assign) NSInteger              uid;
@property (nonatomic , copy) NSString              * routeUrl;
@property (nonatomic , copy) NSString              * uniqueCode;
@property (nonatomic , copy) NSString              * authorName;
@property (nonatomic , assign) NSInteger              bizId;
@property (nonatomic , assign) BOOL              isPraise;
@property (nonatomic , strong) NSArray <THKMaterialCommunicateImageListModel *>              * imageList;
@end

@interface THKMaterialCommunicateImageListModel :NSObject
@property (nonatomic , copy) NSString              * originUrl;
@property (nonatomic , assign) NSInteger              width;
@property (nonatomic , copy) NSString              * thumbnailUrl;
@property (nonatomic , assign) NSInteger              height;

@end


NS_ASSUME_NONNULL_END
