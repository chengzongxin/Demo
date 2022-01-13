//
//  THKExpandLabelViewController.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/27.
//

#import "THKExpandLabelViewController.h"
#import "THKExpandLabel.h"
#import "TMUIExpandLabel.h"
//#import "UILabel+Expand.h"
@interface THKExpandLabelViewController ()

@property (nonatomic, strong) UIView *debugView;
@end

@implementation THKExpandLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(@"white");
    
    
    self.debugView = [UIView new];
    [self.view addSubview:self.debugView];
    self.debugView.backgroundColor = [UIColor.tmui_randomColor colorWithAlphaComponent:0.3];
//    [self test2];
    
    [self test3];
}

- (void)test3{
    TMUIExpandLabel *label = [[TMUIExpandLabel alloc] init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).insets(NavigationContentTop + 20);
        make.left.right.equalTo(self.view).insets(40);
    }];
    
    NSString *str = [self contentStr];// [NSString tmui_random:300];
    NSMutableAttributedString *attr = [NSMutableAttributedString tmui_attributedStringWithString:str font:UIFont(18) color:UIColor.tmui_randomColor lineSpacing:(int)(arc4random()%20)];
    label.maxLine = (int)(arc4random()%10);
    label.attributedText = attr;
    
    label.clickActionBlock = ^(TMUIExpandLabelClickActionType clickType) {
        NSLog(@"%lu",(unsigned long)clickType);
    };
    label.sizeChangeBlock = ^(CGSize size) {
        NSLog(@"%@",NSStringFromCGSize(size));
    };
}

- (void)test2{
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).insets(NavigationContentTop + 20);
        make.left.right.equalTo(self.view).insets(20);
    }];
//    label.text = @"fdsjkfhdsjko fdhos fasjfksdflfdsa fdslk fjkdsf dsghf kdsj fksdfj sdfsdhkf dshf kdshjf kjhds fkhgs jfhds jfhg sdfsdfas";
    NSMutableAttributedString *attr = [NSMutableAttributedString tmui_attributedStringWithString:[self contentStr] font:UIFont(18) color:UIColor.tmui_randomColor lineSpacing:20];
//    label.expandString = attr;
    label.attributedText = attr;
    label.numberOfLines = 5;
    label.showsExpansionTextWhenTruncated = YES;
    
    @weakify(label);
    [label tmui_addSingerTapWithBlock:^{
        @strongify(label);
        NSMutableAttributedString *attr = [NSMutableAttributedString tmui_attributedStringWithString:[self contentStr] font:UIFont(16) color:UIColor.tmui_randomColor lineSpacing:20];
        label.attributedText = attr;
    }];
}



- (void)test1{
    
    THKExpandLabel *label = [[THKExpandLabel alloc] init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).insets(NavigationContentTop + 20);
        make.left.right.equalTo(self.view).insets(20);
    }];
    
    
    NSString *tag = @"#123入住新家#  ";
    NSString *str = [self contentStr];
    
//    THKExpandLabel *label = THKExpandLabel.new;
    
    label.numberOfLines = 8;
    label.lineGap = 6;
    label.maxWidth = TMUI_SCREEN_WIDTH - 100;
    label.preferFont = UIFont(16);
    
    @weakify(label);
    label.unfoldClick = ^{
        @strongify(label);
        NSLog(@"%@",label.text);
    };
    
    [label setTagStr:tag
         tagAttrDict:@{NSForegroundColorAttributeName:THKColor_999999,NSFontAttributeName:UIFontMedium(16)}
          contentStr:str
     contentAttrDict:@{NSForegroundColorAttributeName:UIColorHex(#1A1C1A),NSFontAttributeName:UIFont(16)}];
}


- (NSString *)contentStr {
    NSString *str = @"Demo\
开发版base\n\
土巴兔项目独立工程，抽离了部分组件，可用于快速迭代开发使用，可配合Injection进行热部署进一步提高效率\n\
包含：\n\
THKBaseNetwork\n\
TRouter\n\
TMUIKit\n\
TMCardComponent\n\
THKDynamicTabsManager\n\
THKIdentityView\n\
包含TBTBaseNetwork库快速开发接口、\n\
TMCardComponent瀑布流快速开发页面、\n\
TMUIKit库搭建页面\n\
THKDynamicTabsManager";
    return str;
}

@end
