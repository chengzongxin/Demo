//
//  THKCalculateQuotationView.h
//  Demo
//
//  Created by 程宗鑫 on 2022/10/12.
//

#import "THKView.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKCalculateQuotationView : THKView
+ (void)showAlertWithConfirmBlock:(void (^)(THKCalculateQuotationView *alertView))confirmBlock cancelBlock:(void (^)(THKCalculateQuotationView *alertView))cancelBlock;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
