//
//  TMCardComponentCellBottomView.m
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "TMCardComponentCellBottomView.h"
#import "TMCardComponentMacro.h"
#import "TMCardComponentUIConfigDefine.h"
#import "TMCardComponentTool.h"
#import <Masonry/Masonry.h>
#import "TUserAvatarView.h"
//#import "TInteractiveToolBar.h"

@interface TMCardComponentCellBottomView()
@property (nonatomic, strong) UIView *contentBoxView;///< 用户信息块视图
@property (nonatomic, strong) TUserAvatarView *avatarView;///< 用户头像视图 16x16
@property (nonatomic, strong) UILabel *nickNameLbl;///< 用户昵称视图

///MARK: 以下两UI的显示状态为互斥，对应nickNameLbl的trailing约束也需要动态的根据下面的显示UI进行重新约束更新
@property (nonatomic, strong)UIView *interactiveToolBar;///< 交互按钮,当前默认对应交互类型为点赞

@property (nonatomic, strong)UIImageView *rightIconView;///< 当为观众类型时，文本左侧会显示一个头像icon,
@property (nonatomic, strong) UILabel *rightTitleLbl;///< 当为无交互纯文字或icon+文本显示时用

@property (nonatomic, strong)NSObject<TMCardComponentCellDataProtocol> *data;
@end

@implementation TMCardComponentCellBottomView

TMCardComponentPropertyLazyLoad(UIView, contentBoxView);
TMCardComponentPropertyLazyLoad(UILabel, nickNameLbl);
TMCardComponentPropertyLazyLoad(UILabel, rightTitleLbl);
TMCardComponentPropertyLazyLoad(UIImageView, rightIconView);

