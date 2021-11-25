//
//  THKSelectMaterialCommunicationVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/24.
//

#import "THKSelectMaterialCommunicationVC.h"
#import "THKSelectMaterialCommunicationCell.h"
static NSString * const kCellIdentifier = @"kSelectMaterialCommunicationCell";

@interface THKSelectMaterialCommunicationVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) THKSelectMaterialCommunicationVM *viewModel;

@property(nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) int page;

@end

@implementation THKSelectMaterialCommunicationVC


@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}


// 绑定VM
- (void)bindViewModel {
    [self.viewModel bindWithView:self.view scrollView:self.tableView appenBlock:^NSArray * _Nonnull(THKResponse * _Nonnull x) {
        THKMaterialV3CommunicateListResponse *response = (THKMaterialV3CommunicateListResponse *)x;
        return response.data;
    }];
    
    [self.viewModel.labelRequest.nextSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    [self.viewModel addRefreshHeader];
    [self.viewModel addRefreshFooter];
    
    [self.viewModel.requestCommand execute:@1];
    [self.viewModel.labelRequest execute:nil];
}


#pragma mark - <UITableViewDataSource, UITableViewDelegate>

// 以内容的长度作为key缓存高度
- (id<NSCopying>)cachedKeyAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
    return key;// 这里简单处理，认为只要长度不同，高度就不同（但实际情况下长度就算相同，高度也有可能不同，要注意）
}

#pragma mark - <TMUITableViewDelegate, TMUITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.data.count;
}

// 计算cell尺寸的时候需要
- (UITableViewCell *)tmui_tableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:kCellIdentifier]) {
        THKSelectMaterialCommunicationCell *cell = (THKSelectMaterialCommunicationCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[THKSelectMaterialCommunicationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        }
        cell.separatorInset = UIEdgeInsetsZero;
        return cell;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THKSelectMaterialCommunicationCell *cell = (THKSelectMaterialCommunicationCell *)[self tmui_tableView:tableView cellWithIdentifier:kCellIdentifier];
//    THKSelectMaterialCommunicationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKSelectMaterialCommunicationCell.class) forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsZero;
    THKSelectMaterialCommunicationCellVM *cellVM = [[THKSelectMaterialCommunicationCellVM alloc] initWithModel:self.viewModel.data[indexPath.row]];
    [cell bindViewModel:cellVM];
    
//    @weakify(self,cell,indexPath);
//    // 点击头像
//    [cellVM.clickAvatarSignal subscribeNext:^(THKSelectMaterialCommunicationCellVM *x) {
//        @strongify(self,cell,indexPath);
//        [self pushWithRouter:x.model.userInfo.routeUrl];
//        [self cellAvatarClickReport:cell index:indexPath];
//    }];
//    // 点击展开
//    [cellVM.clickUnfoldSignal subscribeNext:^(id  _Nullable x) {
//        @strongify(self,cell,indexPath);
//        [self unfoldCell:indexPath];
//        [self cellUnfoldClickReport:cell index:indexPath];
//    }];
//    // 点击日记本链接
//    [cellVM.clickDiarySignal subscribeNext:^(THKSelectMaterialCommunicationCellVM *x) {
//        @strongify(self,cell,indexPath);
//        [self pushWithRouter:x.model.bookInfo.routeUrl];
//        [self cellDiaryLinkClickReport:cell index:indexPath];
//    }];
//    // 点击图片
//    [cellVM.clickImagesSignal subscribeNext:^(id  _Nullable x) {
//        @strongify(self,cell,indexPath);
//        RACTupleUnpack(NSNumber *index,THKSelectMaterialCommunicationCellVM *vm) = x;
//        [self pushImages:index.integerValue viewModel:vm cell:cell];
//        [self cellImagesClickReport:cell index:indexPath imageIndex:index.integerValue];
//    }];
//    // 点击装修公司
//    [cellVM.clickCompanySignal subscribeNext:^(THKSelectMaterialCommunicationCellVM *x) {
//        @strongify(self,cell,indexPath);
//        [self pushWithRouter:x.model.companyInfo.routeUrl];
//        [self cellCompanyClickReport:cell index:indexPath];
//    }];
//    // 点击装修清单
//    [cellVM.clickShoppingListSignal subscribeNext:^(THKSelectMaterialCommunicationCellVM *x) {
//        @strongify(self,cell,indexPath);
//        [self pushDiaryDetailVC:x.model.bookInfo.id diaryId:x.model.diaryInfo.id isClickShoppingList:YES];
//    }];
//
//    // 预加载3张图后面的缩略图到缓存，后续点击查看大图使用，提升体验
//    [self preLoadImage:cellVM];
//
//    if (!cellVM.model.isExpose) {
//        [self cellShowReport:cell tableView:tableView indexPath:indexPath];
//        cellVM.model.isExpose = YES;
//    }
    
    return cell;
}


// 一般的做法是，提供一个类方法，获取model的高度，这个方案是三种缓存形式，1，不缓存，2依据indexPath缓存，3依据key缓存
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<NSCopying> cachedKey = [self cachedKeyAtIndexPath:indexPath];
    // 3.依据key缓存，适用于会动态改变高度的cell，cacheKey可以根据改变的内容做hash或者长度运算
    @weakify(self);
    return [tableView tmui_heightForCellWithIdentifier:kCellIdentifier cacheByKey:cachedKey configuration:^(THKSelectMaterialCommunicationCell *cell) {
        @strongify(self);
        // block 内部代码需要和cellForRow一样，目的是为cell渲染出内容，为下一步动态计算高度做准备
        THKSelectMaterialCommunicationCellVM *cellVM = [[THKSelectMaterialCommunicationCellVM alloc] initWithModel:self.viewModel.data[indexPath.row]];
        [cell bindViewModel:cellVM];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    THKSelectMaterialCommunicationCellVM *cellVM = [[THKSelectMaterialCommunicationCellVM alloc] initWithModel:self.viewModel.data[indexPath.row]];
//    [self pushDiaryDetailVC:cellVM.model.bookInfo.id diaryId:cellVM.model.diaryInfo.id];
}

#pragma mark - Private

#pragma mark - Getters and Setters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:UIScreen.mainScreen.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorColor = UIColorHex(#EBECF5);
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.tableFooterView = UIView.new;
        [_tableView tmui_registerCellWithClass:THKSelectMaterialCommunicationCell.class];
    }
    return _tableView;
}





+ (BOOL)canHandleRouter:(TRouter *)router{
    if ([router routerMatch:THKRouterPage_MaterialHomeTabCommunication]) {
        return YES;
    }
    return NO;
}

+ (id)createVCWithRouter:(TRouter *)router{
    THKSelectMaterialCommunicationVM *selectMaterialVM = [[THKSelectMaterialCommunicationVM alloc] init];
    selectMaterialVM.categoryId = [[router.param safeObjectForKey:@"categoryId"] integerValue];
    return [[self alloc] initWithViewModel:selectMaterialVM];
}

@end
