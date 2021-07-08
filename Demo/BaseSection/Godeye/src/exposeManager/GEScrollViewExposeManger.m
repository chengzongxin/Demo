//
//  GEScrollViewExposeManger.m
//  THKMyTestApp
//
//  Created by amby.qin on 2020/12/4.
//

#import "GEScrollViewExposeManger.h"
#import "UIScrollView+Godeye.h"
#import "GETableView.h"
#import "GECollectionView.h"

@interface GEScrollViewExposeManger ()<UIScrollViewDelegate>

@property (nonatomic, assign)   BOOL decelerating;
@property (nonatomic, assign)   NSInteger draggingFlag;//判断手指是否离开屏幕，停止拖拽。手指在缓慢拖拽过程中，需要不停的计算曝光，当停止拖拽时根据滑动速度来计算是否需要曝光(速度绝对值小于1.0计算曝光)，否则检测列表停止后再曝光
@property (nonatomic, assign)   NSTimeInterval exposeInterval;//在屏幕上显示超过0.5s则曝光

@property (nonatomic, copy)     NSSet<NSIndexPath*> *indexPathSet;//保存上一次出现在屏幕上的cell

@end

@implementation GEScrollViewExposeManger

#pragma mark - public

+ (void)calculateVisbleCellsWithScrollView:(UIScrollView *)scrollView {
    [self calculateVisbleCellsWithScrollView:scrollView expose:YES];
}


#pragma mark - private

/**
 获取列表是水平滚动还是垂直方向滚动
 */
+ (BOOL)isDirectionVerticalWithScrollView:(UIScrollView *)scrollView {
    BOOL scrollDirectVer = scrollView.contentSize.height > scrollView.bounds.size.height;//是否为垂直方向滑动
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)scrollView;
        if ([collectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
            UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
            scrollDirectVer = flowLayout.scrollDirection == UICollectionViewScrollDirectionVertical;
        }
    }
    return scrollDirectVer;
}

/**
 分别计算cell相对于superview和window的位置，然后得出2者的交集，只要这个交集大于cell面积的1/2，就认为是曝光
 expose: YES--立即执行曝光；NO-不曝光，只计算当前曝光的indexPath
 */
+ (NSSet<NSIndexPath *> *)calculateVisbleCellsWithScrollView:(UIScrollView *)scrollView expose:(BOOL)expose {
    if (![scrollView exposeBlockEnabled]) {
        return nil;
    }
    
    NSMutableSet<NSIndexPath *> *currentIndexPathSet = [NSMutableSet set];
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)scrollView;
        [tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL isAppear = [self calulateAppearWithScrollView:scrollView cell:obj nestScrollView:obj.nestScrollView];
            if (isAppear) {//cell在superview的范围内并且在window的范围内(显示在手机屏幕上)，则认为曝光
                NSIndexPath *indexPath = [tableView indexPathForCell:obj];
                if (expose) {
                    [self exposeWithScrollView:scrollView atIndexPath:indexPath];
                } else {
                    [currentIndexPathSet addObject:indexPath];
                }
            }
        }];
    } else if ([scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)scrollView;
        [collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL isAppear = [self calulateAppearWithScrollView:scrollView cell:obj nestScrollView:obj.nestScrollView];
            if (isAppear) {//cell在superview的范围内并且在window的范围内(显示在手机屏幕上)，则认为曝光
                NSIndexPath *indexPath = [collectionView indexPathForCell:obj];
                if (expose) {
                    [self exposeWithScrollView:scrollView atIndexPath:indexPath];
                } else {
                    [currentIndexPathSet addObject:indexPath];
                }
            }
        }];
    }
    return currentIndexPathSet.copy;
}

/**
 计算cell是否显示在scrollView中并同时显示在屏幕上:即当前cell可见
 nest: YES--cell有嵌套列表，并且cell本身不曝光，而是对嵌套列表的内容进行曝光，此时只要cell可见就要对它嵌套的列表计算曝光；NO--对cell曝光，显示面积大于一半就触发曝光
 */
+ (BOOL)calulateAppearWithScrollView:(UIScrollView *)scrollView cell:(UIView *)cell nestScrollView:(UIScrollView *)nestScrollView {
    CGFloat area = cell.bounds.size.width * cell.bounds.size.height;
    if (area <= 0) {
        return NO;
    }
    CGFloat limit = nestScrollView ? 0 : 0.5;//如果对嵌套的scrollView曝光，只要cell可见就需要通知嵌套scrollView；如果对cell本身的曝光则需要显示面积的一半才触发曝光
    CGRect frameSuper = [cell convertRect:cell.bounds toView:scrollView];//计算cell相对于scrollView.superview的位置，
    CGRect scrollInset = CGRectIntersection(frameSuper, scrollView.bounds); //计算cell的位置与superview的交集
    BOOL isAppear = (scrollInset.size.width * scrollInset.size.height) / area > limit;
    if (isAppear) {
        CGRect frameWindow = [cell convertRect:cell.bounds toView:scrollView.window];//计算cell相对于手机屏幕的位置
        scrollInset = CGRectIntersection(frameWindow, scrollView.window.bounds);//计算cell与window的交集
        isAppear = (scrollInset.size.width * scrollInset.size.height) / area > limit;
    }
    if (nestScrollView) {
        if (isAppear) {
            [nestScrollView reportExpose];
        }
        return NO;
    }
    return isAppear;
}

