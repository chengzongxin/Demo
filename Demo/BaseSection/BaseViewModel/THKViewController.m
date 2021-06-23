//
//  THKViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/12/14.
//

#import "THKViewController.h"

@interface THKViewController ()
// viewModel
@property (nonatomic, strong, readwrite) THKViewModel *viewModel;

@end

@implementation THKViewController


- (void)dealloc {
    NSLog(@"class=%@ dealloc", [self class]);
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    THKViewController *viewController = [super allocWithZone:zone];
    @weakify(viewController)
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    return viewController;
}

- (instancetype)initWithViewModel:(THKViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        [self thk_initialize];
    }
    return self;
}

- (void)bindViewModel {
    NSLog(@"super bindViewModel");
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self thk_initialize];
    }
    return self;
}

- (void)bindViewModel:(THKViewModel *)viewModel {
    self.viewModel = viewModel;
    [self thk_initialize];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self thk_initialize];
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"super viewdid load");
    self.view.clipsToBounds = YES;
//    self.view.backgroundColor = kDefaultBackGroundColor;// RGB_255(234, 234, 234);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self thk_addSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self thk_layoutNavigation];
    
    NSLog(@"class=%@ viewWillAppear",[self class]);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"class=%@ viewWillDisappear",[self class]);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
#ifdef __IPHONE_13_0
        if (@available(iOS 13.0, *)) {
            return UIStatusBarStyleDarkContent;
        } else {
            return UIStatusBarStyleDefault;
        }
#else
         return UIStatusBarStyleDefault;
#endif
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%@", [NSString stringWithFormat:@"key:%@,VC:%@",key,[self class]]);
}

#pragma mark - THKViewControllerProtocol

- (void)thk_initialize {}

- (void)thk_addSubviews {}

- (void)thk_layoutNavigation {}


//#ifdef DEBUG
//    #if __has_include("MLeaksFinder.h")
//- (BOOL)willDealloc {
//    if (![super willDealloc]) {
//        return NO;
//    }
//    if (_viewModel) {
//        MLCheck(self.viewModel);
//    }
//    return YES;
//}
//    #endif
//#endif

@end
