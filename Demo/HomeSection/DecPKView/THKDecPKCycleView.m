//
//  THKDecPkCycleView.m
//  Demo
//
//  Created by Joe.cheng on 2022/12/23.
//

#import "THKDecPKCycleView.h"
#import "TMUICycleView.h"
#import "TMUITimer.h"

static CGFloat const kPageControlBottom = 20;
static CGFloat const kCycleViewMaxCountMultiple = 1000;

@interface THKDecPKCycleView ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

// UICollectionView当前的Row
@property (nonatomic, assign) NSInteger currentNumberOfItem;
// 轮播图的页数
// (numbers * kBannerViewMaxCountMultiple) 等于
// UICollectionView 的 numberOfItemsInSection:0
@property (nonatomic, assign) NSInteger numbers;

@property (nonatomic, strong) TMUITimer *timer;

@property (nonatomic, strong) TMUIPageControl *pageControl;

@property (nonatomic, assign) BOOL isAutoScrolling;


//标记滑动前的页数
@property (nonatomic, assign) NSInteger draggingStartPage;

@end

@implementation THKDecPKCycleView

- (void)dealloc {
    [self removeTimer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfigs];
        [self setupSubviews];
    }
    return self;
}

- (void)setupConfigs {
    self.numbers = 0;
    
    [self addTimer];
    [self addObservers];
}

- (void)setupSubviews {
    [self addSubview:self.collectionView];
//    [self addSubview:self.pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat y = self.bounds.size.height - 5.0 - kPageControlBottom;
    _pageControl.frame = CGRectMake(0, y, self.bounds.size.width, 5.0);
}

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

- (void)addTimer {
    __weak __typeof(self)weakSelf = self;
    self.timer = [[TMUITimer alloc] initWithInterval:5 block:^{
        [weakSelf timerScheduledAction];
    }];
    
    self.isAutoScrolling = YES;
}

- (void)removeTimer {
    [self.timer removeTimer];
}

#pragma mark - Public

- (void)resumeTimer {
    if (self.isAutoScrolling) {
        return;
    }
    
    [self.timer resumeTimer];
    self.isAutoScrolling = YES;
}

- (void)pauseTimer {
    if (!self.isAutoScrolling) {
        return;
    }
    
    [self.timer pauseTimer];
    
    self.isAutoScrolling = NO;
}

- (void)setDatas:(NSArray *)datas{
    _datas = datas;
    
    [self reloadData];
}

- (id)objectInDatasAtIndex:(NSUInteger)index{
    NSInteger idx = index % self.numbers;
    return self.datas[idx];
}

- (void)reloadData {
    self.numbers = self.datas.count;
    self.pageControl.numberOfPages = self.numbers;
    self.pageControl.currentPage = 0;
    
    [self.collectionView reloadData];
    
    if (self.numbers == 0) {
        self.pageControl.hidden = YES;
        [self removeTimer];
        return;
    }
    
    // 只有一张的时候,隐藏PageControl, 禁止滚动, 移除定时器
    if (self.numbers == 1) {
        self.pageControl.hidden = YES;
        self.collectionView.scrollEnabled = NO;
        [self removeTimer];
    } else {
        self.pageControl.hidden = NO;
        self.collectionView.scrollEnabled = YES;
    }
    
    self.currentNumberOfItem = self.numbers * (kCycleViewMaxCountMultiple / 2);
        
    if (self.currentNumberOfItem >= [self.collectionView numberOfItemsInSection:0]) {
        return;
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentNumberOfItem inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionNone
                                            animated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (self.scrollCell) {
                NSInteger idx = [self pageAt:self.collectionView.contentOffset.x] % self.numbers;
                self.scrollCell(self, idx);
            }
        });
    });
    
//    [self.collectionView setContentOffset:CGPointMake(self.currentNumberOfItem * self.frame.size.width, 0) animated:NO];
}

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (__kindof UICollectionViewCell *)cellForItemAtCurrentIndex {
    return [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentNumberOfItem inSection:0]];
}

#pragma mark - Private

// 定时器回调方法
- (void)timerScheduledAction {
    if (!self) {
        return;
    }
    NSInteger toIndex = self.currentNumberOfItem + 1;
    
    if (toIndex < 0 || toIndex >= [self.collectionView numberOfItemsInSection:0]) {
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:YES];
//    [self.collectionView setContentOffset:CGPointMake(toIndex * self.width, 0) animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollViewDidEndDecelerating:self.collectionView];
    });
}

