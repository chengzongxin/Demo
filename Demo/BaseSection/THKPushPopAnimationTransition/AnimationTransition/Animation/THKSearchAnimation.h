//
//  THKSearchAnimation.h
//  HouseKeeper
//
//  Created by ben.gan on 2020/11/24.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKTransitionAnimation.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    THKCancelBtnAnimation_None,
    THKCancelBtnAnimation_Enter,
    THKCancelBtnAnimation_Back,
} THKCancelBtnAnimation;

@class THKSearchView;

@interface THKSearchAnimation : THKTransitionAnimation

@property (nonatomic, strong, readonly) NSArray <UIView *> *enterFadeViews;
@property (nonatomic, strong, readonly) NSArray <UIView *> *enterShowViews;
@property (nonatomic, assign, readonly) CGRect searchBarStartFrame;
@property (nonatomic, assign, readonly) CGRect searchBarEndFrame;

/**
 初始化
 * @param searchBarStartFrame 初始frame
 * @param searchBarEndFrame 结束frame
 * @param enterFadeViews 入场隐藏的views
 * @param enterFadeViews 入场显示的views
 * @param enterCancelBtnAniShow 入场的“取消”按钮--显示/隐藏
 * @return
 */

- (instancetype)initWithSearchBarStartFrame:(CGRect)searchBarStartFrame
                          searchBarEndFrame:(CGRect)searchBarEndFrame
                             enterFadeViews:(NSArray <UIView *> *)enterFadeViews
                             enterShowViews:(NSArray <UIView *> *)enterShowViews
                                  searchTxt:(NSString *)searchTxt
                             txtHighlighted:(BOOL)txtHighlighted;

- (instancetype)initWithSearchBarStartFrame:(CGRect)searchBarStartFrame
                          searchBarEndFrame:(CGRect)searchBarEndFrame
                             enterFadeViews:(NSArray <UIView *> *)enterFadeViews
                             enterShowViews:(NSArray <UIView *> *)enterShowViews
                               cancelBtnAni:(BOOL)cancelBtnAni
                             cancelBtnEnter:(BOOL)cancelBtnEnter
                                  searchTxt:(NSString *)searchTxt
                             txtHighlighted:(BOOL)txtHighlighted;

- (instancetype)initWithSearchBarStartFrame:(CGRect)searchBarStartFrame
                          searchBarEndFrame:(CGRect)searchBarEndFrame
                             enterFadeViews:(NSArray <UIView *> *)enterFadeViews
                             enterShowViews:(NSArray <UIView *> *)enterShowViews
                               cancelBtnAni:(BOOL)cancelBtnAni
                             cancelBtnEnter:(BOOL)cancelBtnEnter
                                  searchTxt:(NSString *)searchTxt
                             txtHighlighted:(BOOL)txtHighlighted
                                beginOffset:(CGFloat)beginOffset
                                  endOffset:(CGFloat)endOffset;
- (instancetype)initWithSearchBarStartFrame:(CGRect)searchBarStartFrame
                          searchBarEndFrame:(CGRect)searchBarEndFrame
                             enterFadeViews:(NSArray <UIView *> *)enterFadeViews
                             enterShowViews:(NSArray <UIView *> *)enterShowViews
                               cancelBtnAni:(BOOL)cancelBtnAni
                             cancelBtnEnter:(BOOL)cancelBtnEnter
                                  searchTxt:(NSString *)searchTxt
                             txtHighlighted:(BOOL)txtHighlighted
                                beginOffset:(CGFloat)beginOffset
                                  endOffset:(CGFloat)endOffset
                                beginBkgImg:(NSString *)beginBkgImg;

- (void)changeSearchBarStartFrame:(CGRect)searchBarStartFrame;
- (void)changeSearchBarEndFrame:(CGRect)searchBarEndFrame;
- (void)changeEnterFadeViews:(NSArray <UIView *> *)enterFadeViews;
- (void)changeEnterShowViews:(NSArray <UIView *> *)enterShowViews;
- (void)changeCancelBtnAni:(BOOL)cancelBtnAni;
- (void)changeCancelBtnEnter:(BOOL)cancelBtnEnter;
- (void)changeSearchTxt:(NSString *)searchTxt;
- (void)changeEndOffset:(CGFloat)endOffset;

+ (CGRect)searchVCSearchBarFrame;
+ (CGRect)searchResultContainerVCFrame;

@end

NS_ASSUME_NONNULL_END
