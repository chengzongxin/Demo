//
//  THKReferenBigPictureVC.m
//  Demo
//
//  Created by Joe.cheng on 2023/7/6.
//

#import "THKReferenBigPictureVC.h"
#import "THKPushPopTransitionManager.h"

@interface THKReferenBigPictureVC ()

@property (nonatomic, strong, readwrite) THKReferenBigPictureVM *viewModel;

@property (nonatomic, strong, readwrite) UIImageView *coverImgView;

@end

@implementation THKReferenBigPictureVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorWhite;
    
    [self.view addSubview:self.coverImgView];
    
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.coverImgView loadImageWithUrlStr:@"https://test-pic.to8to.com/company/20220401/f232023c8cc7996ee47862020c5d548c.jpg"];
    
    [self configPushPopTransitionIfNeed];
}


- (void)configPushPopTransitionIfNeed {
    THKPushPopAsLocationToListTransition *transition = (THKPushPopAsLocationToListTransition*)(self.pushPopTransitionManager.pushPopTransition);
    if (transition && [transition isKindOfClass:[THKPushPopAsLocationToListTransition class]]) {
        @weakify(self);
        transition.getPushToSourceViewBlock = ^UIView * _Nullable{
            @strongify(self);
            return [self currentImageView];
        };
        
        transition.getPopFromSourceViewBlock = ^UIView * _Nullable{
            @strongify(self);
            return [self currentImageView];
        };
        
        transition.getPopFromSourceImageBlock = ^UIImage * _Nullable{
            @strongify(self);
            return [self currentImage];
        };
        
        //增加返回手势跟随交互支持
//        if ([self.navigationController.viewControllers count] > 2 ||
//            self.navigationController.tabBarController == nil) {
            //只有二级及子级vc push到详情页才加返回的手势跟随支持，从主tab页跳转的保留原侧滑返回手势逻辑(这里不加特殊手势即可)
            [self addPopGestureOfPercentDrivenInteractiveTransition];
            //增加返回手势是否应该处理返回逻辑的回调
            [self.pushPopTransitionManager setEnablePopGestureOfPercentDrivenInteractiveTransitionBlock:^BOOL{
                return YES;
            }];
//        }
    }
}

- (UIImageView *)currentImageView {
    return self.coverImgView;
}

- (UIImage *)currentImage {
    return self.coverImgView.image;
}


- (UIImageView *)coverImgView{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImgView;
}



@end
