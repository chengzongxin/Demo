//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "THKIdentityView.h"
#import "THKAvatarView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"list" style:UIBarButtonItemStylePlain target:self action:@selector(list)];
    
    THKIdentityViewModel *vm0 = [[THKIdentityViewModel alloc] initWithType:10 subType:0 style:THKIdentityStyle_IconText];
    THKIdentityView *v0 = [[THKIdentityView alloc] initWithViewModel:vm0];
    [self.view addSubview:v0];

    THKIdentityViewModel *vm1 = [[THKIdentityViewModel alloc] initWithType:11 subType:0 style:THKIdentityStyle_IconText];
    THKIdentityView *v1 = [[THKIdentityView alloc] initWithViewModel:vm1];
    [self.view addSubview:v1];

    THKIdentityViewModel *vm2 = [[THKIdentityViewModel alloc] initWithType:11 subType:1 style:THKIdentityStyle_IconText];
    THKIdentityView *v2 = [[THKIdentityView alloc] initWithViewModel:vm2];
    [self.view addSubview:v2];

    THKIdentityViewModel *vm3 = [[THKIdentityViewModel alloc] initWithType:12 subType:0 style:THKIdentityStyle_IconText];
    THKIdentityView *v3 = [[THKIdentityView alloc] initWithViewModel:vm3];
    [self.view addSubview:v3];

    THKIdentityViewModel *vm4 = [[THKIdentityViewModel alloc] initWithType:13 subType:0 style:THKIdentityStyle_IconText];
    THKIdentityView *v4 = [[THKIdentityView alloc] initWithViewModel:vm4];
    [self.view addSubview:v4];

    THKIdentityViewModel *vm5 = [[THKIdentityViewModel alloc] initWithType:14 subType:0 style:THKIdentityStyle_IconText];
    THKIdentityView *v5 = [[THKIdentityView alloc] initWithViewModel:vm5];
    [self.view addSubview:v5];

    THKIdentityViewModel *vm6 = [[THKIdentityViewModel alloc] initWithType:999 subType:0 style:THKIdentityStyle_IconText];
    THKIdentityView *v6 = [[THKIdentityView alloc] initWithViewModel:vm6];
    [self.view addSubview:v6];

    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(100);
    }];

    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v0.mas_right).offset(20);
        make.top.mas_equalTo(100);
    }];

    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1.mas_right).offset(20);
        make.top.mas_equalTo(100);
    }];

    [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v2.mas_right).offset(20);
        make.top.mas_equalTo(100);
    }];

    [v4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(v3.mas_bottom).offset(50);
    }];

    [v5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v4.mas_right).offset(20);
        make.top.equalTo(v0.mas_bottom).offset(50);
    }];

    [v6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v5.mas_right).offset(20);
        make.top.equalTo(v0.mas_bottom).offset(50);
    }];


    [vm0.onTapSubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];

    THKAvatarViewModel *vm7 = [[THKAvatarViewModel alloc] initWithAvatarUrl:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2458338947,591929039&fm=26&gp=0.jpg" identityType:11];
    THKAvatarView *a7 = [[THKAvatarView alloc] init];
    [a7 bindViewModel:vm7];
    [self.view addSubview:a7];
    [a7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(300);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];

    [vm7.onTapSubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"vm7 %@",x);
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"3 second ====================");
//        [v0 bindViewModel:[[THKIdentityViewModel alloc] initWithType:12 subType:0 style:THKIdentityStyle_IconText]];
//        [v1 bindViewModel:[[THKIdentityViewModel alloc] initWithType:14 subType:0 style:THKIdentityStyle_IconText]];
//        [v2 bindViewModel:[[THKIdentityViewModel alloc] initWithType:133 subType:0 style:THKIdentityStyle_IconText]];
//        [v3 bindViewModel:[[THKIdentityViewModel alloc] initWithType:12 subType:0 style:THKIdentityStyle_IconText]];
//        [v4 bindViewModel:[[THKIdentityViewModel alloc] initWithType:11 subType:1 style:THKIdentityStyle_IconText]];
//        [v5 bindViewModel:[[THKIdentityViewModel alloc] initWithType:11 subType:0 style:THKIdentityStyle_IconText]];
//        [v6 bindViewModel:[[THKIdentityViewModel alloc] initWithType:10 subType:0 style:THKIdentityStyle_IconText]];
//        THKAvatarViewModel *vm7_1 = [[THKAvatarViewModel alloc] initWithAvatarUrl:@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3927348840,3579255094&fm=11&gp=0.jpg" identityType:10];
//        [a7 bindViewModel:vm7_1];
//        [vm7_1.onTapSubject subscribeNext:^(id  _Nullable x) {
//            NSLog(@"vm7_1 %@",x);
//        }];
//    });
    
