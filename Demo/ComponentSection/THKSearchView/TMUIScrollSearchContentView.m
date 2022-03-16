//
//  TMUIScrollSearchContentView.m
//  Demo
//
//  Created by 程宗鑫 on 2022/3/16.
//

#import "TMUIScrollSearchContentView.h"
#import "NSTimer+TMUI.h"

@interface TMUIScrollSearchContentView ()<CAAnimationDelegate>

@property (nonatomic, copy) void(^block)(NSInteger idx,NSString *text);

@property (nonatomic, copy) void(^scrollBlock)(NSInteger idx,NSString *text);

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray <NSString *> *hotwords;

@property (nonatomic, strong) NSArray <NSString *> *orgHotwords;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL isScrolling;

@property (nonatomic, assign) BOOL isFirstScroll;

@property (nonatomic, assign) BOOL donotNeedReset;


@end

@implementation TMUIScrollSearchContentView

- (void)dealloc
{
    NSLog(@"THKScrollHotwordView dealloc");
    [self invalidateTimer];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)startScroll
{
    if (_isScrolling) {
        return;
    }
    _isScrolling = YES;
    [_timer setFireDate:[NSDate date]];
}

- (void)stopScroll
{
    if (!_isScrolling) {
        return;
    }
    _isScrolling = NO;
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [self invalidateTimer];
}

- (NSInteger)currentIndex
{
    return _currentIndex;
}

- (NSString *)currentTitle
{
    return _label.text;
}

- (void)setClickHotwordBlock:(void(^)(NSInteger idx,NSString *text))block
{
    _block = block;
}

- (void)setScrollToHotwordBlock:(void (^)(NSInteger, NSString * _Nonnull))block
{
    _scrollBlock = block;
}

- (void)setTimer
{
    @weakify(self);
    if (!_timer) {
        _timer = [NSTimer tmui_timerWithTimeInterval:4 block:^{
            @strongify(self);
            [self timerFunc:nil];
        } repeats:YES mode:NSRunLoopCommonModes];
    }
    
    [_timer setFireDate:[NSDate distantFuture]];
    _isScrolling = NO;
}

- (void)timerFunc:(id)sender
{
    if (_hotwords.count<2) {
        return;
    }
    
    if (!_isScrolling) {
        return;
    }
    
    NSInteger toIndex = _currentIndex+1;
    toIndex = toIndex%_hotwords.count;
    
    _label.text = [_hotwords safeObjectAtIndex:toIndex];

    if (!_isFirstScroll) {
        [_label.layer removeAllAnimations];
        CATransition *transition = [CATransition animation];
        transition.delegate = self;
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        [_label.layer addAnimation:transition forKey:@"updateAnimate"];
    }
    else {
        _currentIndex = toIndex;
        if (_scrollBlock) {
            _scrollBlock(toIndex,[_hotwords safeObjectAtIndex:toIndex]);
        }
        _isFirstScroll = NO;
    }
}

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSInteger toIndex = _currentIndex+1;
    toIndex = toIndex%_hotwords.count;
    _currentIndex = toIndex;
    if (_scrollBlock) {
        _scrollBlock(toIndex,[_hotwords safeObjectAtIndex:toIndex]);
    }
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    if (CGSizeEqualToSize(CGSizeZero, _label.frame.size)) {
//        _label.frame = self.bounds;
//    }
//}

- (void)setHotwords:(NSArray<NSString *> *)hotwords
{
    _donotNeedReset = NO;
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = UIFont(14);
        _label.textColor = UIColorFromRGB(0x999999);
        _label.userInteractionEnabled = YES;
        @weakify(self);
        [_label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            if (self.label.text.length==0) {
                if (self.block) {
                    self.block(0, nil);
                }
                return;
            }
            NSInteger idx = [self.hotwords indexOfObject:self.label.text];
            if (idx >= 0 && idx < self.hotwords.count) {
                if (self.block) {
                    self.block(idx, self.label.text);
                }
            }
        }]];
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    if ([self isSame:hotwords]) {
        _donotNeedReset = YES;
        _orgHotwords = hotwords;
        return;
    }
    
    _orgHotwords = [hotwords copy];
    
    if (hotwords.count==0) {
        [self reset];
        return;
    }
    
    _label.hidden = NO;
    
    [self setTimer];
    
    [self reset];
    
    _hotwords = hotwords;
}

- (void)scrollToIndex:(NSInteger)idx
{
    if (idx < 0 || idx >= _hotwords.count) {
        return;
    }
    [self scrollToHotword:[_hotwords safeObjectAtIndex:0]];
}

- (void)scrollToHotword:(NSString *)word
{
    if (_donotNeedReset) {
        [self startScroll];
        return;
    }
    if (!word) {
        return;
    }
    [self stopScroll];
    
    _isFirstScroll = YES;
    
    if (_hotwords.count<2) {
        _label.text = _hotwords.firstObject;
        return;
    }
    
    __block NSInteger idx = -1;
    [_hotwords enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx_, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:word]) {
            idx = idx_;
            *stop = YES;
        }
    }];

    if (idx >=0 && idx < _hotwords.count) {
        NSMutableArray *lst = @[].mutableCopy;
        for (NSInteger i = idx; i < _hotwords.count; i++) {
            [lst safeAddObject:[_hotwords safeObjectAtIndex:i]];
        }
        for (NSInteger i = 0; i < idx; i++) {
            [lst safeAddObject:[_hotwords safeObjectAtIndex:i]];
        }
        _hotwords = lst;
    }
    
    _currentIndex = -1;
    _label.text = [_hotwords safeObjectAtIndex:0];
    [self startScroll];
}

- (void)reset
{
    [_timer setFireDate:[NSDate distantFuture]];
    _label.text = nil;
    _hotwords = nil;
    _currentIndex = -1;
}

- (BOOL)isSame:(NSArray *)textDataArr
{
    if (textDataArr.count != _orgHotwords.count) {
        return NO;
    }
    for (NSInteger idx = 0; idx < textDataArr.count; idx++) {
        NSString *str1 = [textDataArr objectAtIndex:idx];
        NSString *str2 = [_orgHotwords objectAtIndex:idx];
        if (![str1 isEqualToString:str2]) {
            return NO;
        }
    }
    return YES;
}


@end