/**
 对符合条件的cell执行曝光block
 */
+ (void)exposeWithScrollView:(UIScrollView *)scrollView atIndexPath:(NSIndexPath *)indexPath {
    if (scrollView.geExposeBlock) {
        NSDictionary *dictParam = scrollView.geExposeBlock(indexPath);
        if (dictParam) {
            GEWidgetResource *resource = [GEWidgetResource resourceWithExposeScrollView:scrollView atIndexPath:indexPath];
            [resource addEntries:dictParam];
            [[GEWidgetExposeEvent eventWithResource:resource] report];
        }
    }
}

/**
 计算当前可见cell集合与0.5秒之前可见cell集合的交集，如果存在交集，则表示交集部分在屏幕上显示的时间超过了预定的曝光时长(即0.5秒)，那么就需要对这个交集的cell进行逐一曝光
 */
- (void)calculateIntersectVisbleCellsWithScrollView:(UIScrollView *)scrollView {

    NSSet<NSIndexPath *> *currentIndexPathSet = [self.class calculateVisbleCellsWithScrollView:scrollView expose:NO];
    NSMutableSet<NSIndexPath *> *tempIndexPathSet = [NSMutableSet setWithSet:currentIndexPathSet];
    if (self.indexPathSet) {
        [tempIndexPathSet intersectSet:self.indexPathSet];
    }
    self.indexPathSet = currentIndexPathSet;
    if (scrollView.geExposeItemsBlock) {
        scrollView.geExposeItemsBlock(tempIndexPathSet.allObjects);
    } else {
        //对交集进行曝光
        [tempIndexPathSet.allObjects enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.class exposeWithScrollView:scrollView atIndexPath:obj];
        }];
    }
}

#pragma mark - scrollViewDelegate
/**
 以下是对scrollViewDelegate的方法进行计算，以方便快速计算出符合曝光条件的cell
 */

/**
 列表滚动到顶部时检测曝光
 */
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {

    [self scrollViewDidEndDecelerating:scrollView];
}

/**
 列表停止滚动动画时检测曝光
 这2个方法 setContentOffset/scrollRectVisible:animated:的动画完成时执行这个回调，如果没有动画则不执行
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

/**
 列表开始滑动是，需要做滑动标记
 */
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //记录是否有滑动的动作，只要有滑动的动作，后续一定会执行scrollViewDidEndDecelerating:(计算曝光)，就算在滑动途中触摸屏幕强制滑动停止
    //如果在滑动途中触摸屏幕强制停止了滑动，也会执行scrollViewDidEndDragging:willDecelerate:并且decelerate=NO(计算曝光)，这样的话就会触发2次曝光计算
    //所以需要记录这个滑动状态，在强制停止滑动时，不执行scrollViewDidEndDragging:willDecelerate:中的曝光计算
    self.decelerating = YES;
}

/**
 手指离开屏幕即停止拉拽时，需要检测曝光
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate && !self.decelerating) {//如果是滑动状态下触摸屏幕强制停止的，则忽略本次停止滑动事件
        [self scrollViewDidEndDecelerating:scrollView];
    }
    self.decelerating = NO;
}

/**
 列表停止滚动时检测曝光
 */
- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView {

    self.draggingFlag = 2;//停止滚动时不再计算交集
    self.decelerating = NO;
    [GEScrollViewExposeManger calculateVisbleCellsWithScrollView:scrollView];
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    BOOL scrollDirectVer = [self.class isDirectionVerticalWithScrollView:scrollView];
    if (fabs(scrollDirectVer ? velocity.y : velocity.x) > 0) {
        self.draggingFlag = 1;//只要有滚动，就计算曝光
    } else {
        self.draggingFlag = 2;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.draggingFlag == 1) {
        if (CFAbsoluteTimeGetCurrent() - self.exposeInterval > 0.5) {//每隔0.5s检测当前和上一次的visibleCells是否存在交集，如果有交集则曝光
            self.exposeInterval = CFAbsoluteTimeGetCurrent();
            [self calculateIntersectVisbleCellsWithScrollView:scrollView];//检测交集
        }
    } else {
        self.exposeInterval = CFAbsoluteTimeGetCurrent();
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.indexPathSet = [self.class calculateVisbleCellsWithScrollView:scrollView expose:NO];
    self.draggingFlag = 1;//用手缓慢滑动列表或者拖拽列表不松手，如果这个时间超过0.5秒，则需要计算曝光
    self.exposeInterval = CFAbsoluteTimeGetCurrent();
}

@end
