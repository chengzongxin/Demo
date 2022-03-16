//
//  TMUIScrollSearchBar.m
//  Demo
//
//  Created by 程宗鑫 on 2022/3/16.
//

#import "TMUIScrollSearchBar.h"
#import "TMUIScrollSearchContentView.h"

@interface TMUIScrollSearchBar ()<CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *searchIcon;

@property (nonatomic, strong) TMUIScrollSearchContentView *scrollContentView;

@end


@implementation TMUIScrollSearchBar


- (void)invalidateTimer
{
    [_scrollContentView invalidateTimer];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
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
    
    [self addSubview:self.scrollContentView];
    [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(36);
        make.left.equalTo(_searchIcon.mas_right).with.offset(8);
        make.right.equalTo(self).with.offset(-8);
    }];
}

- (void)setHotwords:(NSArray<NSString *> *)hotwords
{
    [_scrollContentView setHotwords:hotwords];
    [_scrollContentView startScroll];
}

- (void)startScroll
{
    [_scrollContentView startScroll];
}

- (void)scrollToIndex:(NSInteger)idx
{
    [_scrollContentView scrollToIndex:idx];
}

//定位
- (void)scrollToHotword:(NSString *)word
{
    [_scrollContentView scrollToHotword:word];
}

- (void)stopScroll
{
    [_scrollContentView stopScroll];
}

- (NSInteger)currentIndex
{
    return [_scrollContentView currentIndex];
}

- (NSString *)currentTitle
{
    return [_scrollContentView currentTitle];
}

- (void)setClickHotwordBlock:(void (^)(NSInteger, NSString * _Nonnull))block
{
    [_scrollContentView setClickHotwordBlock:block];
}

- (void)setScrollToHotwordBlock:(void (^)(NSInteger, NSString * _Nonnull))block
{
    [_scrollContentView setScrollToHotwordBlock:block];
}

- (TMUIScrollSearchContentView *)scrollContentView
{
    if (!_scrollContentView) {
        _scrollContentView = [[TMUIScrollSearchContentView alloc] init];
    }
    return _scrollContentView;
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
