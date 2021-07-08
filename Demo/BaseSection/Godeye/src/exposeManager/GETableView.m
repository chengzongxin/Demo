//
//  GETableView.m
//  THKMyTestApp
//
//  Created by amby.qin on 2020/12/26.
//

#import "GETableView.h"
#import "UIScrollView+Godeye.h"

@implementation UITableViewCell (GEExpose)

- (void)setNestScrollView:(UIScrollView *)nestScrollView {
    objc_setAssociatedObject(self, @selector(nestScrollView), nestScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScrollView *)nestScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

@end

@implementation GETableView

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
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
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) self = wk_self;
        [self reportExpose];
    });
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    [super setContentOffset:contentOffset animated:animated];
    if (!animated) {//animated为YES时会执行scrollViewDidEndScrollingAnimation
        [self reportExpose];
    }
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self reportExpose];
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self reportExpose];
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self reportExpose];
}

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    [super moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    [self reportExpose];
}


- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [super insertSections:sections withRowAnimation:animation];
    [self reportExpose];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [super deleteSections:sections withRowAnimation:animation];
    [self reportExpose];
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [super reloadSections:sections withRowAnimation:animation];
    [self reportExpose];
}

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    [super moveSection:section toSection:newSection];
    [self reportExpose];
}

@end
