//
//  THKComboViewController.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/30.
//

#import "THKComboViewController.h"
#import "THKComboView.h"
@interface THKComboViewController ()
@property (nonatomic, strong) THKComboView *comboView;
@end

@implementation THKComboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    [self.view addSubview:view];
    self.view.backgroundColor = UIColor.whiteColor;
    
    THKComboView *comboView = [[THKComboView alloc] init];
    [self.view addSubview:comboView];
    [comboView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(50, 24));
        
    }];
    _comboView = comboView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [self.comboView combo];
    
}

@end
