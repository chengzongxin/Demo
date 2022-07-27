//
//  THKDecorationToDoModel.m
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKDecorationToDoModel.h"

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

- (NSString *)widgetTag{
    return [NSString stringWithFormat:@"%@ %@",self.serialNumber,self.stageName];
}

@end

@implementation THKDecorationUpcomingModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"upcomingList":THKDecorationUpcomingListModel.class};
}

- (NSString *)widgetTag{
    return [NSString stringWithFormat:@"%@ %@",self.serialNumber,self.stageName];
}


@end


@implementation THKDecorationToDoModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"stageList":THKDecorationUpcomingModel.class};
}
@end


@implementation THKDecorationUpcomingListCacheModel

@end
