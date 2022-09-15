//
//  THKMyHomeDesignDemandsModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    THKMyHomeDesignDemandsModelType_CommunityName,
    THKMyHomeDesignDemandsModelType_HouseArea,
    THKMyHomeDesignDemandsModelType_HouseType,
    THKMyHomeDesignDemandsModelType_Style,
    THKMyHomeDesignDemandsModelType_Budget,
    THKMyHomeDesignDemandsModelType_Decorate,
    THKMyHomeDesignDemandsModelType_Population,
    THKMyHomeDesignDemandsModelType_SpecialDemand,
} THKMyHomeDesignDemandsModelType;

@interface THKMyHomeDesignDemandsModel : NSObject

@property (nonatomic, assign) THKMyHomeDesignDemandsModelType type;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *content;

@end

NS_ASSUME_NONNULL_END
