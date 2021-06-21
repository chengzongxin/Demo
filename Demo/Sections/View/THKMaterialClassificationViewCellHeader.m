//
//  THKMaterialClassificationViewCellHeader.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialClassificationViewCellHeader.h"

@implementation THKMaterialClassificationViewCellHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.width - 20, self.height)];
        [_imgView tmui_cornerDirect:UIRectCornerTopLeft|UIRectCornerTopRight radius:8];
        [self addSubview:_imgView];
    }
    return self;
}

@end