- (TUserAvatarView *)avatarView {
    if (!_avatarView) {
        NSInteger size = TMCardUIConfigConst_bottomBoxViewInnerAvatarSize;
        _avatarView = [[TUserAvatarView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
        _avatarView.identityIconSize = CGSizeMake(size/2, size/2);
    }
    return _avatarView;
}

//observer 的监控生命周期空函数，当调用此函数表示相关旧的observer失效
- (void)prepareForReuse {}

- (void)updateUI:(NSObject<TMCardComponentCellDataProtocol> * _Nullable)cellData {
    [self prepareForReuse];
    
    self.data = cellData;
    
    //加载头像及设置默认头像占位图,加载认证icon
    BOOL isNormalAuthorAvatar = NO;
    BOOL showIdentifyIcon = NO;
    //普通无交互的类型时，可能不是作者头像而是其它的Icon，此时显示占位头像不合适，当为可交互类型时，头像一般肯定是用户头像，才可以用占位头像和显示认证icon
    if (self.data.interaction.type != TMCardComponentDataInteractionInfoTypeNormal) {
        isNormalAuthorAvatar = YES;
        if (self.data.bottom.subIcon.length > 0) {
            showIdentifyIcon = YES;
        }
    }
        
    BOOL hasAvaliableTitle = self.data.bottom.title.length > 0 ? YES : NO;
    BOOL hasAvaliableImg = self.data.bottom.imgUrl.length > 0 ? YES : NO;
    BOOL canShowAvatarPlaceHolderImg = (hasAvaliableTitle || hasAvaliableImg);
    //当昵称和头像数据都为空时，不显示头像的占位图
    [TMCardComponentTool loadNetImageInImageView:self.avatarView.avatarImgView
                     imUrl:self.data.bottom.imgUrl
                          finishPlaceHolderImage:(isNormalAuthorAvatar && canShowAvatarPlaceHolderImg) ? [TMCardComponentTool authorAvatarPlaceHolderImage] : nil];
    self.avatarView.identityIconView.hidden = !showIdentifyIcon;
    [TMCardComponentTool loadNetImageInImageView:self.avatarView.identityIconView
                                           imUrl:self.data.bottom.subIcon
                          finishPlaceHolderImage:nil];
        
    //更新文本数据
    self.nickNameLbl.text = cellData.bottom.title;
    
    //更新右侧子视图显示及约束
    BOOL canInteraction = NO;
    NSString *showTitle = nil;
    NSString *rightIconName = nil;
    if (cellData.interaction.type == TMCardComponentDataInteractionInfoTypePraise) {
        //更新交互toolbar绑定的数据模型对象
//        TInteractiveModel *tModel = [self interactionModelFromData:cellData];
//        canInteraction = tModel ? YES : NO;
//        self.interactiveToolBar.interactiveModel = tModel;
        
        //不需要再单独处理交互数据对应的UI绑定刷新逻辑
        //[self kvoObserverInteractionDataForUIUpdateWithCellData:cellData];
        
    }else if (cellData.interaction.type == TMCardComponentDataInteractionInfoTypeNormal) {
        showTitle = cellData.interaction.text;
    }else if (cellData.interaction.type == TMCardComponentDataInteractionInfoTypeWatch) {
        //观看人数的描述串
        showTitle = cellData.interaction.text;
        rightIconName = @"icon_live_watch_person";
    }
    
//    self.interactiveToolBar.hidden = !canInteraction;
    self.rightTitleLbl.hidden = canInteraction;
    self.rightTitleLbl.text = showTitle.length > 0 ? showTitle : nil;
    if (rightIconName.length > 0) {
        self.rightIconView.hidden = NO;
        self.rightIconView.image = [UIImage imageNamed:rightIconName];
        [self.rightIconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(14);
        }];
    }else {
        self.rightIconView.hidden = YES;
        self.rightIconView.image = nil;
        [self.rightIconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
    //显示内容不同时相关约束需要相应更新
    [self.nickNameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarView.mas_trailing).mas_offset(4);
        make.centerY.mas_equalTo(self.contentBoxView.mas_centerY);
        if (canInteraction) {
//            make.trailing.mas_equalTo(self.interactiveToolBar.mas_leading).mas_offset(-14);
        }else {
            make.trailing.mas_equalTo(self.rightIconView.mas_leading).mas_offset(showTitle.length > 0 ? -12 : 2);
        }
    }];
}

//- (TInteractiveModel *_Nullable)interactionModelFromData:(NSObject<TMCardComponentCellDataProtocol> *)data {
//    NSString *moduleCode = data.interaction.moduleCode;
//    NSString *objId = data.content.Id;
//
////    NSAssert(moduleCode.length > 0, @"moduleCode can not be nil or empty.");
////    NSAssert(objId.length > 0, @"objId can not be nil or empty.");
//#if DEBUG
//    if (moduleCode.length == 0) {
//        NSLog(@"moduleCode can not be nil or empty.");
//    }
//    if (objId.length == 0) {
//        NSLog(@"objId can not be nil or empty.");
//    }
//#endif
//
//    if (moduleCode.length > 0 &&
//        objId.length > 0) {
//        TInteractiveModel *interactiveModel = [TInteractiveModel modelWithModuleCode:moduleCode objId:[objId integerValue]];
//        interactiveModel.praiseCount = data.interaction.num;
//        interactiveModel.isPraise = data.interaction.status;
//        //8.8 add 喜欢交互增加相关业务数据上报
//        interactiveModel.godeyeProperties = data.reportDicInfo;
//        return interactiveModel;
//    }
//    return nil;
//}

- (void)kvoObserverInteractionDataForUIUpdateWithCellData:(NSObject<TMCardComponentCellDataProtocol> *)cellData {
    //NOTE: 因交互状态在交互组件interactiveToolBar 内部已作相关数据及UI的同步操作，这里不需要再单独手动监控并数据来刷新UI
    //互动数据与UI刷新绑定监控处理逻辑
    /*
    @weakify(self, cellData);
    [[[RACObserve(cellData, interaction.status) distinctUntilChanged] takeUntil:[self rac_signalForSelector:@selector(prepareForReuse)]] subscribeNext:^(id  _Nullable x) {
        @strongify(self, cellData);
        if ([self.data isEqual:cellData]) {
            //更新互动UI状态
        }
    }];
    [[[RACObserve(cellData, interaction.num) distinctUntilChanged] takeUntil:[self rac_signalForSelector:@selector(prepareForReuse)]] subscribeNext:^(id  _Nullable x) {
        @strongify(self, cellData);
        if ([self.data isEqual:cellData]) {
            //更新互动UI显示数字
        }
    }];
    */
}

#pragma mark - load UIs
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    self.clipsToBounds = YES;
    [self addSubview:self.contentBoxView];
    
    [self.contentBoxView addSubview:self.avatarView];
    [self.contentBoxView addSubview:self.nickNameLbl];
    [self.contentBoxView addSubview:self.interactiveToolBar];
    [self.contentBoxView addSubview:self.rightTitleLbl];
    [self.contentBoxView addSubview:self.rightIconView];
    
    self.rightIconView.hidden = YES;
    self.rightIconView.clipsToBounds = YES;
    self.rightIconView.contentMode = UIViewContentModeScaleAspectFit;
    
    //layout constraint
    [self.contentBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(TMCardUIConfigConst_bottomBoxViewContentContainerHeight);
        make.bottom.mas_equalTo(-TMCardUIConfigConst_bottomBoxViewInnerBottomMargin);
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(TMCardUIConfigConst_contentLeftRightMargin);
        make.width.height.mas_equalTo(TMCardUIConfigConst_bottomBoxViewInnerAvatarSize);
        make.centerY.mas_equalTo(self.contentBoxView.mas_centerY);
    }];
    
    [self.rightTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-TMCardUIConfigConst_contentLeftRightMargin);
        make.centerY.mas_equalTo(self.contentBoxView.mas_centerY);
    }];
    //12x11
    [self.rightIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.rightTitleLbl.mas_leading).mas_offset(-3);
        make.centerY.mas_equalTo(self.rightTitleLbl.mas_centerY);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(0);//初始时icon宽度给0
    }];
    
    [self.interactiveToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-TMCardUIConfigConst_contentLeftRightMargin);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarView.mas_trailing).mas_offset(4);
        make.centerY.mas_equalTo(self.contentBoxView.mas_centerY);
        make.trailing.mas_equalTo(self.rightIconView.mas_leading).mas_offset(-12);
    }];
    
    //设置相关约束优先级，让右测titleLbl优先显示完整, nickNameLbl显示可被自动压缩
    [self.rightTitleLbl setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightTitleLbl setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    //
    self.nickNameLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    self.nickNameLbl.textColor = UIColorHexString(@"666666");
    
    UIFont *font = [UIFont fontWithName:@"DIN Alternate" size:12];
    if (!font) {
        font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    }
    self.rightTitleLbl.font = font;
    self.rightTitleLbl.textColor = UIColorHexString(@"999999");
            
#if DEBUG
    MASAttachKeys(self.contentBoxView, self.avatarView, self.nickNameLbl, self.rightTitleLbl);
#endif
    
}

