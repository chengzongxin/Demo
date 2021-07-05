//
//  MultiStylesCollectionViewWaterfallLayout.m
//  HouseKeeper
//
//  Created by nigel.ning on 2019/4/1.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "MultiStylesCollectionViewWaterfallLayout.h"

@implementation MultiStylesCollectionViewWaterfallLayout
#pragma mark - 悬浮header效果,待完善
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = nil;
    attribute = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    return attribute;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *superArray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    NSMutableIndexSet *noneHeaderSections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            [noneHeaderSections addIndex:attributes.indexPath.section];
        }
    }
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        if ([attributes.representedElementKind isEqualToString:CHTCollectionElementKindSectionHeader]) {
            [noneHeaderSections removeIndex:attributes.indexPath.section];
        }
    }
    [noneHeaderSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        //获取当前section在正常情况下已经离开屏幕的header结构信息
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader atIndexPath:indexPath];
        if (attributes) {
            [superArray safeAddObject:attributes];
        }
    }];
    // 没有内容的时候直接返回空
    NSInteger sections = [self.collectionView numberOfSections];
    if (!sections) return nil;
    //遍历superArray，改变header结构信息中的参数，使它可以在当前section还没完全离开屏幕的时候一直显示
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        //如果当前item是header
        if ([attributes.representedElementKind isEqualToString:CHTCollectionElementKindSectionHeader]) {
            if (self.lockHeaderAtTopBlock && self.lockHeaderAtTopBlock(attributes.indexPath)) {
                //只有需要悬浮的才处理
            }else {
                //不需要则continue
                continue;
            }
            UIEdgeInsets sectionInset = self.sectionInset;
            id<UICollectionViewDelegateFlowLayout> ly = (id<UICollectionViewDelegateFlowLayout>)(self.collectionView.delegate);
            if ([ly respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
                sectionInset = [ly collectionView:self.collectionView layout:self insetForSectionAtIndex:attributes.indexPath.section];
            }
            //得到当前header所在分区的cell的数量
            NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:attributes.indexPath.section];
            //得到第一个item的indexPath
            NSIndexPath *firstItemIndexPath = [NSIndexPath indexPathForItem:0 inSection:attributes.indexPath.section];
            //得到最后一个item的indexPath
            NSIndexPath *lastItemIndexPath = [NSIndexPath indexPathForItem:MAX(0, numberOfItemsInSection-1) inSection:attributes.indexPath.section];
            //得到第一个item和最后一个item的结构信息
            UICollectionViewLayoutAttributes *firstItemAttributes, *lastItemAttributes;
            if (numberOfItemsInSection>0) {
                //cell有值，则获取第一个cell和最后一个cell的结构信息
                firstItemAttributes = [self layoutAttributesForItemAtIndexPath:firstItemIndexPath];
                lastItemAttributes = [self layoutAttributesForItemAtIndexPath:lastItemIndexPath];
            }else {
                //cell没值,就新建一个UICollectionViewLayoutAttributes
                firstItemAttributes = [UICollectionViewLayoutAttributes new];
                //然后模拟出在当前分区中的唯一一个cell，cell在header的下面，高度为0，还与header隔着可能存在的sectionInset的top
                CGFloat y = CGRectGetMaxY(attributes.frame)+sectionInset.top;
                firstItemAttributes.frame = CGRectMake(0, y, 0, 0);
                //因为只有一个cell，所以最后一个cell等于第一个cell
                lastItemAttributes = firstItemAttributes;
            }
            
            //获取当前header的frame
            CGRect rect = attributes.frame;
            
            //当前的滑动距离 + 因为导航栏产生的偏移量，默认为64（如果app需求不同，需自己设置）
            CGFloat offset = self.collectionView.contentOffset.y;
            //第一个cell的y值 - 当前header的高度 - 可能存在的sectionInset的top
            CGFloat headerY = firstItemAttributes.frame.origin.y - rect.size.height - sectionInset.top;
            
            //哪个大取哪个，保证header悬停
            //针对当前header基本上都是offset更加大，针对下一个header则会是headerY大，各自处理
            CGFloat maxY = MAX(offset,headerY);
            
            //最后一个cell的y值 + 最后一个cell的高度 + 可能存在的sectionInset的bottom - 当前header的高度
            //当当前section的footer或者下一个section的header接触到当前header的底部，计算出的headerMissingY即为有效值
            CGFloat headerMissingY = CGRectGetMaxY(lastItemAttributes.frame) + sectionInset.bottom - rect.size.height;
            
            //给rect的y赋新值，因为在最后消失的临界点要跟谁消失，所以取小
            rect.origin.y = MIN(maxY,headerMissingY);
            //给header的结构信息的frame重新赋值
            attributes.frame = rect;
            
            //如果按照正常情况下,header离开屏幕被系统回收，而header的层次关系又与cell相等，如果不去理会，会出现cell在header上面的情况
            //通过打印可以知道cell的层次关系zIndex数值为0，我们可以将header的zIndex设置成1，如果不放心，也可以将它设置成非常大，这里随便填了个7
            attributes.zIndex = 7;
        }
    }
    
    return superArray;
}

//return YES;表示一旦滑动就实时调用上面这个layoutAttributesForElementsInRect:方法
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    //为防止列表滚动时一直不停的执行刷新，回调layoutAttributesForElementsInRect方法，这里稍做优化，只有可能需要header悬念效果时才执行高的刷新处理逻辑以便于能正确处理header视图的悬念位置等逻辑
    if (self.lockHeaderAtTopBlock) {
        return YES;
    }

    return NO;
}

@end
