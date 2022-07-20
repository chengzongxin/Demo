//
//  THKDecorationToDoModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//@interface THKDecorationToDoModel : NSObject
//
//@end
//
//@interface THKDecorationToDoItem : NSObject
//
//@property (nonatomic, copy) NSString *title;
//
//@property (nonatomic, copy) NSString *subtitle;
//
//@end
//
//@interface THKDecorationToDoSection : NSObject
//
//@property (nonatomic, copy) NSArray <THKDecorationToDoItem *>*items;
//
//@property (nonatomic, assign) BOOL isOpen;
//
//@end

@interface THKDecorationUpcomingChildListModel : NSObject

@property (nonatomic, assign) NSInteger childId;  /// < 子项id

@property (nonatomic, copy) NSString *childName;  /// <  子项名称

@property (nonatomic, copy) NSString *strategyRouting;  /// <  攻略路由

@property (nonatomic, copy) NSString *strategyTitle;  /// <  攻略标题

@property (nonatomic, assign) NSInteger todoStatus;  /// < 待办状态 0-未办理 1-已办理

@property (nonatomic, copy) NSString *toolRouting;  /// <  关联工具路由

@property (nonatomic, copy) NSString *toolTitle;  /// < 关联工具标题

@end



@interface THKDecorationUpcomingListModel : NSObject

@property (nonatomic, copy) NSArray <THKDecorationUpcomingChildListModel *> *childList;

@property (nonatomic, assign) NSInteger completedNum;  /// < 已完成子项数

@property (nonatomic, copy) NSString *mainDesc;  /// <  主项描述

@property (nonatomic, assign) NSInteger mainId;  /// <  主项id

@property (nonatomic, copy) NSString *mainName;  /// <  主项名称

@property (nonatomic, assign) NSInteger totalNum;  /// <  子项总数

@property (nonatomic, assign) BOOL isOpen;

@end

@interface THKDecorationUpcomingModel : NSObject

@property (nonatomic, copy) NSString *serialNumber;  /// <  序号数

@property (nonatomic, assign) NSInteger stageId;  /// <  阶段id

@property (nonatomic, copy) NSString *stageName;  /// < 阶段名称

@property (nonatomic, copy) NSArray <THKDecorationUpcomingListModel *> *upcomingList;


@end



NS_ASSUME_NONNULL_END
