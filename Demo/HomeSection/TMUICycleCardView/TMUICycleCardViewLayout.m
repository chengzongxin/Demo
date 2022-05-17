//
//  TMUICycleCardViewLayout.m
//  Demo
//
//  Created by Joe.cheng on 2022/5/17.
//

#import "TMUICycleCardViewLayout.h"

@interface TMUICycleCardViewLayout ()

@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *> *cacheAttrs;

@end

@implementation TMUICycleCardViewLayout


// 初始化和performBatchUpdates时会重新调用这个方法
- (void)prepareLayout{
    [super prepareLayout];
    
    _cacheAttrs = [NSMutableArray array];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
//        attr.frame = self.collectionView.bounds;
        // 计算每个 cell 的宽度和高度
        CGFloat x = i * _horSpacing * 2 + i * 20;
        CGFloat y = i * _verSpacing;
        CGFloat width = self.collectionView.bounds.size.width * 0.8 - i * _horSpacing * 2;
        CGFloat height = self.collectionView.bounds.size.height - i * _verSpacing * 2;
        attr.frame = CGRectMake(x, y, width, height);
        // 计算出缩放的比例
//        CGFloat scaleX = width / attr.bounds.size.width;
//        CGFloat scaleY = height / attr.bounds.size.height;
//        // 计算缩放
//        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scaleX, scaleY);
//        CGAffineTransform transform = CGAffineTransformTranslate(scaleTransform, 0, i * _interitemSpacing * 2.0);
//        attr.transform = transform;
//        if (i == 0) {
//            attr.transform = CGAffineTransformIdentity;
//        }
        // 计算zIndex
        attr.zIndex = count - attr.indexPath.item;
        
        [self.cacheAttrs addObject:attr];
    }
}

- (CGSize)collectionViewContentSize{
    return self.collectionView.bounds.size;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.cacheAttrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.cacheAttrs[indexPath.item];
}

//插入前，cell在末尾，全透明
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    if (itemIndexPath.item == count - 1) {
//        attributes.alpha = 0.0;
        attributes.zIndex = -1;
    }
    return attributes;
}

//删除时，cell在第一个位置，左移出
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
//    if (itemIndexPath.item == 0) {
//        UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//        attributes.alpha = 0.0;
//        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
//        return attributes;
//    }else
    if (itemIndexPath.item < count) {
        return [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    }else {
        return nil;
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
@end
