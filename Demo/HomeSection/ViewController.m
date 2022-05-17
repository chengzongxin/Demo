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

@property (nonatomic, strong) TMUICycleCardView *cycle;

@end

@implementation ViewController

// test push
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    self.view.backgroundColor = UIColor.whiteColor;
    
    TMUICycleCardView *cycle = [[TMUICycleCardView alloc] initWithFrame:CGRectMake(100, 200, 300, 200)];
//    cycle.backgroundColor = UIColor.orangeColor;
    [cycle registerCell:[CycleCardCell class]];
    [self.view addSubview:cycle];
    self.cycle = cycle;
    [cycle configCell:^(UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull model) {
        CycleCardCell *cardCell = (CycleCardCell *)cell;
        cardCell.textLbl.text = model;
    }];
    
    cycle.models = @[@"1",@"2",@"3",@"4"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.cycle scroll];
}



@end
