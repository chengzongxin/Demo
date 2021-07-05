//
//  THKPushPopAsLocationToListTransition.h
//  HouseKeeper
//
//  Created by nigel.ning on 2020/12/7.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "THKPushPopBaseTransition.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 从列表页或普通页，指定某个区域的视图开始转场动画过渡push到下个页面，且动画结束可指定到下个页面的某个区域位置
 * @note 此为单纯的转场动画，作动画相关的动画视图为 pushFromSourceView的复制品或以pushFromSourceImage生成的imageView视图，此动画对原有pushFromVc的view及pushToVc的view的内容不造成任何影响。所以可能会出现从sourcView位置上浮出一个另外的动画视图来作转场，但动画过程中，原来区域位置的视图本身仍然可见
 */
@interface THKPushPopAsLocationToListTransition : THKPushPopBaseTransition

#pragma mark - push 动效需要的相关数据支持

/// push from : source UI support

@property (nonatomic, weak)UIView *pushFromSourceView;///< push动效的起始位置视图，内部分copy一个备份专用来作动画效果
@property (nonatomic, strong, nullable)UIImage *pushFromSourceImage;///< 若pushFromSourceView内部有对应的image可赋值

/// push to: destination UI support

///push动画结束的frame，坐标相对屏幕坐标系,若不赋值或为CGRectZero，则会pushFromSourceImage.size居中适应或pushFromSourceView居中适应屏幕后的位置为参考
@property (nonatomic, assign)CGRect pushToSourceRect;

///push动画开始时的动画视图的layer.cornerRadius参数，默认为0
@property (nonatomic, assign)CGFloat pushFromCornerRadius;

///push动画结束的动画视图的layer.cornerRadius参数，默认为0
@property (nonatomic, assign)CGFloat pushToCornerRadius;

///push动画结束区域的目标视图
@property (nonatomic, copy, nullable)UIView *_Nullable(^getPushToSourceViewBlock)(void);

/// push动画结束后的回调
@property (nonatomic, copy, nullable)void (^pushTransitionEndBlock)(THKPushPopAsLocationToListTransition *transition, BOOL transitionCompleted);

#pragma mark - pop 动效需要的相关数据支持 | 因pop在push执行之后，所以pop相关的UI源支持以block形式获取

///MARK: 若以下getPopFromSourceViewBlock()返回nil则会按push操作时记录的起始位置作为pop目标rect的值，对应的pushFromSourceView的copy或基于pushFromSourceImage生成的动画视图作为执行动画的实际视图实例

///pop from: source UI support

/// pop时获取相关动效起始位置的视图
@property (nonatomic, copy, nullable)UIView *_Nullable(^getPopFromSourceViewBlock)(void);
/// 若pop内部有对应的image可赋值
@property (nonatomic, copy, nullable)UIImage *_Nullable(^getPopFromSourceImageBlock)(void);

/// pop to: destination UI support

///pop动画结束时的frame，坐标相对屏幕坐标系. 若返回CGRectZero则目标值会按Push时记录的起始位置为参考。
@property (nonatomic, copy, nullable)CGRect (^getPopToSourceRectBlock)(void);

///pop动画结束区域的目标视图
///@note 部分详情页返回列表时，因为有稍延迟的刷新列表操作，会因cell重用导致刷新前取到的对应的cell在刷新后变化到其它位置上，所以相关Pop动画修改alpha值会造成UI效果异常。这里相关列表页暂不实现此方法。
@property (nonatomic, copy, nullable)UIView *_Nullable(^getPopToSourceViewBlock)(void);

///pop动画开始时的动画视图的layer.cornerRadius参数，默认取0
@property (nonatomic, assign)CGFloat (^getPopFromCornerRadiusBlock)(void);

///pop动画结束的动画视图的layer.cornerRadius参数，默认取0
@property (nonatomic, assign)CGFloat (^getPopToCornerRadiusBlock)(void);

/// pop动画结束后的回调
@property (nonatomic, copy, nullable)void (^popTransitionEndBlock)(THKPushPopAsLocationToListTransition *transition, BOOL transitionCompleted);

@end

NS_INLINE CGRect popToRectUpOfCurrentScreen(void) {
    return CGRectMake(kScreenWidth/2, kScreenHeight/2, 1, 1);
};

NS_INLINE CGRect popToRectDownOfCurrentScreen(void) {
    return CGRectMake(kScreenWidth/2, kScreenHeight/2, 1, 1);
};

NS_ASSUME_NONNULL_END
