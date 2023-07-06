//
//  THKModalPresentVC.m
//  Demo
//
//  Created by Joe.cheng on 2023/7/6.
//

#import "THKModalPresentVC.h"
#import "BTCoverVerticalTransition.h"

@interface THKModalPresentVC ()

@property (nonatomic, strong) BTCoverVerticalTransition *aniamtion;

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation THKModalPresentVC

- (instancetype)init{
    self = [super init];
    if (self) {
        self.aniamtion = [[BTCoverVerticalTransition alloc] initPresentViewController:self withRragDismissEnabal:YES];
        @weakify(self);
        _aniamtion.dismissBlock = ^{
            @strongify(self);
            if (self.backBlock) {
                self.backBlock();
            }
        };
//        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self.aniamtion;
    }
    return self;
}


// 渲染VC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, self.viewHeight);
    [self.view tmui_cornerDirect:UIRectCornerTopLeft|UIRectCornerTopRight radius:12];
    
    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
}

#pragma mark - Event Respone

- (void)clickCloseBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
    !_backBlock?:_backBlock();
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton tmui_button];
        _closeBtn.tmui_image = UIImageMake(@"diary_book_close_icon");
        [_closeBtn tmui_addTarget:self action:@selector(clickCloseBtn)];
    }
    return _closeBtn;
}

@end
