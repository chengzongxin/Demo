//
//  THKMaterialClassificationRecommendRankCell.h
//  Demo
//
//  Created by Joe.cheng on 2021/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKMaterialClassificationRecommendRankCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *rankImgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, assign) NSInteger rank;

@property (nonatomic, strong) NSString *imgUrl;

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle;

@end

NS_ASSUME_NONNULL_END
