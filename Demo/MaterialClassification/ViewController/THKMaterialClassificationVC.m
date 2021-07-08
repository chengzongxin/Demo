//
//  THKMaterialClassificationVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialClassificationVC.h"
#import "THKMaterialGoodsGrassVC.h"
#import "THKMaterialGoodsGrassVM.h"
#import "THKMaterialKnowledgeVC.h"
#import "THKMaterialKnowledgeVM.h"
#import "THKMaterialClassificationHeaderView.h"
#import "THKMaterialClassificationVM.h"
#import "THKMaterialRecommendRankVC.h"
#import "THKMaterialRecommendRankVM.h"
#import "THKMaterialRecommendRankResponse.h"
#import "GECommonEventTracker.h"

/// 埋点分类
@interface THKMaterialClassificationVC (Godeye)
/// 曝光记录
@property (nonatomic, strong) NSMutableArray <NSNumber *> *tagExposeArray;
/// 页面周期
- (void)appPageCycleReport;
/// tab曝光点击
- (void)tabControlReport:(THKSegmentControl *)control;

@end


@interface THKMaterialClassificationVC ()

@property (nonatomic, strong) THKMaterialClassificationVM *viewModel;

@property (nonatomic, strong) NSArray *vcs;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) THKMaterialClassificationHeaderView *headerView;

@end

@implementation THKMaterialClassificationVC
@dynamic viewModel;
#pragma mark - Lifecycle 

// 渲染VC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thk_hideNavShadowImageView];
    
    [self appPageCycleReport];
    
    THKMaterialRecommendRankVC *vc1 = [[THKMaterialRecommendRankVC alloc] initWithViewModel:[THKMaterialRecommendRankVM new]];
    THKMaterialGoodsGrassVC *vc2 = [[THKMaterialGoodsGrassVC alloc] initWithViewModel:[THKMaterialGoodsGrassVM new]];
    THKMaterialKnowledgeVC *vc3 = [[THKMaterialKnowledgeVC alloc] initWithViewModel:[THKMaterialKnowledgeVM new]];
    
    self.vcs = @[vc1,vc2,vc3];
    self.titles = @[@"推荐榜单",@"好物种草",@"知识百科"];
    
    [self reloadData];
    
    @weakify(self);
    // 请求回调
    [self.viewModel.requestCMD.nextSignal subscribeNext:^(THKMaterialRecommendRankResponse *x) {
        @strongify(self);
        [self.view.tmui_emptyView remove];
        
        if (x.status != THKStatusSuccess) {
            [TMEmptyView showEmptyInView:self.view contentType:TMEmptyContentTypeServerErr clickBlock:^{
                @strongify(self);
                [self.viewModel.requestCMD execute:nil];
            }];
        }else if (x.data.subCategoryList.count) {
            // 刷新header
            self.headerView.subCategoryId = self.viewModel.subCategoryId;
            self.headerView.subCategoryList = x.data.subCategoryList;
        }else{
            [TMEmptyView showEmptyInView:self.view contentType:TMEmptyContentTypeNoData];
        }
    }];
    
    [self.viewModel.requestCMD.errorSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [TMEmptyView showEmptyInView:self.view contentType:TMEmptyContentTypeNetErr clickBlock:^{
            @strongify(self);
            [self.viewModel.requestCMD execute:nil];
        }];
    }];
    
    [self.viewModel.requestCMD execute:nil];
}

- (NSArray<__kindof UIViewController *> *)viewControllersForChildViewControllers{
    return self.vcs;
}

- (NSArray<NSString *> *)titlesForChildViewControllers{
    return self.titles;
}

