//
//  THKNewcomerStageView.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/6.
//

#import "THKNewcomerStageView.h"

@interface THKNewcomerStageView ()

@property (nonatomic, strong) THKNewcomerHomeSelectStageViewModel *viewModel;

@end

@implementation THKNewcomerStageView
@dynamic viewModel;

- (void)thk_setupViews{
    NSLog(@"THKNewcomerHomeView setup,%@",self.viewModel);
}

- (void)bindViewModel{
    NSLog(@"THKNewcomerHomeView bindvm,%@",self.viewModel);
}


@end
