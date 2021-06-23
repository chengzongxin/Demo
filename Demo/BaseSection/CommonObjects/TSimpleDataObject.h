//
//  TSimpleDataObject.h
//  to8to
//
//  Created by kevin.huang on 14-4-23.
//
//  常用到的只有id和name两个字段的model

#import <Foundation/Foundation.h>


@interface TSimpleDataObject : NSObject

@property (nonatomic,assign) NSInteger _id;///< 若用字典初始化，则对应key兼容 "_id"和"id" 串
@property (nonatomic,strong) NSString *_name;///< 若用字典初始化，则对应key兼容 "_name"和"name" 串
@property (nonatomic,assign) NSInteger typeId;
@property (nonatomic,strong) NSString *value;

@end
