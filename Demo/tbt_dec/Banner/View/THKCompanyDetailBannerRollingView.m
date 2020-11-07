//
//  THKCompanyDetailBannerRollingView.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "THKCompanyDetailBannerRollingView.h"
#import "TDecDetailFirstModel.h"
#import "THKCompanyDetailBannerRollingLiveCell.h"
#import "THKCompanyDetailBannerRollingAppointmentCell.h"

@interface THKCompanyDetailBannerRollingView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewlayout;
@property (nonatomic, copy) NSArray <TDecDetailVideoModel *>*viewModel;
// 定时器
@property (nonatomic, strong) NSTimer *timer;
// UICollectionView当前的Row
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL isAutoScrolling;
@end

@implementation THKCompanyDetailBannerRollingView
TMUI_PropertySyntheSize(viewModel);

- (void)dealloc {
    [self removeTimer];
    NSLog(@"THKCompanyDetailBannerRollingView---------------->:dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self bindEvent];
        [self addTimer];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = UIColorRGBA(0, 0, 0, 0.4);
    UIImageView *bgImgV = [[UIImageView alloc] initWithImage:kImgAtBundle(@"CompanyDetailBanner_roll_bg")];
    [self addSubview:bgImgV];
    [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.mas_equalTo(61);
    }];
    self.layer.cornerRadius = 8;
    [self addSubview:self.collectionView];
}

- (void)bindEvent {
    @weakify(self);
    [[RACObserve(self, currentIndex) takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSLog(@"%@",x);
        if (self.currentIndex > 800) {
            self.currentIndex = 0;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }];
    // 后台进前台通知 UIApplicationDidBecomeActiveNotification
    [[[NSNotificationCenter.defaultCenter rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self resumeTimer];
    }];
    // 进入后台通知 UIApplicationDidEnterBackgroundNotification
    [[[NSNotificationCenter.defaultCenter rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self pauseTimer];
    }];
}


- (void)bindViewModel{
//    [self.collectionView reloadData];
}

- (void)addTimer {
    if (self.timer) {
        return;
    }
    
    @weakify(self);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        @strongify(self);
        [self timerScheduledAction];
    }];
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

#pragma mark - Public

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


#pragma mark - Private

// 定时器回调方法
- (void)timerScheduledAction {
    if (!self) {
        return;
    }
    NSInteger toIndex = self.currentIndex + 1;
    
    if (toIndex < 0 || toIndex >= [self.collectionView numberOfItemsInSection:0]) {
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.viewModel.count <= 1) return;
    
    CGFloat height = scrollView.frame.size.height;
    NSInteger currentIndex = ceil(scrollView.contentOffset.y/height);
    if (currentIndex == self.currentIndex) {
        return;
    }
    
    self.currentIndex = currentIndex;
}

#pragma mark - Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.frame.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.count > 1 ? self.viewModel.count * 1000 : self.viewModel.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    int index = indexPath.item % (int)self.viewModel.count;
    
    if (index == 0 || index == 1) {
        THKCompanyDetailBannerRollingLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKCompanyDetailBannerRollingLiveCell class]) forIndexPath:indexPath];
//        [cell.tapRemindSubject subscribe:self.tapRemindSignal];
//        [[cell.tapRemindSubject takeUntil:cell.rac_prepareForReuseSignal] subscribe:self.tapRemindSignal];
        @weakify(self);
        [[cell.tapRemindSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.tapRemindSignal sendNext:x];
        }];
        return cell;
    }else{
        THKCompanyDetailBannerRollingAppointmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKCompanyDetailBannerRollingAppointmentCell class]) forIndexPath:indexPath];
            
        return cell;
    }
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewlayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
//        _collectionView.scrollsToTop = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[THKCompanyDetailBannerRollingLiveCell class]
            forCellWithReuseIdentifier:NSStringFromClass([THKCompanyDetailBannerRollingLiveCell class])];
        [_collectionView registerClass:[THKCompanyDetailBannerRollingAppointmentCell class]
            forCellWithReuseIdentifier:NSStringFromClass([THKCompanyDetailBannerRollingAppointmentCell class])];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewlayout
{
    if (!_collectionViewlayout) {
        _collectionViewlayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionViewlayout.minimumInteritemSpacing = 0;
        _collectionViewlayout.minimumLineSpacing = 0;
        _collectionViewlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionViewlayout.itemSize = self.frame.size;
    }
    return _collectionViewlayout;
}

TMUI_PropertyLazyLoad(RACSubject, tapRemindSignal);

@end
