//
//  TMCardComponentScrollAdsBannerView.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/10/30.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentScrollAdsBannerView.h"
#import "NSTimer+Block.h"

#define kTMCardComponentScrollAdsMaxCountMultiple  (1000) //必须是偶数倍数值

@interface TMCardComponentScrollAdsBannerView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong, readonly)UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign)NSInteger itemCount;

@property (nonatomic, copy)void(^fillCellBlock)(__kindof UICollectionViewCell * cell, NSUInteger index);
@property (nonatomic, copy)void(^clickCellBlock)(__kindof UICollectionViewCell * cell, NSUInteger index);
@property (nonatomic, copy)void(^willDisplayCell)(UICollectionViewCell * cell, NSUInteger index);
@property (nonatomic, copy)void(^endDisplayCell)(UICollectionViewCell * cell, NSUInteger index);

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isAutoScrolling;

// UICollectionView当前的Row
@property (nonatomic, assign) NSInteger currentShowIdxOfItem;

@property (nonatomic, assign)BOOL noUpdatePageIdxWhenScroll;

@property (nonatomic, assign)BOOL ignoreAppStatusNoticeForTimer;/// 是否忽略app前后台通知对timer的影响，默认NO

@end

@implementation TMCardComponentScrollAdsBannerView

- (void)thk_setupViews {
    [super thk_setupViews];
    self.clipsToBounds = YES;
    [self initUI];
    //通知初始化后就加，dealloc里移除
    [self addObservers];
    //timer在reload时根据视图数量若需要滚动再加。
}

- (void)dealloc {
    [self removeTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //修正当前的contentOffset值| 第一次加载时指定了currentShowIdxOfItem值，但实际展示时contentOffset值并未有效的同步到指定位置，则需要手动修正一下offset值
    NSInteger curCellIdx = [self.collectionView indexPathsForVisibleItems].firstObject.item;
    if (curCellIdx != self.currentShowIdxOfItem) {
        if (self.currentShowIdxOfItem >= 0 &&
            self.currentShowIdxOfItem < [self.collectionView numberOfItemsInSection:0]) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentShowIdxOfItem inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
    
}

#pragma mark - public api

/*! 注册cell类型及cell展示时的回调
 */
- (void)registCellClass:(Class)cellClass fillCellForRowAtIndex:(void(^)(__kindof UICollectionViewCell * cell, NSUInteger index))fillBlock didClickCellForRowAtIndex:(void(^)(__kindof UICollectionViewCell * cell, NSUInteger index))clickBlock {
    if (cellClass) {
        [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:@"kCell"];
    }
    self.fillCellBlock = fillBlock;
    self.clickCellBlock = clickBlock;    
}

/*! 刷新容器视图，需要传入子视图生成的数量
 */
- (void)reloadDataOfTotalItemCount:(NSUInteger)itemCount {
    
    [self removeTimer];
    self.ignoreAppStatusNoticeForTimer = NO;
    
    self.itemCount = itemCount;
    [self.collectionView reloadData];
                
    // >1 个才支持滑动
    self.collectionView.scrollEnabled = self.itemCount > 1;
    
    // > 1时会生成 共 n * kTMCardComponentScrollAdsMaxCountMultiple 数量的位置供访左右循环滑动
    // <= 1时仅生成0个或1个 数量的位置展示即可
    if (self.itemCount > 1) {
        self.currentShowIdxOfItem = [self showItemCount] / 2;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentShowIdxOfItem inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [self addTimer];
    }else {
        self.currentShowIdxOfItem = 0;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark - private

- (void)initUI {
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.minimumLineSpacing = CGFLOAT_MIN;
    flowlayout.minimumInteritemSpacing = CGFLOAT_MIN;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout = flowlayout;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"kCell"];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.collectionView];

}

- (NSInteger)showItemCount {
    if (self.itemCount > 1) {
        return self.itemCount * kTMCardComponentScrollAdsMaxCountMultiple;
    }else {
        return self.itemCount;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self showItemCount];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kCell" forIndexPath:indexPath];
    cell.clipsToBounds = YES;
    
    if (self.fillCellBlock) {
        NSInteger cIndex = [self currentIndexFromIndexPath:indexPath];
        self.fillCellBlock(cell, cIndex);
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        
    if (self.clickCellBlock) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        NSInteger cIndex = [self currentIndexFromIndexPath:indexPath];
        self.clickCellBlock(cell, cIndex);
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.willDisplayCell) {
        NSInteger cIndex = [self currentIndexFromIndexPath:indexPath];
        self.willDisplayCell(cell, indexPath.item);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.endDisplayCell) {
        NSInteger cIndex = [self currentIndexFromIndexPath:indexPath];
        self.endDisplayCell(cell, cIndex);
    }
}

- (NSInteger)currentIndexFromIndexPath:(NSIndexPath *)indexPath {
    return [self currentIndexFromShowIndex:indexPath.item];
}

- (NSInteger)currentIndexFromShowIndex:(NSInteger)showIndex {
    if ([self showItemCount] > 1) {
        return showIndex%(self.itemCount);
    }else {
        return showIndex;
    }
}

- (NSInteger)currentIndex {
    NSInteger realDataIdx = [self currentIndexFromShowIndex:self.currentShowIdxOfItem];
    return realDataIdx;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //更新进度指示器
    if (self.itemCount <= 1) {return;}
    if (self.noUpdatePageIdxWhenScroll) {return;}
    
    if (self.didScrollToPageIndexBlock) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger curShowIdx = floor(scrollView.contentOffset.x/pageWidth + 0.5);
        if (curShowIdx == self.currentShowIdxOfItem) {return;}
        
        self.currentShowIdxOfItem = curShowIdx;
        
        NSInteger realDataIdx = [self currentIndexFromShowIndex:curShowIdx];
        self.didScrollToPageIndexBlock(realDataIdx, self.itemCount);
    }
}

//setContentOffset: 若scrollToRowxxx 相关方法，若有动画则会走到此回调
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self processScrollingEndEvent];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

