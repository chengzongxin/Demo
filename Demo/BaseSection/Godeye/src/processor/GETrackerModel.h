//
//  GETrackModel.h
//  Pods
//
//  Created by jerry.jiang on 2019/1/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GETrackerModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *trackerId;

@property (nonatomic, assign) int64_t time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *event;
@property (nonatomic, copy) NSString *session;
@property (nonatomic, strong) NSDictionary *properties;



+ (instancetype)trackerWithEvent:(NSString *)event properties:(NSDictionary *)properties;
- (NSDictionary *)dictionaryValue;

@end

NS_ASSUME_NONNULL_END
