//
//  THKUGCDetailPageControlCell.m
//  HouseKeeper
//
//  Created by cl w on 2021/12/11.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKUGCDetailPageControlCell.h"
#import "ZYPageControlVIew.h"

@interface THKUGCDetailPageControlCell ()

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) NSInteger photoNum;

@property (nonatomic, strong) ZYPageControlVIew *pageControl;

@end

@implementation THKUGCDetailPageControlCell

- (void)updateIndex:(NSInteger)idx
{
    if (_photoNum<1) {
        return;
    }
    if (idx == _currentIndex) {
        return;
    }
    if (idx < 0) {
        idx = 0;
    }
    if (idx >= _photoNum) {
        idx = _photoNum-1;
    }
    _currentIndex = idx;
    _pageControl.currentPage = idx;
}

- (void)setPhotoNum:(NSInteger)photoNum
{
    _photoNum = photoNum;
    
    if (!_pageControl && photoNum>1) {
        _pageControl = [[ZYPageControlVIew alloc] init];
        _pageControl.numberOfPages = photoNum;
        _pageControl.currentPage = 0;
        _pageControl.maximumVisablePages = 5;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = UIColorPrimary;
        _pageControl.pageIndicatorTintColor = UIColorBorder;
        [self.contentView addSubview:_pageControl];
        [self.contentView bringSubviewToFront:_pageControl];
        self.contentView.backgroundColor = [UIColor whiteColor];
        _pageControl.frame = CGRectMake(kScreenWidth/2.f-150, 3, 300, 20);
    }
}

@end
