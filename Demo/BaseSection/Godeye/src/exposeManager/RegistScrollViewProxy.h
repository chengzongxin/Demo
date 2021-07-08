//
//  RegistScrollViewProxy.h
//  THKMyTestApp
//
//  Created by amby.qin on 2020/12/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegistScrollViewProxy : NSProxy

+ (instancetype)proxy;
- (void)attachScrollView:(UIScrollView * __nullable)scrollView;

@end

NS_ASSUME_NONNULL_END
