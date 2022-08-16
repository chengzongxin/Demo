//
//  THKOnlineDesignHomeConfigModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignHomeConfigColumnOptionList :NSObject
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * id;

@end


@interface THKOnlineDesignHomeConfigColumnList :NSObject
@property (nonatomic , copy) NSString              * columnType;
@property (nonatomic , assign) BOOL              isSingle;
@property (nonatomic , strong) NSArray <THKOnlineDesignHomeConfigColumnOptionList *>              * optionList;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * desc;

@end

@interface THKOnlineDesignHomeConfigModel : NSObject

@property (nonatomic , copy) NSString              * topImgUrl;
@property (nonatomic , strong) NSArray <THKOnlineDesignHomeConfigColumnList *>              * columnList;
@property (nonatomic , copy) NSString              * topContent3;
@property (nonatomic , copy) NSString              * topContent2;
@property (nonatomic , copy) NSString              * topContent1;

@end

NS_ASSUME_NONNULL_END