//    THKAvatarViewModel *vm8 = [[THKAvatarViewModel alloc] initWithAvatarUrl:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2458338947,591929039&fm=26&gp=0.jpg" identityType:11];
//    THKAvatarView *a8 = [[THKAvatarView alloc] initWithFrame:CGRectMake(100, 500, 30, 30)];
//    [a8 bindViewModel:vm8];
//    [self.view addSubview:a8];
    
    
//    THKIdentityView *i7 = [THKIdentityView identityViewWithType:10 style:THKIdentityViewStyle_Icon];
//
//    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"11611657654_.pic"]];
//    imgV.layer.cornerRadius = 25;
//    //    imgV.layer.masksToBounds = YES;
//    [self.view addSubview:imgV];
//    [vmgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(100);
//        make.top.mas_equalTo(300);
//        make.width.mas_equalTo(100);
//        make.height.mas_equalTo(100);
//    }];
//    imgV.userInteractionEnabled = YES;
//    [vmgV addSubview:i7];
//
//    [v7 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-10);
//        make.bottom.mas_equalTo(-10);
//        make.width.mas_equalTo(20);
//        make.height.mas_equalTo(20);
//    }];
//
//    THKIdentityView *i8 = [THKIdentityView identityViewWithType:12 style:THKIdentityViewStyle_Full];
//    THKIdentityView *i9 = [THKIdentityView identityViewWithType:13 style:THKIdentityViewStyle_Icon];
//    i8.frame = CGRectMake(100, 500, 100, 50);
//    i9.frame = CGRectMake(100, 600, 50, 50);
//    [self.view addSubview:i8];
//    [self.view addSubview:i9];
//
//    [self.view layoutIfNeeded];
    NSLog(@"%@,%@",NSStringFromCGSize(v1.frame.size),NSStringFromCGSize(v1.viewSize));
    NSLog(@"%@,%@",NSStringFromCGSize(v2.frame.size),NSStringFromCGSize(v2.viewSize));
    NSLog(@"%@,%@",NSStringFromCGSize(v3.frame.size),NSStringFromCGSize(v3.viewSize));
    NSLog(@"%@,%@",NSStringFromCGSize(v4.frame.size),NSStringFromCGSize(v4.viewSize));
    NSLog(@"%@,%@",NSStringFromCGSize(v5.frame.size),NSStringFromCGSize(v5.viewSize));
    NSLog(@"%@,%@",NSStringFromCGSize(v6.frame.size),NSStringFromCGSize(v6.viewSize));
    NSLog(@"%@,%@",NSStringFromCGSize(a7.frame.size),NSStringFromCGSize(a7.identityView.viewSize));
