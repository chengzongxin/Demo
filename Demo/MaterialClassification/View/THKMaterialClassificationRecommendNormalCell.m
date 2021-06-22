//
//  THKMaterialClassificationRecommendNormalCell.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/22.
//

#import "THKMaterialClassificationRecommendNormalCell.h"

@interface THKMaterialClassificationRecommendNormalCell ()

@property (weak, nonatomic) IBOutlet UIImageView *rankImgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet TMUILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation THKMaterialClassificationRecommendNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRank:(NSInteger)rank{
    _rank = rank;
    
    NSString *imgName = [NSString stringWithFormat:@"皇冠标签%02ld",rank+1];
    self.rankImgView.image = UIImageMake(imgName);
}

- (void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    
    [self.iconImgView setImageURL:[NSURL URLWithString:imgUrl]];
}

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle{
    CGFloat space = CGCustomFloat(3);
    [self.titleLabel tmui_setAttributesString:title lineSpacing:space];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.contentEdgeInsets = UIEdgeInsetsMake(space, 0, space, 0);
    self.subtitleLabel.text = subtitle;
}

@end
