//
//  THKReferenPictureListLayout.m
//  Demo
//
//  Created by Joe.cheng on 2023/7/5.
//

#import "THKReferenPictureListLayout.h"

@interface THKReferenPictureListLayout ()

@property (nonatomic, strong) NSMutableArray *itemAttributes;
/// Array to store height for each column
@property (nonatomic, strong) NSMutableArray *columnHeights;
/// Array to store attributes for all items includes headers, cells, and footers
@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *>*allItemAttributes;
/// 记录高度
@property (nonatomic, assign) CGFloat lastY;
/// 记录宽度
@property (nonatomic, assign) CGFloat lastX;

@property (nonatomic, assign) CGFloat lastXstate;

@property (nonatomic, assign) CGFloat maxHeight;

@property (nonatomic, strong) UICollectionViewLayoutAttributes *maxXattributes;

@property (nonatomic, strong) UICollectionViewLayoutAttributes *maxYattributes;

@end

@implementation THKReferenPictureListLayout
//初始化自定义的flowLayout
- (void)prepareLayout {
    //必须调用super
    [super prepareLayout];
    
    self.maxHeight = 0;
    self.maxXattributes = nil;
    self.maxYattributes = nil;
    NSInteger section = 0;
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger columnCount = 3;
      NSMutableArray *sectionColumnHeights = [NSMutableArray arrayWithCapacity:columnCount];
      for (int idx = 0; idx < columnCount; idx++) {
        [sectionColumnHeights safeAddObject:@(0)];
      }
      [self.columnHeights safeAddObject:sectionColumnHeights];
    }

    self.lastX = self.sectionInset.left;
    self.lastY = self.sectionInset.top;
    self.lastXstate = 0;
    
    /*
     * 3. Section items
     */
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
    NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];

    // Item will be put into shortest column.
    for (int idx = 0; idx < itemCount; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
//        NSUInteger columnIndex = [self nextColumnIndexForItem:idx inSection:section];
//        CGFloat xOffset = self.sectionInset.left + (itemWidth + self.minimumInteritemSpacing) * columnIndex;
//        CGFloat yOffset = [self.columnHeights[section][columnIndex] floatValue];
//        CGPoint point = [self nextPoint];
        CGPoint point = CGPointMake(self.lastX, self.lastY);
        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        
//        CGFloat itemHeight = 0;
//        if (itemSize.height > 0 && itemSize.width > 0) {
//            itemHeight = CHTFloorCGFloat1(itemSize.height * itemWidth / itemSize.width);
//        }
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(point.x, point.y, itemSize.width, itemSize.height);
        [itemAttributes safeAddObject:attributes];
        [self.allItemAttributes safeAddObject:attributes];
        
        if (CGRectGetMaxY(attributes.frame) > self.maxHeight) {
            self.maxHeight = CGRectGetMaxY(attributes.frame);
            self.maxXattributes = attributes;
        }
        
        BOOL reach = CGRectGetMaxX(attributes.frame) >= self.collectionView.width - self.sectionInset.right - 20;
        if (reach) {
            if (self.maxHeight > CGRectGetMaxY(attributes.frame) + 20) {
                self.lastX = CGRectGetMaxX(self.maxXattributes.frame) + self.minimumInteritemSpacing;
                self.lastY = CGRectGetMaxY(attributes.frame) + self.minimumLineSpacing / 2;
            }else{
                self.lastX = self.sectionInset.left;
                self.lastY = CGRectGetMaxY(attributes.frame) + self.minimumLineSpacing ;
            }
        }else{
            self.lastX = CGRectGetMaxX(attributes.frame) + self.minimumInteritemSpacing;
            self.lastY = CGRectGetMinY(attributes.frame);
        }
        
        
//        self.lastX +=  (itemSize.width + self.sectionInset.right);
//        if (0) {
//            if (self.lastXstate != self.sectionInset.left) {
//
//            }else {
//                self.lastX = self.sectionInset.left;
//            }
//
//
//            self.lastY += (itemSize.height);
//        }
//        self.lastXstate = self.lastX;
//        self.columnHeights[section][columnIndex] = @(CGRectGetMaxY(attributes.frame) + self.minimumInteritemSpacing);
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




//- (void)findLastXY{
//    for (NSInteger i = self.allItemAttributes.count - 1; i > 0; i--) {
//        UICollectionViewLayoutAttributes *attributes = self.allItemAttributes[i];
//        if (CGRectGetMaxX(attributes.frame) > CGRectGetMaxX(self.maxXattributes)) {
//            self.maxXattributes = attributes;
//        }
//        if (CGRectGetMaxY(attributes.frame) > CGRectGetMaxY(self.maxYattributes)) {
//            self.maxYattributes = attributes;
//        }
//    }
//}


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

/**
 *  Find the shortest column.
 *
 *  @return index for the shortest column
 */
- (NSUInteger)shortestColumnIndexInSection:(NSInteger)section {
  __block NSUInteger index = 0;
  __block CGFloat shortestHeight = MAXFLOAT;

  [self.columnHeights[section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    CGFloat height = [obj floatValue];
    if (height < shortestHeight) {
      shortestHeight = height;
      index = idx;
    }
  }];

  return index;
}

/**
 *  Find the index for the next column.
 *
 *  @return index for the next column
 */
- (NSUInteger)nextColumnIndexForItem:(NSInteger)item inSection:(NSInteger)section {
    NSUInteger index = 0;
    NSInteger columnCount = 3;
    index = [self shortestColumnIndexInSection:section];
    return index;
}

CGFloat CHTFloorCGFloat1(CGFloat value) {
  CGFloat scale = [UIScreen mainScreen].scale;
  return floor(value * scale) / scale;
}

- (id <THKReferenPictureListLayoutDelegate> )delegate {
  return (id <THKReferenPictureListLayoutDelegate> )self.collectionView.delegate;
}

- (NSMutableArray *)columnHeights {
  if (!_columnHeights) {
    _columnHeights = [NSMutableArray array];
  }
  return _columnHeights;
}

- (NSMutableArray *)allItemAttributes {
  if (!_allItemAttributes) {
    _allItemAttributes = [NSMutableArray array];
  }
  return _allItemAttributes;
}


@end
