//
//  ViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "ViewController.h"
#import "THKCompanyDetailBannerView.h"
#import "TDecDetailFirstModel.h"

@interface ViewController ()
@property (nonatomic, strong) TDecDetailFirstModel *model;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path = [NSBundle.mainBundle pathForResource:@"data.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *str = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    TDecDetailFirstModel *model = [TDecDetailFirstModel mj_objectWithKeyValues:str];
    _model = model;
    
    THKCompanyDetailBannerViewModel *bannerVM = [[THKCompanyDetailBannerViewModel alloc] initWithModel:model];
    THKCompanyDetailBannerView *banner = [[THKCompanyDetailBannerView alloc] init];
    [banner bindViewModel:bannerVM];
    [self.view addSubview:banner];
    
    [banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 300));
    }];
}


@end
