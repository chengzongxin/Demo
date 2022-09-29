//
//  THKValuePointIntroductionVC.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/29.
//

#import "THKValuePointIntroductionVC.h"

@interface THKValuePointIntroductionVC ()

@property (nonatomic, strong) THKValuePointIntroductionVM *viewModel;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation THKValuePointIntroductionVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.thk_navBar.barStyle = TMUINavigationBarStyle_Dark;
    self.thk_navBar.backgroundColor = UIColorClear;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    self.scrollView.contentInset = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)bindViewModel{
    [super bindViewModel];
    
    CGFloat lastY = 0;
    for (int i = 0; i < self.viewModel.imgs.count; i++) {
        THKValuePointImg *img = self.viewModel.imgs[i];
        CGFloat h;
        if (img.height * img.width) {
            h = img.height/img.width*TMUI_SCREEN_WIDTH;
        }else{
            h = TMUI_SCREEN_WIDTH;
        }
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, lastY, TMUI_SCREEN_WIDTH, h)];
        [self.scrollView addSubview:imgV];
        [imgV loadImageWithUrlStr:img.imgUrl];
        
        lastY += h;
    }
    
    self.scrollView.contentSize = CGSizeMake(TMUI_SCREEN_WIDTH, lastY);
}



TMUI_PropertyLazyLoad(UIScrollView, scrollView);


@end