- (void)segmentControlConfig:(THKSegmentControl *)control{
    control.indicatorView.layer.cornerRadius = 0.0;
    control.indicatorView.backgroundColor = UIColorHex(29D181);
    control.indicatorView.height = 5;
    control.indicatorView.width = 14;
    [control setTitleFont:[UIFont systemFontOfSize:16] forState:UIControlStateNormal];
    [control setTitleFont:[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold] forState:UIControlStateSelected];
    [control setTitleColor:UIColorHex(#666666) forState:UIControlStateNormal];
    [control setTitleColor:UIColorHex(#333333) forState:UIControlStateSelected];
    control.height = 54;
    
    [self tabControlReport:control];
}

- (CGFloat)heightForHeader{
    return self.headerView.height;
}

- (UIView *)viewForHeader{
    return self.headerView;
}


#pragma mark - Public

#pragma mark - Event Respone
- (void)tapClassification:(NSInteger)index{
    self.title = self.headerView.subCategoryList[index].mainCategoryName;
    // 刷新子VC
    NSInteger categoryId = self.headerView.subCategoryList[index].categoryId;
    NSString *categoryName = self.headerView.subCategoryList[index].categoryName;
    // 已加载的刷新VC
    [self childVCsBeginRefreshWithPara:@{@"categoryId":@(categoryId),@"categoryName":categoryName?:@""} forceAll:YES];
    // 未加载更新VM
    [self setChildVCViewModelCategoryId:categoryId categoryName:categoryName];
}

#pragma mark - Delegate

#pragma mark - Private
// 当子vc未加载的时候，切换分类，需要设置子vc的viewModel，以便在显示的时候刷新UI
- (void)setChildVCViewModelCategoryId:(NSInteger)categoryId categoryName:(NSString *)categoryName{
    [self.childVCs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isViewLoaded] == NO) {
            THKViewController *thkVC = (THKViewController *)obj;
            if ([obj isKindOfClass:THKMaterialRecommendRankVC.class]) {
                THKMaterialRecommendRankVM *vm = (THKMaterialRecommendRankVM *)thkVC.viewModel;
                vm.subCategoryId = categoryId;
                vm.categoryName = categoryName;
            }else if ([obj isKindOfClass:THKMaterialGoodsGrassVC.class]) {
                THKMaterialGoodsGrassVM *vm = (THKMaterialGoodsGrassVM *)thkVC.viewModel;
                vm.subCategoryId = categoryId;
                vm.categoryName = categoryName;
            }else if ([obj isKindOfClass:THKMaterialKnowledgeVC.class]) {
                THKMaterialKnowledgeVM *vm = (THKMaterialKnowledgeVM *)thkVC.viewModel;
                vm.subCategoryId = categoryId;
                vm.categoryName = categoryName;
            }
        }
    }];
}

#pragma mark - Getters and Setters
- (THKMaterialClassificationHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[THKMaterialClassificationHeaderView alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, CGCustomFont(116))];
        @TMUI_weakify(self);
        _headerView.tapItem = ^(NSInteger index) {
            @TMUI_strongify(self);
            [self tapClassification:index];
        };
    }
    return _headerView;
}

#pragma mark - Supperclass

#pragma mark - NSObject

#pragma mark - Router

+ (BOOL)canHandleRouter:(TRouter *)router {
    if ([router routerMatch:THKRouterPage_SelectMaterialCategoryDetail]) {
        return YES;
    }
    return NO;
}

+ (id)createVCWithRouter:(TRouter *)router {
    NSInteger mainCategoryId = [[router.param safeStringForKey:@"mainCategoryId"] integerValue];
    NSInteger subCategoryId = [[router.param safeStringForKey:@"subCategoryId"] integerValue];
    THKMaterialClassificationVM *vm = [[THKMaterialClassificationVM alloc] init];
    vm.mainCategoryId = mainCategoryId;
    vm.subCategoryId = subCategoryId;
    THKMaterialClassificationVC *vc = [[THKMaterialClassificationVC alloc] initWithViewModel:vm];
    return vc;
}

@end


@implementation THKMaterialClassificationVC (Godeye)

/// 埋点 appPageCycle
- (void)appPageCycleReport{
    self.gePageNotDisplay = YES;//is_show = 0
    self.gePageLevelPath = @"如何选材|主分类详情页|";
    self.gePageName = @"推荐榜单页";
}

/// tab 曝光，点击
- (void)tabControlReport:(THKSegmentControl *)control{
    self.tagExposeArray = @[].mutableCopy;
    @weakify(self);
    [self.childTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [self.tagExposeArray addObject:@0];
    }];
    
    control.itemClickBlock = ^(UIButton *button, NSInteger index) {
        @strongify(self);
        [self reportEvent:kGEAppWidgetClick button:button index:index];
    };
    control.itemExposeBlock = ^(UIButton *button, NSInteger index) {
        @strongify(self);
        BOOL exposed = [[self.tagExposeArray safeObjectAtIndex:index] boolValue];
        if (!exposed) {
            [self reportEvent:kGEAppWidgetShow button:button index:index];
            [self.tagExposeArray replaceObjectAtIndex:index withObject:@1];
        }
    };
    
}

/// tab曝光、点击
- (void)reportEvent:(NSString *)event button:(UIButton *)button index:(NSInteger)index
{
    [GECommonEventTracker reportEvent:event properties:({
        NSMutableDictionary *mDict = @{}.mutableCopy;
        mDict[@"page_uid"] = self.gePageUid?:@"";
        mDict[@"widget_title"] = button.titleLabel.text?:@"";
        mDict[@"widget_uid"] = @"tab_btn";
        mDict[@"widget_index"] = @(index).description;
        mDict[@"page_refer_uid"] = self.gePageReferUid?:@"";
        mDict;
    })];
}

TMUISynthesizeIdStrongProperty(tagExposeArray, setTagExposeArray);

@end
