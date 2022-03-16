//
//  TDSearchViewController.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/9.
//

#import "TDSearchViewController.h"
#import "THKNavigationBar.h"
#import "TMUISearchView.h"
#import "TMUISearchBar.h"


#define invoke(method) \
SEL selector = NSSelectorFromString(method); \
IMP imp = [self methodForSelector:selector]; \
void (*func)(id, SEL) = (void *)imp; \
func(self, selector);

@interface TDSearchViewController ()

@property (nonatomic, strong) THKNavigationBar *navBar;

@end

@implementation TDSearchViewController

- (void)action{
    UIEdgeInsets paddings = UIEdgeInsetsMake(24 + NavigationContentTop, 24 + self.view.tmui_safeAreaInsets.left, 24 +  self.view.tmui_safeAreaInsets.bottom, 24 + self.view.tmui_safeAreaInsets.right);
    
    TMUIFloatLayoutView *layoutView = [[TMUIFloatLayoutView alloc] tmui_initWithSize:TMUIFloatLayoutViewAutomaticalMaximumItemSize];
    layoutView.itemMargins = UIEdgeInsetsMake(0, 0, 8, 8);
    
    NSArray *btns = @[@"显示/隐藏左边",@"显示/隐藏右边"];
    
    [btns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TMUIButton *btn = [TMUIButton tmui_button];
        btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        btn.cornerRadius = 8;
        btn.tmui_text = obj;
        btn.tmui_titleColor = UIColorWhite;
        btn.backgroundColor = UIColor.tmui_randomColor;
        btn.tag = idx;
        [btn tmui_addTarget:self action:@selector(btnClick:)];
        [layoutView addSubview:btn];
    }];
    
    layoutView.frame = CGRectMake(paddings.left, paddings.top, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(paddings), TMUIViewSelfSizingHeight);
    
    [self.view addSubview:layoutView];
}

- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 0) {
        _navBar.isBackButtonHidden = !_navBar.isBackButtonHidden;
    }else if (btn.tag == 1) {
        _navBar.isRightButtonHidden = !_navBar.isRightButtonHidden;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navBarHidden = YES;
    _navBar = [[THKNavigationBar alloc] init];
    [self.view addSubview:_navBar];
    
    [self action];
    
    NSString *method = [NSString stringWithFormat:@"style%zd",_style];
    invoke(method)
}


/// 滚动搜索
- (void)style0{
    TMUISearchView *search = [[TMUISearchView alloc] init];
    [search setHotwords:@[@"123",@"456"]];
    
    _navBar.titleView = search;
}


/// 常用搜索
- (void)style1{
    TMUISearchBar *search = [[TMUISearchBar alloc] init];
    
    _navBar.titleView = search;
}


/// 城市搜索
- (void)style2{
    TMUISearchBar *search = [[TMUISearchBar alloc] initWithStyle:TMUISearchBarStyle_City];
    
    _navBar.titleView = search;
}

@end
