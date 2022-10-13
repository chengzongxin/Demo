//
//  THKCalculateQuotationSelectButtonView.h
//  Demo
//
//  Created by 程宗鑫 on 2022/10/12.
//

#import "THKView.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKCalculateQuotationSelectButtonView : THKView

@property (nonatomic, copy) NSArray *datas;


@property (nonatomic, copy) void (^tapItem)(NSInteger idx,NSString *text);



- (void)setDefalutIdx:(NSInteger)idx;

@end

NS_ASSUME_NONNULL_END
