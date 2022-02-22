//
//  THKNewcomerProcessVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/6.
//

#import "THKNewcomerProcessVC.h"
#import "THKNewcomerHomeView.h"
#import "THKNewcomerStageView.h"
#import "THKNewcomerHomeSelectStageView.h"
#import "THKNewcomerAnimation.h"
@interface THKNewcomerProcessVC ()

@property (nonatomic, strong, readwrite) THKNewcomerProcessVM *viewModel;

@property (nonatomic, strong) TMUIButton *skipBtn;

@end

@implementation THKNewcomerProcessVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.skipBtn];
    
    [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.equalTo(@24.0);
        make.top.equalTo(self.view.mas_top).offset(64);
    }];
}


// 在一个Window对象上展示
- (void)showInSomeRootVC:(UIViewController *)rootVC {
    
    [rootVC addChildViewController:self];
    [rootVC.view addSubview:self.view];
    [self didMoveToParentViewController:rootVC];
    self.navigationController.navigationBar.hidden = YES;
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootVC.view);
    }];
    
    [self firstStage];
        
//    [[GEPageViewProcessor defaultProcessor] addPageShowEvent:self];
}

- (void)firstStage{
    THKNewcomerHomeViewModel *homeVM = [[THKNewcomerHomeViewModel alloc] init];
    THKNewcomerHomeView *homeView = [[THKNewcomerHomeView alloc] initWithViewModel:homeVM];
    [self.view insertSubview:homeView belowSubview:self.skipBtn];
    [homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
    homeView.tapItem = ^(NSInteger idx, THKNewcomerHomeSelectStageCell * _Nonnull cell) {
        @strongify(self);
        [self secondStage:cell];
    };
//    homeView.animateView = ^(NSInteger idx, THKNewcomerHomeSelectStageCell * _Nonnull cell) {
//        @strongify(self);
//        [self secondStage:cell];
//    };
}

- (void)secondStage:(THKNewcomerHomeSelectStageCell *)cell{
    NSLog(@"%@",cell);
    
    THKNewcomerHomeSelectStageViewModel *stageVM = [[THKNewcomerHomeSelectStageViewModel alloc] init];
    THKNewcomerHomeSelectStageView *stageView = [[THKNewcomerHomeSelectStageView alloc] initWithViewModel:stageVM];
    [self.view insertSubview:stageView belowSubview:self.skipBtn];
    
    [stageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
//    [cell.titleLabel removeFromSuperview];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self finish];
//    });
}

- (void)skipBtnClick:(id)sender{
    NSLog(@"%@",sender);
    
    [self finish];
}


- (void)finish{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    !_dismissBlock?:_dismissBlock(@"");
}


#pragma mark - Lazy load
- (TMUIButton *)skipBtn{
    if (!_skipBtn) {
        _skipBtn = [[TMUIButton alloc] init];
        _skipBtn.tmui_text = @"跳过";
        _skipBtn.tmui_image = UIImageMake(@"newcomer_dec_arrow");
        _skipBtn.tmui_titleColor = [UIColor colorWithHexString:@"#4C4E4C"];
        _skipBtn.tmui_font = UIFontRegular(14.0);
        _skipBtn.imagePosition = TMUIButtonImagePositionRight;
        [_skipBtn tmui_addTarget:self action:@selector(skipBtnClick:)];
    }
    return _skipBtn;
}
@end
