//
//  TMUIScrollSearchContentView.h
//  Demo
//
//  Created by 程宗鑫 on 2022/3/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMUIScrollSearchContentView : UIView

//设置热词数组，支持重设
//数组数量或者元素不同即判断为重设
//重设会自然滚到新热词的第一个
- (void)setHotwords:(NSArray <NSString *> *)hotwords;

//开始滚动
- (void)startScroll;

//停止滚动
- (void)stopScroll;

//停止计时器
- (void)invalidateTimer;

//定位
- (void)scrollToIndex:(NSInteger)idx;

//定位
- (void)scrollToHotword:(NSString *)word;

//点击热词
- (void)setClickHotwordBlock:(void(^)(NSInteger idx,NSString *text))block;

//热词滚动
- (void)setScrollToHotwordBlock:(void(^)(NSInteger idx,NSString *text))block;

//当前索引值
- (NSInteger)currentIndex;

//当前标题
- (NSString *)currentTitle;

@end

NS_ASSUME_NONNULL_END