//- (TInteractiveToolBar *)interactiveToolBar {
//    if (!_interactiveToolBar) {
//        _interactiveToolBar = [[TInteractiveToolBar alloc] initWithStyle:TInteractiveToolBarStyle_CellPraise];
//        @weakify(self);
//        [_interactiveToolBar setPraiseModuleCodeBlock:^(NSUInteger praiseCount, BOOL isPraise, NSString * _Nonnull moduleCode, NSUInteger objId) {
//            @strongify(self);
//            NSString *data_moduleCode = self.data.interaction.moduleCode;
//            NSString *data_objId = self.data.content.Id;
//
//            if ([moduleCode isEqualToString:data_moduleCode] && [data_objId integerValue] == objId) {
//                //同步点赞数据及状态
//                self.data.interaction.num = praiseCount;
//                self.data.interaction.status = isPraise;
//            }
//        }];
//        //8.12 add: 个人主页发版后，个人动态页有未审核通过的内容时，点赞操作不可行且需要进行相关的显示
//        [_interactiveToolBar setBlockCanPraiseTap:^bool{
//            @strongify(self);
//            if (self.data.content.auditStatus == 2 ||
//                self.data.content.auditStatus == 3) {
//                NSString *tipMsg = [NSString stringWithFormat:@"动态%@啦，无法进行互动", self.data.content.auditStatus == 2 ? @"违规" : @"被屏蔽"];
//                [TMToast toast:tipMsg];
//
//                return false;
//            }
//
//            return true;
//        }];
//    }
//    return _interactiveToolBar;
//}

@end
