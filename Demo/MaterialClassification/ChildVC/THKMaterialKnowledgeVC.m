//
//  THKMaterialKnowledgeVC.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/6/25.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKMaterialKnowledgeVC.h"
#import "THKMaterialKnowledgeVM.h"
#import "THKMaterialClassificationVC.h"

@interface THKMaterialKnowledgeVC ()

@property (nonatomic, strong) THKMaterialKnowledgeVM *viewModel;

@property (nonatomic, assign) BOOL needExposeVisibleCell;

@end

@implementation THKMaterialKnowledgeVC
@dynamic viewModel;
#pragma mark - Lifecycle 

// 初始化
- (void)thk_initialize{
//    self.gePageLevelPath = @"知识百科页";
//    self.gePageName = @"如何选材|主分类详情页|";
}

// 渲染VC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 子视图布局
- (void)thk_addSubviews{

}

// 绑定VM
- (void)bindViewModel {
    [self.viewModel bindWithView:self.view scrollView:self.scrollView appenBlock:^NSArray * _Nonnull(THKResponse * _Nonnull x) {
        THKMaterialRecommendKnowledgeResponse *response = (THKMaterialRecommendKnowledgeResponse *)x;
        return response.data;
    }];
    
    [self.viewModel addRefreshFooter];
    
    [self.viewModel.requestCommand execute:@1];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 修复埋点上报
    if (self.needExposeVisibleCell) {
        [self reloadData];
        self.needExposeVisibleCell = NO;
    }
}


#pragma mark - Public
- (void)childViewControllerBeginRefreshingWithPara:(NSDictionary *)para{
    NSLog(@"childvc %@",para);
    NSInteger subCategoryId = [para[@"categoryId"] integerValue];;
    NSString *categoryName = para[@"categoryName"];
    if (subCategoryId != self.viewModel.subCategoryId) {
        self.viewModel.subCategoryId = subCategoryId;
        self.viewModel.categoryName = categoryName;
        [self.viewModel.requestCommand execute:@1];
    }
}
#pragma mark - Event Respone

#pragma mark - Delegate
#pragma mark FlowDataSource

- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.data.count;
}

- (NSObject<TMCardComponentCellDataBasicProtocol> *)dataAtIndexPath:(NSIndexPath *)indexPath{
    return self.viewModel.data[indexPath.item];
}

#pragma mark  埋点相关

- (NSString *_Nullable)reportWidgetUidOfCellAtIndexPath:(NSIndexPath *)indexPath
                                                   data:(NSObject<TMCardComponentCellDataProtocol> * _Nonnull)data {
    
    THKMaterialClassificationVC *parentVC =  (THKMaterialClassificationVC *)self.parentViewController;
    if (![parentVC isKindOfClass:THKMaterialClassificationVC.class] || parentVC.childVCs[parentVC.currentIndex] != self) {
        // 页面展示才曝光,来到这里说明页面已经加载了数据，但是没有显示，需要在下次进入此页面，重新上报
        self.needExposeVisibleCell = YES;
        return nil;
    }
    
    return @"info_list";
}

- (NSDictionary *_Nullable)reportResourceOfCellAtIndexPath:(NSIndexPath *)indexPath
                                                      data:(NSObject<TMCardComponentCellDataProtocol> * _Nonnull)data {
    NSObject<TMCardComponentCellDataProtocol> *model = self.viewModel.data[indexPath.row];
    NSMutableDictionary *reportDict = [model.reportDicInfo mutableCopy];
    if (reportDict[@"widget_class"] == nil) {
        reportDict[@"widget_class"] = self.viewModel.categoryName?:@"";
    }
    return reportDict;
}

#pragma mark - Private

#pragma mark - Getters and Setters

#pragma mark - Supperclass

#pragma mark - NSObject

@end
