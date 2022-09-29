//
//  THKValuePointIntroductionVM.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/29.
//

#import "THKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKValuePointImg : NSObject

@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

+ (instancetype)createImgWith:(NSString *)imgUrl width:(CGFloat)width height:(CGFloat)height;

@end

@interface THKValuePointIntroductionVM : THKViewModel

@property (nonatomic, strong) NSArray <THKValuePointImg *> *imgs;

@end

NS_ASSUME_NONNULL_END
