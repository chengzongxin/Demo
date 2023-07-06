//
//  THKModalPresentVC.h
//  Demo
//
//  Created by Joe.cheng on 2023/7/6.
//

#import "THKViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^THKModalPresentVCBackBlock)(void);

@interface THKModalPresentVC : UIViewController

@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong, readonly) UIButton *closeBtn;

@property (copy, nonatomic) THKModalPresentVCBackBlock backBlock;

@end

NS_ASSUME_NONNULL_END
