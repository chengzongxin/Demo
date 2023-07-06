//
//  THKReferenPictureListLayout.m
//  Demo
//
//  Created by Joe.cheng on 2023/7/5.
//

#import "THKReferenPictureListLayout.h"

@interface THKReferenPictureListLayout ()

/// Array to store attributes for all items includes headers, cells, and footers
@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *>*allItemAttributes;

@end

@implementation THKReferenPictureListLayout
//初始化自定义的flowLayout
- (void)prepareLayout {
    //必须调用super
    [super prepareLayout];
    
    

    CGFloat lastX = self.sectionInset.left;
    CGFloat lastY = self.sectionInset.top;
    CGFloat maxHeight = 0;
    UICollectionViewLayoutAttributes *bigLayoutAttr = nil;
    
    NSInteger section = 0;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
    NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];

    for (int idx = 0; idx < itemCount; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
        
        CGPoint point = CGPointMake(lastX, lastY);
        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(point.x, point.y, itemSize.width, itemSize.height);
        [itemAttributes safeAddObject:attributes];
        [self.allItemAttributes safeAddObject:attributes];
        
        if (CGRectGetMaxY(attributes.frame) > maxHeight) {
            maxHeight = CGRectGetMaxY(attributes.frame);
            bigLayoutAttr = attributes;
        }
        
        BOOL reach = CGRectGetMaxX(attributes.frame) >= self.collectionView.width - self.sectionInset.right - 20;
        if (reach) {
            if (maxHeight > CGRectGetMaxY(attributes.frame) + 20) {
                lastX = CGRectGetMaxX(bigLayoutAttr.frame) + self.minimumInteritemSpacing;
                lastY = CGRectGetMaxY(attributes.frame) + self.minimumLineSpacing;
            }else{
                lastX = self.sectionInset.left;
                lastY = CGRectGetMaxY(attributes.frame) + self.minimumLineSpacing ;
            }
        }else{
            lastX = CGRectGetMaxX(attributes.frame) + self.minimumInteritemSpacing;
            lastY = CGRectGetMinY(attributes.frame);
        }
    }
    
    for ( UICollectionViewLayoutAttributes *attributes in self.allItemAttributes) {
        NSLog(@"%@",NSStringFromCGRect(attributes.frame));
    }
}

- (CGFloat)nextXForLastY:(CGFloat)lastY{
    CGFloat nextX = self.sectionInset.left;
    for (NSInteger i = self.allItemAttributes.count - 1; i > 0; i--) {
        UICollectionViewLayoutAttributes *attributes = self.allItemAttributes[i];
        // 已经是上一行
        if (lastY > attributes.frame.origin.y) {
            break;
        }
        
        if (lastY < CGRectGetMaxY(attributes.frame)) {
            nextX = CGRectGetMaxX(attributes.frame) + self.minimumInteritemSpacing;
            break;
        }
        
        if (i < self.allItemAttributes.count - 5) {
            break;
        }
    }
    return nextX;
}



- (CGPoint)nextPoint{
    UICollectionViewLayoutAttributes *lastAttr = self.allItemAttributes.lastObject;
    if (!lastAttr) {
        return CGPointMake(self.sectionInset.left, self.sectionInset.top);
    }
    
    UICollectionViewLayoutAttributes *maxX = nil;
    UICollectionViewLayoutAttributes *maxY = nil;
    CGPoint desPoint = CGPointZero;
    for (NSInteger i = self.allItemAttributes.count - 1; i >= 0; i--) {
        UICollectionViewLayoutAttributes *attributes = self.allItemAttributes[i];
        
        if (CGRectGetMaxY(attributes.frame) > CGRectGetMaxY(maxY.frame)) {
            maxY = attributes;
        }
        if (CGRectGetMaxX(attributes.frame) > CGRectGetMaxX(maxX.frame)) {
            maxX = attributes;
        }
        if (i < (int)self.allItemAttributes.count - 5) {
            break;
        }
    }
    
    if (self.allItemAttributes.count < 3) {
        maxX = maxY = self.allItemAttributes.lastObject;
    }
    
    if (maxX == maxY) {
        if (CGRectGetMaxX(maxX.frame) + self.sectionInset.right == self.collectionView.width) {
            desPoint = CGPointMake(self.sectionInset.left, CGRectGetMaxY(maxX.frame) + self.minimumLineSpacing);
        }else{
            desPoint = CGPointMake(CGRectGetMaxX(maxX.frame) + self.minimumInteritemSpacing, maxX.frame.origin.y);
        }
    }else{
        
        if (maxY.frame.size.height > maxX.frame.size.height) {
            // 需要塞数据
            desPoint = CGPointMake(CGRectGetMaxX(maxY.frame) + self.minimumInteritemSpacing, CGRectGetMaxY(lastAttr.frame) + self.minimumLineSpacing);
        }else{
            desPoint = CGPointMake(self.sectionInset.left, CGRectGetMaxY(lastAttr.frame) + self.minimumLineSpacing);
            
        }
    }
    
    return desPoint;
}

//滑动时会时时调用此方法 改变布局
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.allItemAttributes;
}

// 当collectionView bounds改变时，是否重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}
//返回collectionView的最终大小
- (CGSize)collectionViewContentSize {
    return CGSizeMake(TMUI_SCREEN_WIDTH, CGRectGetMaxY(self.allItemAttributes.lastObject.frame));
}



#pragma mark - Private Methods

CGFloat CHTFloorCGFloat1(CGFloat value) {
  CGFloat scale = [UIScreen mainScreen].scale;
  return floor(value * scale) / scale;
}

- (id <THKReferenPictureListLayoutDelegate> )delegate {
  return (id <THKReferenPictureListLayoutDelegate> )self.collectionView.delegate;
}

- (NSMutableArray *)allItemAttributes {
  if (!_allItemAttributes) {
    _allItemAttributes = [NSMutableArray array];
  }
  return _allItemAttributes;
}


@end
