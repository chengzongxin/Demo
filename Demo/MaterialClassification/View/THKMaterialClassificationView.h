//
//  THKMaterialClassificationView.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKView.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialClassificationView : THKView

@property (nonatomic, copy) void (^tapItem)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
