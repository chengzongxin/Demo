//
//  THKMaterialClassificationDecorationView.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialClassificationRecommendDecorationView.h"

@interface THKMaterialClassificationRecommendDecorationView ()

@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation THKMaterialClassificationRecommendDecorationView
#pragma mark - Life Cycle
- (void)dealloc{
    NSLog(@"%@ did dealloc",self);
}

/// xib创建
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

/// init or initWithFrame创建
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 8;
        _imageView.layer.masksToBounds = YES;
//        UIImage *image = [UIImage imageNamed:@"dec_banner_def"];
//        _imageView.image = image;
        //                _imageView.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    // 只有第一行是整个section背景，其他都是只有头部尺寸,其他页面不显示排行榜头图
    if ([self.reuseIdentifier isEqualToString:Full_BackGround_ReuseId]) {
        _imageView.image = UIImageMake(@"bg_brand_rank");
    }else{
        _imageView.image = [UIImage tmui_imageWithColor:UIColor.whiteColor];
    }
    _imageView.frame = CGRectMake(0, 0, layoutAttributes.frame.size.width, layoutAttributes.frame.size.height); // 距离底部10间距
}


@end
