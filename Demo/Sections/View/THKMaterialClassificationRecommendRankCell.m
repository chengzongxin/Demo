//
//  THKMaterialClassificationRecommendRankCell.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/22.
//

#import "THKMaterialClassificationRecommendRankCell.h"

@interface THKMaterialClassificationRecommendRankCell ()

@property (weak, nonatomic) IBOutlet UIImageView *rankImgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation THKMaterialClassificationRecommendRankCell

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
    self.subtitleLabel.text = subtitle;
    
    self.titleLabel.attributedText = [NSAttributedString tmui_attributedStringWithString:title font:UIFontMedium(14) color:UIColorHex(#1A1C1A)];
    [self.subtitleLabel tmui_setAttributesString:@" 分" color:UIColorHex(#979997) font:UIFont(12)];
}

@end
