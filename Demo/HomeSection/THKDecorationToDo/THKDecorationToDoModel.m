//
//  THKDecorationToDoModel.m
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKDecorationToDoModel.h"

//@implementation THKDecorationToDoModel
//
//@end
//
//@implementation THKDecorationToDoItem
//
//@end
//
//@implementation THKDecorationToDoSection
//
//@end



@implementation THKDecorationUpcomingChildListModel

@end

@implementation THKDecorationUpcomingListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"childList":THKDecorationUpcomingChildListModel.class};
}
@end

@implementation THKDecorationUpcomingModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"upcomingList":THKDecorationUpcomingListModel.class};
}

@end
