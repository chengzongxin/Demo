//
//  THKNewcomerProcessVC.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/6.
//

#import "THKNewcomerProcessVC.h"
#import "THKNewcomerHomeView.h"
#import "THKNewcomerStageView.h"

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
    [self.view addSubview:homeView];
    [homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
    [homeVM.skipSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self finish];
    }];
    
    homeView.tapItem = ^(NSInteger idx, UILabel * _Nonnull label) {
        @strongify(self);
        [self secondStage:label];
    };
}

- (void)secondStage:(UILabel *)label{
    NSLog(@"%@",label);
    [self finish];
}

- (void)skipBtnClick:(id)sender{
//    [self.viewModel.skipSignal sendNext:sender];
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
        _skipBtn.layer.zPosition = 999;
    }
    return _skipBtn;
}
@end
