//
//  THKMaterialClassificationVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialClassificationVC.h"
#import "Table1ViewController.h"
#import "Table2ViewController.h"
#import "Table3ViewController.h"
#import "NormalViewController.h"
#import "THKMaterialClassificationView.h"
#import "THKMaterialClassificationViewModel.h"
#import "THKMaterialRecommendRankVC.h"
#import "THKMaterialRecommendRankVM.h"
#import "THKMaterialRecommendRankResponse.h"

@interface THKMaterialClassificationVC ()

@property (nonatomic, strong) THKMaterialClassificationViewModel *viewModel;

@property (nonatomic, strong) NSArray *vcs;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) THKMaterialClassificationView *headerView;

@end

@implementation THKMaterialClassificationVC
@dynamic viewModel;
#pragma mark - Lifecycle 

// 渲染VC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"家电";
    THKMaterialRecommendRankVC *vc1 = [[THKMaterialRecommendRankVC alloc] initWithViewModel:[THKMaterialRecommendRankVM new]];
    self.vcs = @[vc1,Table2ViewController.new,NormalViewController.new];
    self.titles = @[@"推荐榜单",@"好物种草",@"知识百科"];
    
    @weakify(self);
    [self.viewModel.requestCMD.nextSignal subscribeNext:^(THKMaterialRecommendRankResponse *x) {
        @strongify(self);
        self.headerView.subCategoryList = x.data.subCategoryList;
    }];
    
    [self.viewModel.requestCMD.errorSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [TMEmptyView showEmptyInView:self.view contentType:TMEmptyContentTypeNetErr];
    }];
    
    [self.viewModel.requestCMD execute:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reloadData];
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
}

- (CGFloat)heightForHeader{
    return self.headerView.height;
}

- (UIView *)viewForHeader{
    [self.headerView bindViewModel:THKMaterialClassificationViewModel.new];
    return self.headerView;
}


#pragma mark - Public

#pragma mark - Event Respone
- (void)tapClassification:(NSInteger)index{
    NSInteger categoryId = self.headerView.subCategoryList[index].categoryId;
    NSString *categoryName = self.headerView.subCategoryList[index].categoryName;
    [self childVCsBeginRefreshWithPara:@{@"categoryId":@(categoryId),@"categoryName":categoryName?:@""} forceAll:NO];
}

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Getters and Setters
- (THKMaterialClassificationView *)headerView{
    if (!_headerView) {
        _headerView = [[THKMaterialClassificationView alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, CGCustomFont(116))];
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

@end
