//
//  THKCalculateQuotationView.h
//  Demo
//
//  Created by 程宗鑫 on 2022/10/12.
//

#import "THKView.h"
#import "THKCalculateQuotationViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKCalculateQuotationView : THKView

@property (nonatomic, strong, readonly) THKCalculateQuotationViewModel *viewModel;

+ (void)showWithViewModel:(THKViewModel *)viewModel success:(void (^)(THKCalculateQuotationView * _Nonnull))confirmBlock cancelBlock:(void (^)(THKCalculateQuotationView * _Nonnull))cancelBlock;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
