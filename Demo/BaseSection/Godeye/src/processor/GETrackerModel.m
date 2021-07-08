//
//  GETrackModel.m
//  Pods
//
//  Created by jerry.jiang on 2019/1/2.
//

#import "GETrackerModel.h"
#import "GEEnvironmentParameter.h"
#define CURRENT_TIMESTAMP (CFAbsoluteTimeGetCurrent()+kCFAbsoluteTimeIntervalSince1970)
@implementation GETrackerModel

extern NSString *md5_convert(NSString *string);

static NSString *_debugInfo = nil;

+ (instancetype)trackerWithEvent:(NSString *)event properties:(nonnull NSDictionary *)properties
{
    NSParameterAssert(event);
    GETrackerModel *tracker = [[GETrackerModel alloc] init];
    tracker.event = event;
    tracker.type = @"appTrack";
    tracker.time = 1000 * CURRENT_TIMESTAMP;
    tracker.properties = properties;
    tracker.session = [GEEnvironmentParameter defaultParameter].session;
    return tracker;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.trackerId forKey:@"trackerId"];
    [aCoder encodeInt64:self.time forKey:@"time"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.event forKey:@"event"];
    [aCoder encodeObject:self.properties forKey:@"properties"];
    [aCoder encodeObject:self.session forKey:@"session"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.trackerId = [aDecoder decodeObjectForKey:@"trackerId"];
        self.time = [aDecoder decodeInt64ForKey:@"time"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.event = [aDecoder decodeObjectForKey:@"event"];
        self.properties = [aDecoder decodeObjectForKey:@"properties"];
        self.session = [aDecoder decodeObjectForKey:@"session"];
    }
    return self;
}

- (NSString *)trackerId
{
    if (!_trackerId) {
        _trackerId = md5_convert([NSString stringWithFormat:@"%lld_%d",self.time, arc4random()]);
    }
    return _trackerId;
}

- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary *dic = [@{@"event":self.event,
                                  @"type":self.type,
                                  @"time":@(self.time),
                                  @"tracker_id":self.trackerId,
                                  @"properties":self.properties ?:@{},
                                  @"session":self.session,
                                  } mutableCopy];
    return [dic copy];
}

@end
