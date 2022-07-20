//
//  THKDecorationToDoModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationToDoModel : NSObject

@end

@interface THKDecorationToDoItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subtitle;

@end

@interface THKDecorationToDoSection : NSObject

@property (nonatomic, copy) NSArray <THKDecorationToDoItem *>*items;

@property (nonatomic, copy) NSString *stageName;

@property (nonatomic, assign) BOOL isOpen;

@end

NS_ASSUME_NONNULL_END
