//
//  THKMaterialTitleRankView.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/22.
//

#import "THKView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, THKMaterialTitleRankViewStyle) {
    THKMaterialTitleRankViewStyleBlue,
    THKMaterialTitleRankViewStyleGold
};

@interface THKMaterialTitleRankView : THKView

- (instancetype)initWithStyle:(THKMaterialTitleRankViewStyle)style;

- (void)setText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
