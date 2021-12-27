//
//  THKMaterialTitleRankView.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/22.
//

#import "THKView.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, THKMaterialTitleRankViewStyle) {
    THKMaterialTitleRankViewStyleBlue                   = 1 << 0,  // 蓝色
    THKMaterialTitleRankViewStyleGold                   = 1 << 1,  // 金色
    THKMaterialTitleRankViewStyleBlue_NoCrown           = 1 << 2,  // 蓝色无皇冠
    THKMaterialTitleRankViewStyleGold_NoCrown           = 1 << 3,  // 金色无皇冠
};

@interface THKMaterialTitleRankView : THKView

//- (instancetype)initWithStyle:(THKMaterialTitleRankViewStyle)style;

- (instancetype)initWithStyle:(THKMaterialTitleRankViewStyle)style titleFont:(UIFont *)titleFont;

- (void)setText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