//手拖动结束后的回调
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self processScrollingEndEvent];
        [self addTimer];
    }
}
//手拖动结束后且减速停止后的回调
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self processScrollingEndEvent];
    [self addTimer];
}

- (void)processScrollingEndEvent {
    if (self.itemCount <= 1) {return;}
    
    NSArray<NSIndexPath*> *indexPaths = [self.collectionView indexPathsForVisibleItems];
    if (indexPaths.count == 1) {
        NSIndexPath *indexPath = indexPaths.firstObject;
        NSInteger showCount = [self showItemCount];
        if (indexPath.item == 0 ||
            indexPath.item == showCount - 1) {
            //已经滑动到第一条数据，则需要将当前显示的idx重新调整到整体数量居中的位置
            // or
            //已经滑动到最后一条数据，则需要将当前显示的idx重新调整到整体数量居中的位置
            // 8.11.0后 第一周迭代优化发现的问题：当滑动到最后位时，当前总是最后一个位置，重置到中间显示位置时对应的真实数据索引值也应该与重置前的数据真实索引值值保持一致，变化才是连续的。原逻辑为 idx = idx + kTMCardComponentScrollAdsMaxCountMultiple / 2 进行计算取值是有问题的，因为是按kTMCardComponentScrollAdsMaxCountMultiple进行放大滑动的总数，且始终为偶数倍放大,故这里修正取值逻辑为: idx = idx + showCount / 2;
            // showCount/2值为真实数据索引为0时对应的整体滑动居中位置的索引，加上之前旧的真实数据索引idx即可保持调整后的显示位置索引对应的真实数据索引值仍然是调整之前的idx值
            NSInteger idx = [self currentIndexFromIndexPath:indexPath];
            idx = idx + showCount / 2;
            
            //添加标记，防止触发的滑动又调整了currentShowIdxOfItem
            self.currentShowIdxOfItem = idx;
            self.noUpdatePageIdxWhenScroll = YES;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            self.noUpdatePageIdxWhenScroll = NO;
        }
    }
}

#pragma mark - 定时器&自动滚动&切后台暂停and返回前台重新开启等
- (void)resumeTimerIfNeed {
    self.ignoreAppStatusNoticeForTimer = NO;
    [self resumeTimer];
}
- (void)pauseTimeIfNeed {
    self.ignoreAppStatusNoticeForTimer = YES;
    [self pauseTimer];
}
#pragma mark - timer
- (void)addTimer {
    if (self.timer) {
        return;
    }
    
    @weakify(self);
    self.timer = [NSTimer thk_scheduledTimerWithTimeInterval:5 block:^{
        @strongify(self);
        [self timerScheduledAction];
    } repeats:YES];
        
    self.isAutoScrolling = YES;
}

- (void)removeTimer {
    if (!self.timer) {
        return;
    }
    
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    
    self.timer = nil;
}

- (void)resumeTimer {
    if (!self.timer) {
        return;
    }
    if (self.isAutoScrolling) {
        return;
    }
    [self.timer setFireDate:[NSDate distantPast]];
    self.isAutoScrolling = YES;
}

- (void)pauseTimer {
    if (!self.timer) {
        return;
    }
    if (!self.isAutoScrolling) {
        return;
    }
    [self.timer setFireDate:[NSDate distantFuture]];
    self.isAutoScrolling = NO;
}

#pragma mark - app active & background status observer
- (void)addObservers {
    // 后台进前台通知 UIApplicationDidBecomeActiveNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    // 进入后台通知 UIApplicationDidEnterBackgroundNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

// 后台进前台通知
// UIApplicationDidBecomeActiveNotification
- (void)didBecomeActive {
    if (self.ignoreAppStatusNoticeForTimer) {return;}
    
    [self resumeTimer];
}

// 进入后台通知
// UIApplicationDidEnterBackgroundNotification
- (void)didEnterBackground {
    if (self.ignoreAppStatusNoticeForTimer) {return;}
    
    [self pauseTimer];
}


#pragma mark - time callbacks
- (void)timerScheduledAction {
    if (!self) {
        return;
    }
    
    NSInteger toIndex = self.currentShowIdxOfItem;
    if (toIndex == NSNotFound) {return;}
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (toIndex < 0 || toIndex >= numberOfItems) {return;}
    
    if (toIndex == 0 ||
        toIndex >= numberOfItems - 1) {
        //处于最开始和最末尾位置时，重新调整显示位置到居中位置
        [self processScrollingEndEvent];
    }
    
    toIndex = self.currentShowIdxOfItem + 1;
    if (toIndex < numberOfItems) {
        //防止某些异常情况越界crash
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:YES];
    }
}

@end