// 后台进前台通知
// UIApplicationDidBecomeActiveNotification
- (void)didBecomeActive {
    [self resumeTimer];
}

// 进入后台通知
// UIApplicationDidEnterBackgroundNotification
- (void)didEnterBackground {
    [self pauseTimer];
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.numbers * kCycleViewMaxCountMultiple);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.flowLayout.itemSize;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THKDecPKSrcollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKDecPKSrcollCell class])
                                                                           forIndexPath:indexPath];
    NSInteger idx = indexPath.item % self.numbers;
    cell.model = self.datas[idx];
    !_configCell?:_configCell(cell,self.datas[idx]);
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THKDecPKSrcollCell *cell = (THKDecPKSrcollCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSInteger idx = indexPath.item % self.numbers;
    !_selectCell?:_selectCell(cell,self.datas[idx]);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
    
    self.draggingStartPage = [self pageAt:self.collectionView.contentOffset.x];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}


/// 若要显示第idx索引位置的卡片，需要设置的offset.x值
- (CGFloat)offsetXOfItemAtIndex:(NSInteger)idx {
    if (idx == 0) {
        return 0;
    }
    return self.flowLayout.sectionInset.left + (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing) * idx - self.flowLayout.minimumLineSpacing - (self.collectionView.contentInset.left - self.flowLayout.minimumInteritemSpacing);
}
#pragma mark - ScrollViewDelegate

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset offsetPage:(NSInteger)offsetPage {
    NSInteger page = [self pageAt:offset.x] + offsetPage;
    if ([self.collectionView numberOfItemsInSection:0] > 0) {
        page = MAX(page, 0);
        page = MIN(page, [self.collectionView numberOfItemsInSection:0] - 1);
    }
    CGFloat targetX = [self offsetXOfItemAtIndex:page];
    targetX = MIN(targetX, self.collectionView.contentSize.width - self.collectionView.bounds.size.width);
    // 滑动到第一个或者最后一个额外增加contentInset的边距
    if (page == 0) {
        targetX -= self.collectionView.contentInset.left;
    }else if (page == [self.collectionView numberOfItemsInSection:0] - 1) {
        targetX += self.collectionView.contentInset.right;
    }
    return CGPointMake(targetX, offset.y);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset offsetPage:0];
    //将要滑到的页数
    NSInteger toPage = [self pageAt:targetOffset.x];
    //当‘将滑动的页数’没变，并且手指速度很快直接滑动旁边格子（否则会滑回原来位置发生抖动）
    if (velocity.x != 0 && fabs(velocity.x) < 1.5 && self.draggingStartPage == toPage) {
        targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset offsetPage:(velocity.x > 0 ? 1: -1)];
    }

    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.draggingStartPage = [self pageAt:self.collectionView.contentOffset.x];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = [self pageAt:self.collectionView.contentOffset.x];
    if ([self.collectionView numberOfItemsInSection:0] > 0) {
        page = MIN(page, [self.collectionView numberOfItemsInSection:0] - 1);
    }
    self.currentNumberOfItem = page;
    
    if (self.scrollCell) {
        self.scrollCell(self, page);
    }
}

- (NSInteger)pageAt:(CGFloat)contentOffsetX {
    CGFloat pageWidth = self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing;
    return roundf((contentOffsetX - self.flowLayout.sectionInset.left) / pageWidth);
}


#pragma mark - lazy

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width - 20 * 2, 100) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [_collectionView registerClass:[THKDecPKSrcollCell class]
            forCellWithReuseIdentifier:NSStringFromClass([THKDecPKSrcollCell class])];
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width - 40 * 2, 100);
        _flowLayout.minimumInteritemSpacing = 8;
        _flowLayout.minimumLineSpacing = 8;
    }
    return _flowLayout;
}

- (TMUIPageControl *)pageControl {
    if (!_pageControl) {
        CGFloat y = self.bounds.size.height - 5.0 - kPageControlBottom;
        _pageControl = [[TMUIPageControl alloc] initWithFrame:CGRectMake(0, y, self.bounds.size.width, 3.0)];
        _pageControl.currentIndicatorSize = CGSizeMake(3.0, 3.0);
        _pageControl.indicatorSize = CGSizeMake(3.0, 3.0);
        _pageControl.indicatorInset = 6.0;
    }
    return _pageControl;
}


@end
