//
//  THKMaterialClassificationViewCellLayout.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialClassificationRecommendCellLayout.h"
#import "THKMaterialClassificationRecommendDecorationView.h"

@interface THKMaterialClassificationRecommendCellLayout (){
    BOOL _insetForSectionAtIndexFlag;
    CGFloat _lastY;
}

@end

@implementation THKMaterialClassificationRecommendCellLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    _insetForSectionAtIndexFlag = [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)];
    _lastY = 0;
    
    [self registerClass:[THKMaterialClassificationRecommendDecorationView class] forDecorationViewOfKind:[self reuseId]];
}

- (NSString *)reuseId{
    return self.firstDifferent?@"decorationView_firstDifferent":@"decorationView";
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *superAttrs = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *attrs = [NSMutableArray arrayWithArray:superAttrs];
    
    for (UICollectionViewLayoutAttributes *attr in superAttrs) {
        if (attr.representedElementKind == UICollectionElementKindSectionHeader) {
            [attrs addObject:[self layoutAttributesForDecorationViewOfKind:[self reuseId] atIndexPath:attr.indexPath top:attr.frame.origin.y]];
        }
    }
    
    return attrs;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath top:(CGFloat)top {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
    NSInteger lastIndex = [self.collectionView numberOfItemsInSection:section] - 1;
    if (lastIndex < 0) {return nil;}
    
    UICollectionViewLayoutAttributes *header = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:lastIndex inSection:section]];
    UICollectionViewLayoutAttributes *footer = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
    
    UIEdgeInsets sectionInset = _insetForSectionAtIndexFlag ? [((id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate) collectionView:self.collectionView layout:self insetForSectionAtIndex:section] : self.sectionInset;
    
    CGRect frame = CGRectUnion(firstItem.frame, lastItem.frame);
    frame.origin.x = header.frame.origin.x;
    frame.origin.y = header.frame.origin.y;
    frame.origin.x += self.decorationInset.left;
    frame.origin.y += sectionInset.top;
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        frame.size.width += CGRectGetMaxX(footer.frame) - CGRectGetMinX(header.frame) - self.decorationBottomMargin;
        frame.size.height = self.collectionView.frame.size.height - UIEdgeInsetsGetVerticalValue(self.decorationInset);
    }
    else
    {
        frame.size.width = self.collectionView.frame.size.width - UIEdgeInsetsGetHorizontalValue(self.decorationInset);
        frame.size.height = CGRectGetMaxY(footer.frame) - CGRectGetMinY(header.frame) - self.decorationBottomMargin;
    }
    
    attrs.frame = frame;
    attrs.zIndex = -1;
    
    return attrs;
}


@end
