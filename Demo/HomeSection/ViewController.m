//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "TMUICycleCardView.h"
#import "CycleCardCell.h"

@interface ViewController ()


@end

@implementation ViewController

// test push
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    self.view.backgroundColor = UIColor.whiteColor;
    
    TMUICycleCardView *cycle = [[TMUICycleCardView alloc] initWithFrame:CGRectMake(100, 200, 230, 155)];
    [cycle registerCell:[CycleCardCell class]];
    [self.view addSubview:cycle];
    [cycle configCell:^(UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull model) {
        CycleCardCell *cardCell = (CycleCardCell *)cell;
        cardCell.textLbl.text = model;
    }];
    // 设置数据
    cycle.models = @[@"1",@"2",@"3"];
}


@end
