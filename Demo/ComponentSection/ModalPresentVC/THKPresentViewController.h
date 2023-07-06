//
//  THKPresentViewController.h
//  Demo
//
//  Created by Joe.cheng on 2023/7/6.
//

#import "THKViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^THKPresentViewControllerBackBlock)(void);

@interface THKPresentViewController : THKViewController
// 内部生命周期会提前调用view，所以要在子类重写viewHeight的getter方法
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong, readonly) UIButton *closeBtn;

@property (copy, nonatomic) THKPresentViewControllerBackBlock backBlock;


@end

NS_ASSUME_NONNULL_END
