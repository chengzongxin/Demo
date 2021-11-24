//
//  THKEntranceView.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKEntranceView.h"
#import "THKEntranceViewModel.h"
#import "THKEntranceViewCell.h"
#import "THKEntranceViewDetailCell.h"

@interface THKEntranceView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) THKEntranceViewModel *viewModel;


@end

@implementation THKEntranceView
@dynamic viewModel;
#pragma mark - Life Cycle
- (void)dealloc{
    NSLog(@"%@ did dealloc",self);
}

/// xib创建
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self didiniailze];
    }
    return self;
}

/// init or initWithFrame创建
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self didiniailze];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)didiniailze{
    
    [self addSubview:self.collectionView];
    
}



#pragma mark - Public
// initWithModel or bindViewModel: 方法来到这里
// MARK: 初始化,刷新数据和UI,xib,重新设置时调用
- (void)bindViewModel{
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([self itemWidth], collectionView.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.entranceList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.isFirstLevelEntrance) {
        THKEntranceViewDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKEntranceViewDetailCell class])
                                                                               forIndexPath:indexPath];
        
        NSString *entrance = self.viewModel.entranceList[indexPath.item];

    //    [cell.imageView loadImageWithUrlStr:entrance.imgUrl];
        cell.imageView.image = UIImageMake(@"diary_heart_fly");
        cell.titleLabel.text = entrance;
        cell.detailLabel.text = entrance;
        
        // 曝光
    //    [self entrancesShowReport:cell model:entrance indexPath:indexPath];
        
        return cell;
    }else{
        
        THKEntranceViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THKEntranceViewCell class])
                                                                              forIndexPath:indexPath];
        
        NSString *entrance = self.viewModel.entranceList[indexPath.item];
        
        //    [cell.imageView loadImageWithUrlStr:entrance.imgUrl];
        cell.imageView.image = UIImageMake(@"diary_heart_fly");
        cell.titleLabel.text = entrance;
        
        // 曝光
        //    [self entrancesShowReport:cell model:entrance indexPath:indexPath];
        
        return cell;
    }
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    !_tapItem?:_tapItem(indexPath);
//    THKDynamicGroupEntranceModel *entrance = self.viewModel.entranceList[indexPath.item];
//    TRouter *router = [TRouter routerFromUrl:entrance.targetUrl jumpController:nil];
//    [[TRouterManager sharedManager] performRouter:router];
    // 点击
//    [self entrancesClickReport:[collectionView cellForItemAtIndexPath:indexPath] model:entrance indexPath:indexPath];
}


#pragma mark - Private

- (CGFloat)itemWidth{
    CGFloat width = 0;
    NSInteger count = self.viewModel.entranceList.count;
    if (count) {
        CGFloat leftRightMargin = 30;
        width = (TMUI_SCREEN_WIDTH -  leftRightMargin - UIEdgeInsetsGetHorizontalValue(self.collectionView.contentInset) - (count - 1) * self.flowLayout.minimumLineSpacing) / count;
    }
    return width;
}


#pragma mark - Getter && Setter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        _collectionView.contentInset = UIEdgeInsetsMake(0, 11, 0, 11);
        [_collectionView registerClass:[THKEntranceViewCell class]
            forCellWithReuseIdentifier:NSStringFromClass([THKEntranceViewCell class])];
        [_collectionView registerClass:[THKEntranceViewDetailCell class]
            forCellWithReuseIdentifier:NSStringFromClass([THKEntranceViewDetailCell class])];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
    }
    
    return _flowLayout;
}




@end



@implementation THKEntranceView (Godeye)

TMUISynthesizeIdStrongProperty(geParas, setGeParas)

- (void)entrancesShowReport:(UICollectionViewCell *)view model:(id)model indexPath:(NSIndexPath *)indexPath{
//    GEWidgetResource *resource = [GEWidgetResource resourceWithWidget:view];
//    resource.geWidgetUid = @"cmp_first_entrance";
//    [resource addEntries:@{@"widget_index":@(indexPath.item),
//                          @"widget_href":model.targetUrl?:@"",
//                          @"widget_title":model.title?:@"",
//    }];
//    [resource addEntries:self.geParas];// 额外添加的字段
//    [[GEWidgetExposeEvent eventWithResource:resource] report];
}

- (void)entrancesClickReport:(UICollectionViewCell *)view model:(id)model indexPath:(NSIndexPath *)indexPath{
//    GEWidgetResource *resource = [GEWidgetResource resourceWithWidget:view];
//    resource.geWidgetUid = @"cmp_first_entrance";
//    [resource addEntries:@{@"widget_index":@(indexPath.item),
//                           @"widget_href":model.targetUrl?:@"",
//                           @"widget_title":model.title?:@"",
//    }];
//    [resource addEntries:self.geParas];// 额外添加的字段
//    [[GEWidgetClickEvent eventWithResource:resource] report];
}

@end
