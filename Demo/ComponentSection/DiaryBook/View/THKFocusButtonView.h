//
//  THKFocusButtonView.h
//  Demo
//
//  Created by Joe.cheng on 2021/9/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
登录操作类型
*/
typedef NS_ENUM(NSInteger, THKAttentionLoginAction) {
    THKAttentionLoginAction_WillLogin, //将要登录
    THKAttentionLoginAction_CancelLogin,//取消登录
    THKAttentionLoginAction_FinishLogin//完成登录
};

typedef NS_ENUM(NSInteger, THKAttentionFollowStatus) {
    THKAttentionFollowStatus_Hide = -1, //如果是自己，则隐藏关注按钮
    THKAttentionFollowStatus_None, //未关注
    THKAttentionFollowStatus_Followed,//已关注
    THKAttentionFollowStatus_Mutual //相互关注
};

typedef void(^FocusButtonViewResultBlock)(THKAttentionFollowStatus focus, BOOL operate);
typedef void(^FocusButtonViewScoreResultBlock)(THKAttentionFollowStatus focus, BOOL operate, NSInteger score);//score:关注接口后端直接调用了增加兔币积分接口，所以需要返回积分通知前端
typedef void(^FocusButtonViewWillClickBlock)(THKAttentionFollowStatus focus);

/**
* 根据当前登录操作action，判断是否继续往下执行代码，返回YES，表示终止操作，业务自行处理逻辑，
* @param loginAction  当前登录操作类型
* @return 是否中止操作，YES：终止操作  NO：继续操作
*/
typedef BOOL(^FocusButtonViewLoginActionBlock)(THKAttentionLoginAction loginAction);


/**
 关注按钮的样式
 带边框(border)都是背景透明
 带背景色(back)的无边框
 关注按钮样式请参考 https://docs.qq.com/sheet/DV0t2VlpnbVROY2NX?tab=f6t50d&_t=1606788908102
 */
typedef NS_ENUM(NSInteger, FocusButtonViewStyle) {
    FocusButtonViewStyle_Gray_Normal, //字体12  中黑  #333333 背景色：#F8FAFC 圆角：4px 尺寸（56*25px）
    FocusButtonViewStyle_Gray_Dark, //字体12  #ffffff 按钮背景颜色：#ffffff 不透明度 20% 尺寸（56*25px）
    FocusButtonViewStyle_Green_Large,//字体14px 中黑   #ffffff 背景颜色：#29D181  圆角：6px 尺寸（72*32px）
    FocusButtonViewStyle_Gray_Large, //字体14px 中黑   #333333 背景色：#F8FAFC   圆角：6px 尺寸（72*32px）
    FocusButtonViewStyle_Custom //自定义按钮状态，如果设置该值，则按钮样式由外部控制
};

/**
 关注类型
 */
typedef NS_ENUM(NSInteger, FocusType) {
    FocusType_User, //关注用户。默认值
    FocusType_Topic//关注话题
};


@interface THKFocusButtonView : UIButton
///是否禁止弹引导弹窗
@property (nonatomic, assign)   BOOL disableAlertView;
@property (nonatomic, assign)   NSInteger focusId; //关注的id，必须要设置该值.
@property (nonatomic, assign)   FocusType focusType; //关注类型，默认为FocusType_User
@property (nonatomic, assign)   FocusButtonViewStyle focusSyle; //设置类型，默认为FocusButtonViewStyle_Gray_Normal
@property (nonatomic, assign)   THKAttentionFollowStatus focusStatus;//当前按钮的关注状态,设置关注状态。0-未关注；1-已关注；2-互相关注
@property (nonatomic, assign)   BOOL hideForFollowed;//关注状态后是否要隐藏，某些场景下，由未关注变为关注状态时要隐藏次按钮，防止用户取消关注；默认为YES，如果关注后不需要隐藏，则要手动把这个值设置为NO

/**
 当style=FocusButtonViewStyle_Custom时，可以自定义按钮的属性
 注：不是改变THKFocusButtonView而是改变THKFocusButtonView.focusButton
 */
@property (nonatomic, strong, readonly)   UIButton *focusButton;

//关注按钮的回调事件，内部自动调用关注和取消关注并改变按钮的颜色
//无论调用接口结果如何，都会调用该block，并返回当前按钮的关注状态(focus)和操作是否成功(operate)。
//接口调用成功后会在收到通知时调用该block，接口调用失败不发通知，直接调用该block。即：无论点击按钮或是获取关注状态，操作成功后都是通过发通知来告知关注按钮，所以在外部使用时只要用这个block，不需要注册TPLNAttentionNotification通知.
//如果登录成功后是自己，则隐藏关注按钮，并返回THKAttentionFollowStatus_Hide
@property (nonatomic, copy) FocusButtonViewResultBlock followResultBlock;
@property (nonatomic, copy) FocusButtonViewScoreResultBlock followScoreResultBlock;//获取关注后增加的兔币积分，如果需要获取兔币积分，则调用这个block

//点击按钮前回调的block，会把当前关注状态和执行关注事件block返回给用户，由用户决定是否执行关注事件; 比如点击关注前需要弹框提示，用户点击确定后才调用接口，否则就不执行
@property (nonatomic, copy) FocusButtonViewWillClickBlock willClickBlock;

/// 登录操作的block
@property (nonatomic, copy) FocusButtonViewLoginActionBlock loginActionBlock;

/**
 关注和取消关注的埋点数据
 关注话题时，需要设置话题标题的字段: @{@"page_title":topicTitle?:@""};
 如果你不设置该值，则认为你在外面自己埋点了，这里不做处理。
 */
@property (nonatomic, copy) NSDictionary    *followEventGeParam;

/**
 初始化
 指定关注按钮的类型，默认为FocusButtonViewStyle_Gray_Normal
 关注人和关注话题调用的接口不一样
 param: style--按钮类型
 param: focusType--默认为FocusType_User
 */
- (instancetype)initWithStyle:(FocusButtonViewStyle)style focusType:(FocusType)focusType;

/**
 获取关注状态。0-未关注；1-已关注；2-互相关注
 调用获取状态的接口，如果不传入block，则通过通知返回查询 结果，只要用followResultBlock接收处理结果即可.
 注意：如果接口调用失败，则返回false，此时不应该使用返回的status来更新你的UI
 */
- (void)requestFollowStatusWithBlock:(FocusButtonViewResultBlock)resultBlock;

- (BOOL)getFocusButtonHiddenStatus:(THKAttentionFollowStatus)status;


@end
NS_ASSUME_NONNULL_END
