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

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

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


@end
