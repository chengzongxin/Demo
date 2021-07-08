//
//  GECollectionView.m
//  THKMyTestApp
//
//  Created by amby.qin on 2020/12/26.
//

#import "GECollectionView.h"
#import "UIScrollView+Godeye.h"

@implementation UICollectionViewCell (GEExpose)

- (void)setNestScrollView:(UIScrollView *)nestScrollView {
    objc_setAssociatedObject(self, @selector(nestScrollView), nestScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScrollView *)nestScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

@end

@implementation GECollectionView

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate {
    [super setDelegate:delegate];
    if (self && delegate) {
        if ([self respondsToSelector:@selector(originDelegate)]) {
            if (!self.originDelegate) {
                self.originDelegate = delegate;
            }
        }
    }
}

/**
 这些方法都可能引起cell的变化，从而需要曝光
 */
- (void)reloadData {
    [super reloadData];
    
    __weak typeof(self) wk_self = self;
    dispatch_async(dispatch_get_main_queue(), ^{//这样子搞一下，曝光的时候取collectionView.visibleCells就有值了，否则是空的
        __strong typeof(self) self = wk_self;
        [self reportExpose];
    });
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    [super setContentOffset:contentOffset animated:animated];
    if (!animated) {//animated为YES时会执行scrollViewDidEndScrollingAnimation
        //当animated=NO时，UICollectionView执行这个方法后，UI不会立即更新，所以需要延迟0.5秒，等列表内容滚动到相应位置后再计算当前显示在屏幕上的cell。UITableView不存在这个问题的
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reportExpose];
        });
    }
}

- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [super insertItemsAtIndexPaths:indexPaths];
    [self reportExpose];
}

- (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [super deleteItemsAtIndexPaths:indexPaths];
    [self reportExpose];
}

- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [super reloadItemsAtIndexPaths:indexPaths];
    [self reportExpose];
}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    [super moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
    if (indexPath.section == newIndexPath.section) {//如果是不同的section，内部会触发reload，所以这里不需要计算曝光
        [self reportExpose];
    }
}


- (void)insertSections:(NSIndexSet *)sections {
    [super insertSections:sections];
    [self reportExpose];
}

- (void)deleteSections:(NSIndexSet *)sections {
    [super deleteSections:sections];
    [self reportExpose];
}

- (void)reloadSections:(NSIndexSet *)sections {
    [super reloadSections:sections];
    [self reportExpose];
}

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    [super moveSection:section toSection:newSection];
    [self reportExpose];
}
@end
