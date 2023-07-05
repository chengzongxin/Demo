//
//  THKReferenPictureListLayout.h
//  Demo
//
//  Created by Joe.cheng on 2023/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol THKReferenPictureListLayoutDelegate <NSObject>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface THKReferenPictureListLayout : UICollectionViewLayout
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGSize estimatedItemSize API_AVAILABLE(ios(8.0)); // defaults to CGSizeZero - setting a non-zero size enables cells that self-size via -preferredLayoutAttributesFittingAttributes:
@property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical
@property (nonatomic) CGSize headerReferenceSize;
@property (nonatomic) CGSize footerReferenceSize;
@property (nonatomic) UIEdgeInsets sectionInset;


@end

NS_ASSUME_NONNULL_END