//    NSLog(@"%@,%@",NSStringFromCGSize(v8.frame.size),NSStringFromCGSize(v8.viewSize));
//    NSLog(@"%@,%@",NSStringFromCGSize(v9.frame.size),NSStringFromCGSize(v9.viewSize));
////
//    THKIdentityView *i10 = [THKIdentityView identityViewWithType:0 style:THKIdentityViewStyle_Full];
//    [self.view addSubview:i10];
//    [v10 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(20);
//        make.top.equalTo(v6.mas_bottom).offset(50);
//    }];
//
//    UILabel *label = [[UILabel alloc] init];
//    [self.view addSubview:label];
//
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(v10.mas_right).offset(20);
//        make.top.equalTo(v10);
//    }];
//
//    label.text = @"hhdsahdas";
//
//
//    THKIdentityView *i11 = [THKIdentityView identityViewWithType:0 style:THKIdentityViewStyle_Icon];
//    [self.view addSubview:i11];
//    [v11 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(50);
//        make.top.mas_equalTo(v10.mas_bottom).offset(10);
//        make.width.mas_equalTo(10);
//        make.height.mas_equalTo(10);
//    }];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (vnt64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [v10 setType:10 subType:0];
//        [v11 setType:12 subType:0];
////        label.text = @"hhdsahdas";
//    });
}

- (void)test{
    
    
//    THKIdentityView *view1 = [[THKIdentityView alloc] initWithType:1 style:THKIdentityViewStyle_Full];
//    view1.iconOffset = CGPointMake(0, 0);
//    [self.view addSubview:view1];
//
//    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.mas_equalTo(100);
////        make.size.mas_equalTo(CGSizeMake(50, 50));
//    }];
//
//    THKIdentityView *view2 = [[THKIdentityView alloc] initWithType:2 style:THKIdentityViewStyle_Full];
////    view2.iconOffset = CGPointMake(10, 10);
//    [self.view addSubview:view2];
//
//
//    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(100);
//        make.top.equalTo(view1.mas_bottom).offset(50);
//    }];
//
//    THKIdentityView *view4 = [THKIdentityView identityViewWithType:3 style:THKIdentityViewStyle_Full];
//    [self.view addSubview:view4];
//
//    [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view1.mas_right).offset(20);
//        make.top.equalTo(view1);
//    }];
//
//    THKIdentityView *view5 = [THKIdentityView identityViewWithType:4 style:THKIdentityViewStyle_Full];
//    [self.view addSubview:view5];
//
//    [view5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view4.mas_right).offset(20);
//        make.top.equalTo(view4);
//    }];
//
//
//
//    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"11611657654_.pic"]];
//    imgV.layer.cornerRadius = 25;
////    imgV.layer.masksToBounds = YES;
//    [self.view addSubview:imgV];
//    [vmgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(100);
//        make.top.equalTo(view2.mas_bottom).offset(50);
//        make.width.mas_equalTo(50);
//        make.height.mas_equalTo(50);
//    }];
//    imgV.userInteractionEnabled = YES;
//    THKIdentityView *view3 = [THKIdentityView identityViewWithType:0 style:THKIdentityViewStyle_Icon];
//    view3.iconOffset = CGPointMake(-10, -10);
//    [vmgV addSubview:view3];
//
//
//    view1.tapBlock = ^(NSInteger type) {
//        NSLog(@"tap block");
//    };
//
//    view2.tapBlock = ^(NSInteger type) {
//        NSLog(@"tap block");
//    };
//
//    view3.tapBlock = ^(NSInteger type) {
//        NSLog(@"tap block");
//    };
//
//
//    _view1 = view1;
//    _view2 = view2;
//    _view3 = view3;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    if (_view1.type == THKAuthenticationType_3) {
//        _view1.type = THKAuthenticationType_0;
//        _view2.type = THKAuthenticationType_0;
//    }else{
//        _view1.type++;
//        _view2.type++;
//    }
    
//    _view1.iconOffset = CGPointMake(_view1.iconOffset.x+1, _view1.iconOffset.y+1);
//    _view2.iconOffset = CGPointMake(_view2.iconOffset.x+1, _view2.iconOffset.y+1);
//    _view3.iconOffset = CGPointMake(_view3.iconOffset.x+1, _view3.iconOffset.y+1);
//
//    [_xib1 setType:11];
//    [_xib2 setType:12];
}

@end
