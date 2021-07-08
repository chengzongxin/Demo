//
//  GEStorage.m
//  AFNetworking
//
//  Created by jerry.jiang on 2018/12/25.
//

#import "GEStorage.h"
//#if __has_include(<FMDB.h>)
//#import <FMDB.h>
//#else
//#import "FMDB.h"
//#endif

@implementation GEStorage

static BOOL _hasLocalData = YES;
static NSString *_dbName = @"GodeyeDB";
static NSString *_tableName = @"GECache";

static const int _limit = 100;
static const int _capacity = 1000;

+ (void)putData:(NSArray <GETrackerModel *> *)data
{
    if (data.count == 0) {
        return;
    }
    
    
//
//    [[self _database] inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
//        for (GETrackerModel *model in data) {
//            NSData *dat = [NSKeyedArchiver archivedDataWithRootObject:model];
//            NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ (id, time, data) VALUES (?, ?, ?)", _tableName];
//            [db executeUpdate:sql withArgumentsInArray:@[model.trackerId, @(model.time), dat]];
//        }
//
//        FMResultSet *res = [db executeQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", _tableName]];
//        if ([res next]) {
//            NSNumber * obj = res.resultDictionary[@"COUNT(*)"];
//            int count = [obj respondsToSelector:@selector(intValue)] ? [obj intValue] : 0;
//            if (count > _capacity) {
//                FMResultSet *timeout = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY `time` ASC LIMIT %d", _tableName, count - _capacity]];
//                while ([timeout next]) {
//                    NSDictionary *dic = timeout.resultDictionary;
//                    NSString *sql = [NSString stringWithFormat:@"DELETE FROM `%@` WHERE `time` = '%@';", _tableName, dic[@"time"]];
//                    [db executeUpdate:sql];
//                }
//            }
//        }
//    }];
//
//    _hasLocalData = YES;
}

+ (NSArray *)getData
{
//    if (!_hasLocalData || ![self _databaseExists]) {
//        _hasLocalData = NO;
//        return nil;
//    }
//    NSMutableArray *data = [NSMutableArray array];
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %d", _tableName, _limit];
//
//    [[self _database] inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
//        FMResultSet *res = [db executeQuery:sql];
//        while ([res next]) {
//            NSDictionary *dic = res.resultDictionary;
//            @try {
//                GETrackerModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:dic[@"data"]];
//                [data addObject:model];
//            } @catch (NSException *exception) {} @finally {}
//        }
//    }];
//
//    if (data.count) {
//        return data;
//    } else {
//        _hasLocalData = NO;
        return nil;
//    }
}

+ (void)removeData:(NSArray *)data
{
//    if (data.count == 0) {
//        return;
//    }
//    [[self _database] inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
//        for (GETrackerModel *model in data) {
//            NSString *sql = [NSString stringWithFormat:@"DELETE FROM `%@` WHERE `id` = '%@';", _tableName, model.trackerId];
//            [db executeUpdate:sql];
//        }
//    }];
}


//+ (FMDatabaseQueue *)_database
//{
//    static FMDatabaseQueue *_db = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSString *file = [path stringByAppendingPathComponent:_dbName];
//        _db = [FMDatabaseQueue databaseQueueWithPath:file];
//
//        NSString *createTableIfNeeded = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS `%@` (\
//                                         `id`   TEXT    NOT NULL,\
//                                         `time`  INTEGER    NOT NULL,\
//                                         `data`  BLOB    NOT NULL,\
//                                         PRIMARY KEY(id)\
//                                         );", _tableName];
//
//        [_db inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
//            [db executeUpdate:createTableIfNeeded];
//        }];
//    });
//    return _db;
//}

+ (BOOL)_databaseExists
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [path stringByAppendingPathComponent:_dbName];
    return [[NSFileManager defaultManager] fileExistsAtPath:file];
}



@end
