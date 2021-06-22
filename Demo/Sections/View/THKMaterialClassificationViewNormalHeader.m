//
//  THKMaterialClassificationViewNormalHeader.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/22.
//

#import "THKMaterialClassificationViewNormalHeader.h"

@implementation THKMaterialClassificationViewNormalHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.width - 20, self.height)];
        [_imgView tmui_cornerDirect:UIRectCornerTopLeft|UIRectCornerTopRight radius:8];
        _imgView.image = UIImageMake(@"商品卡片头部");
        [self addSubview:_imgView];
    }
    return self;
}

@end
