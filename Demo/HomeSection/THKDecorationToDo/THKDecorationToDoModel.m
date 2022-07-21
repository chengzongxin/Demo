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

@interface THKDecorationUpcomingChildListModel ()

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation THKDecorationUpcomingChildListModel


- (CGFloat)cellHeight{
    if (_cellHeight == 0) {
        _cellHeight = self.childDesc.length ? 101 : 80;
    }
    return _cellHeight;
}

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
