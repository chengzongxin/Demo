//
//  TMCardComponentBaseAbstractCell.m
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "TMCardComponentBaseAbstractCell.h"
#import "AppDelegate.h"
@interface TMCardComponentBaseAbstractCell()
@property (nonatomic, strong)NSObject<TMCardComponentCellDataProtocol> *data;
@property (nonatomic, strong)TMCardComponentBaseAbstractCellCoverImageView *coverImgView;
@property (nonatomic, strong)UIView *coverImgViewMaskLayerView;///< 封面图上显示的子内容底部蒙层视图，默认为clearColor, 子类可根据实际需要配置显示的颜色
@property (nonatomic, strong)TMCardComponentCellBottomView *bottomView;
@property (nonatomic, strong)UILongPressGestureRecognizer *longPressGesture;
@end

@implementation TMCardComponentBaseAbstractCell

TMCardComponentPropertyLazyLoad(TMCardComponentCellBottomView, bottomView);
TMCardComponentPropertyLazyLoad(TMCardComponentBaseAbstractCellCoverImageView, coverImgView);
TMCardComponentPropertyLazyLoad(UIView, coverImgViewMaskLayerView);



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubUIElement];
#if DEBUG
        [self addLongPressGesture];
#endif
        
    }
    return self;
}

- (void)loadSubUIElement {
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    //v8.10 调整 整体圆角半径6pt
    self.layer.cornerRadius = TMCardUIConfigConst_cardCornerRadius;
    self.clipsToBounds = YES;
    
    self.contentView.clipsToBounds = YES;
    [self.contentView addSubview:self.coverImgView];
    self.coverImgView.contentMode = UIViewContentModeScaleAspectFill;
    //v8.10 调整 封面图底部圆角半径为2pt，因其被卡片包含，故可直接设置全圆角半径为2pt
    self.coverImgView.layer.cornerRadius = TMCardUIConfigConst_coverCornerRadius;
    self.coverImgView.clipsToBounds = YES;
    self.coverImgView.backgroundColor = THKColor_Sub_EmptyAreaBackgroundColor;
    
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0).priorityLow();
    }];
    
    [self.coverImgView addSubview:self.coverImgViewMaskLayerView];
    self.coverImgViewMaskLayerView.clipsToBounds = YES;
    self.coverImgViewMaskLayerView.userInteractionEnabled = NO;
    self.coverImgViewMaskLayerView.backgroundColor = [self coverImgViewMaskLayerViewColor];
    [self.coverImgViewMaskLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    //
    [self.contentView addSubview:self.bottomView];
    self.bottomView.clipsToBounds = YES;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
            
#if DEBUG
    MASAttachKeys(self, self.contentView, self.coverImgView, self.bottomView);
#endif
    
}

- (UIColor *_Nullable)coverImgViewMaskLayerViewColor {
    return nil;
}

- (void)updateCoverImgViewMaskLayerViewColor {
    self.coverImgViewMaskLayerView.backgroundColor = [self coverImgViewMaskLayerViewColor];
}

- (void)updateUIElement:(NSObject<TMCardComponentCellDataProtocol> *)data {
    self.data = data;
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(data.layout_bottomViewHeight);
    }];
    [self.coverImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(data.layout_coverShowHeight).priorityHigh();
    }];
    [self.bottomView updateUI:data];
    
    //8.13 add-fix-logic: 底部整体视图若高度比真实要展示的高度值小则表示作为高度补差用，此时内容视图应该隐藏
    if (data.layout_bottomViewHeight < TMCardUIConfigConst_bottomBoxViewShowHeight) {
        self.bottomView.hidden = YES;
    }else {
        self.bottomView.hidden = NO;
    }
    //加载图片
    [TMCardComponentTool loadNetImageInImageView:self.coverImgView
                                           imUrl:data.cover.imgUrl
                          finishPlaceHolderImage:nil];
#if DEBUG
    [self removeCellLongPressGestureWithVcClass:nil];
#endif
    
}

#pragma mark - other
- (void)prepareForReuse {
    [super prepareForReuse];
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    [self.coverImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0).priorityHigh();
    }];
    self.coverImgView.image = nil;
    self.data = nil;
}

- (UIColor *)randomColor {
    float (^radomFloat)(void) = ^ {
        return arc4random()%255 *1.0f/255.0f;
    };
    return [UIColor colorWithRed:radomFloat() green:radomFloat() blue:radomFloat() alpha:0.5];
}



#if DEBUG
-(void)removeCellLongPressGestureWithVcClass:(Class)vcClass{
    if (self.longPressGesture && ([self.viewController isKindOfClass:NSClassFromString(@"THKHomeItemViewController")] || [vcClass isKindOfClass:NSClassFromString(@"THKHomeItemViewController")])) {
        [self.longPressGesture removeTarget:self action:@selector(showDataAction:)];
        [self removeGestureRecognizer:self.longPressGesture];
        self.longPressGesture = nil;
    }
}
// 添加长按手势
- (void)addLongPressGesture {
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showDataAction:)];
    self.longPressGesture = longPressGesture;
    [self addGestureRecognizer:longPressGesture];
}

-(void)showDataAction:(UIGestureRecognizer *)gesture{
    if (gesture.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *string = [self responseStringFromDic:[self.data mj_keyValues]];
    //修改message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular], NSForegroundColorAttributeName:THKColor_333333}];
   [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)responseStringFromDic:(NSDictionary*)dic
{
    NSString *string = nil;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    }
    if (!string) {
        string = dic.description;
    }
    return string;
}

#endif
@end
