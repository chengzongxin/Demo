//
//  TestViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/6.
//

#import "TestViewController.h"

@interface TestViewController ()

@property (nonatomic, strong)  RACSubject *subject;
@property (nonatomic, weak)  RACSubject *wsb;
@property (nonatomic, weak)  RACSignal *wsg;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.orangeColor;
    _subject = [RACSubject subject];
    
    [_subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subject 1");
    }];
    
    [_subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subject 2");
    }];
    
    [_subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subject 3");
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [_subject sendNext:nil];
    
    
    {
        
        RACSubject *subject = [RACSubject subject];
        _wsb = subject;
        [subject subscribeNext:^(id  _Nullable x) {
            NSLog(@"subject  123123 3");
        }];
        
        [subject sendNext:@"1"];
        
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"czx"];
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"release");
            }];
        }];
        
        _wsg = signal;
        
        [signal subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
        }];
        
    }
    
    NSLog(@"wsb%@",_wsb);
    NSLog(@"wsg%@",_wsg);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"wsg%@",_wsg);
    });
}

- (void)dealloc{
    NSLog(@"dealloc %@",self);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"dealloc subjuect %@",self.subject);
    });
}


@end
