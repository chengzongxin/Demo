//
//  THKOnlineDesignModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class THKOnlineDesignItemModel;

@interface THKOnlineDesignModel : NSObject

@end

@interface THKOnlineDesignSectionModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) THKOnlineDesignItemModel *item;

@end

@interface THKOnlineDesignItemModel : NSObject

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSString *picUrl;

@property (nonatomic, strong) NSString *houseAreaName;

@property (nonatomic, strong) NSArray <NSString *> *houseStyles;

@property (nonatomic, strong) NSArray <NSString *> *houseBudget;

@property (nonatomic, strong)  NSArray <NSString *> *demandDesc;

///  本地处理
@property (nonatomic, strong) NSArray <NSString *> *items;

@end


NS_ASSUME_NONNULL_END
