//
//  RegistScrollViewProxy.m
//  THKMyTestApp
//
//  Created by amby.qin on 2020/12/3.
//

#import "RegistScrollViewProxy.h"
#import <objc/runtime.h>
#import "GEScrollViewExposeManger.h"
#import "UIScrollView+Godeye.h"

/**
 这是一个消息中转类，它接收并保存scrollView，同时保存原始的scrollView.delegate为originTarget，生成一个管理对象managerTarget作为目标处理逻辑(主要是监听列表事件，计算曝光的cell)；
 然后把scrollView.delegate设置成self，这样scrollView的代理方法就会触发这个类的消息转发流程，
 在消息转发流程中先响应originTarget执行原始逻辑，然后再响应managerTarget目标处理逻辑;
 注意：在对象销毁时需要把scrollView.delegate还原
 */
@interface RegistScrollViewProxy()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;//保存scrollView，当对象销毁时要把它的delegate还原

@property (nonatomic, weak) id originTarget;//此为截断的主delegate目标对象，所有默认操作均为此对象实际响应
@property (nonatomic, strong) GEScrollViewExposeManger *managerTarget;


@end

@implementation RegistScrollViewProxy

+ (instancetype)proxy {
    RegistScrollViewProxy *proxy = [self alloc];
    proxy.managerTarget = [[GEScrollViewExposeManger alloc] init];
    return proxy;
}

- (void)dealloc {
    if (self.scrollView) {
        self.scrollView.delegate = self.originTarget;
    }
}

- (void)attachScrollView:(UIScrollView * __nullable)scrollView {
    if (!scrollView) {
        if (self.originTarget) {
            self.scrollView.delegate = self.originTarget;
        }
    } else {
        if ([scrollView.delegate isEqual:self]) {
            return;
        }
        if ([scrollView.delegate isProxy] && ![scrollView.delegate respondsToSelector:@selector(disableProxy)]) {
            self.originTarget = scrollView.originDelegate;
        } else {
            self.originTarget = scrollView.delegate;
        }
       
        self.scrollView = scrollView;
        scrollView.delegate = self;
    }
}

- (BOOL)disableProxy {
    return YES;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {

    //NSLog(@"methodSignatureForSelector = %@",NSStringFromSelector(sel));
    NSMethodSignature *sig = nil;
    //先响应原始的逻辑
    if (self.originTarget && [self.originTarget respondsToSelector:sel]) {
        sig = [self.originTarget methodSignatureForSelector:sel];
    }

    //再响应拦截处理的逻辑
    if (self.managerTarget && [self.managerTarget respondsToSelector:sel]) {
        sig = [self.managerTarget methodSignatureForSelector:sel];
    }

    return sig;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    //显示的常见方法回调中转
    if (self.originTarget && [self.originTarget respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.originTarget];
    }
    
    if (self.managerTarget && [self.managerTarget respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.managerTarget];
    }
}

#pragma mark - 以下方法比较特殊，重写处理中转一下
- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    BOOL rt = [self.originTarget conformsToProtocol:aProtocol];
    if (!rt) {
        rt = [self.managerTarget conformsToProtocol:aProtocol];
    }
    return rt;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL rt = [self.originTarget respondsToSelector:aSelector];
    if (!rt) {
        rt = self.managerTarget && [self.managerTarget respondsToSelector:aSelector];
    }
    return rt;
}

- (BOOL)isKindOfClass:(Class)aClass {
    BOOL rt = [self.originTarget isKindOfClass:aClass];
    return rt;
}
- (BOOL)isMemberOfClass:(Class)aClass {
    BOOL rt = [self.originTarget isMemberOfClass:aClass];
    return rt;
}

@end
