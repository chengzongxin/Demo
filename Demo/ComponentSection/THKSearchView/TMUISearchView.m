//
//  THKSearchView.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/8.
//

#import "TMUISearchView.h"
#import "THKScrollHotwordView.h"
@interface TMUISearchView ()


@property (nonatomic, strong) UIImageView *searchIcon;

@property (nonatomic, strong) THKScrollHotwordView *scrollHotwordView;


@end

@implementation TMUISearchView


- (void)invalidateTimer
{
    [_scrollHotwordView invalidateTimer];
}

- (void)thk_setupViews
{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8;
    self.layer.borderWidth = .5;
    self.layer.borderColor = [UIColor colorWithRed:236/255.f green:238/255.f blue:236/255.f alpha:1].CGColor;
    
    [self addSubview:self.searchIcon];
    [_searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(12);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self addSubview:self.scrollHotwordView];
    [_scrollHotwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(36);
        make.left.equalTo(_searchIcon.mas_right).with.offset(8);
        make.right.equalTo(self).with.offset(-8);
    }];
}

- (void)setHotwords:(NSArray<NSString *> *)hotwords
{
    [_scrollHotwordView setHotwords:hotwords];
}

- (void)startScroll
{
    [_scrollHotwordView startScroll];
}

- (void)scrollToIndex:(NSInteger)idx
{
    [_scrollHotwordView scrollToIndex:idx];
}

//定位
- (void)scrollToHotword:(NSString *)word
{
    [_scrollHotwordView scrollToHotword:word];
}

- (void)stopScroll
{
    [_scrollHotwordView stopScroll];
}

- (NSInteger)currentIndex
{
    return [_scrollHotwordView currentIndex];
}

- (NSString *)currentTitle
{
    return [_scrollHotwordView currentTitle];
}

- (void)setClickHotwordBlock:(void (^)(NSInteger, NSString * _Nonnull))block
{
    [_scrollHotwordView setClickHotwordBlock:block];
}

- (void)setScrollToHotwordBlock:(void (^)(NSInteger, NSString * _Nonnull))block
{
    [_scrollHotwordView setScrollToHotwordBlock:block];
}

- (THKScrollHotwordView *)scrollHotwordView
{
    if (!_scrollHotwordView) {
        _scrollHotwordView = [[THKScrollHotwordView alloc] init];
    }
    return _scrollHotwordView;
}

- (UIImageView *)searchIcon {
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc] init];
        _searchIcon.backgroundColor = [UIColor clearColor];
        _searchIcon.image = kImgAtBundle(@"home_nav_search");
    }
    return _searchIcon;
}

@end
