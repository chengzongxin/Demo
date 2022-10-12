//
//  THKCalculateQuotationView.m
//  Demo
//
//  Created by 程宗鑫 on 2022/10/12.
//

#import "THKCalculateQuotationView.h"
#import "THKCalculateQuotationCell.h"
#import "THKCalculateQuotationSelectButtonView.h"

@interface THKCalculateQuotationView ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UITableView *tableView;
/// 面积
@property (nonatomic, strong) TMUITextField *areaMeterTF;
/// 所在城市
@property (nonatomic, strong) TMUITextField *houseTypeTF;
/// 所在城市
@property (nonatomic, strong) TMUITextField *cityNameTF;

@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, strong) TMUIModalPresentationViewController *modalViewController;

@property (nonatomic, strong) TMUIWeakObjectContainer *weakModalVC;

@end

@implementation THKCalculateQuotationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubview];
    }
    return self;
}


- (void)setupSubview{
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.view];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commitButton];
    
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(357);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(16);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(20);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-tmui_safeAreaBottomInset());
    }];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.view.layer tmui_setLayerShadow:[UIColor.blackColor colorWithAlphaComponent:0.06] offset:CGSizeMake(0, -5) alpha:1 radius:10 spread:10];
}

+ (void)showAlertWithConfirmBlock:(void (^)(THKCalculateQuotationView * _Nonnull))confirmBlock cancelBlock:(void (^)(THKCalculateQuotationView * _Nonnull))cancelBlock{
    THKCalculateQuotationView *alert = [THKCalculateQuotationView new];
    [alert handleShowingConfirmBlock:confirmBlock cancelBlock:cancelBlock];
}

- (void)dismiss{
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)animated{
    @weakify(self);
    [self.modalViewController hideInView:TMUI_AppWindow animated:animated completion:^(BOOL finished) {
        @strongify(self);
        self.modalViewController.contentView = nil;
    }];
}


- (void)commit:(UIButton *)btn{
    
}


- (void)handleShowingConfirmBlock:(void (^)(THKCalculateQuotationView * _Nonnull))confirmBlock cancelBlock:(void (^)(THKCalculateQuotationView * _Nonnull))cancelBlock{
    
    
    
    TMUIModalPresentationViewController *modalViewController = [[TMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = self;
    modalViewController.dimmingView.backgroundColor = UIColorWhite;
    modalViewController.contentViewMargins = UIEdgeInsetsZero;
    // 以 UIWindow 的形式来展示
//    [modalViewController showWithAnimated:YES completion:nil];
    [modalViewController showInView:TMUI_AppWindow animated:YES completion:nil];
    
    @weakify(self);
//    [self.cancleBtn tmui_addActionBlock:^(NSInteger tag) {
//        @strongify(self);
//        cancelBlock(self);
//    } forControlEvents:UIControlEventTouchUpInside];

    [self.commitButton tmui_addActionBlock:^(NSInteger tag) {
        @strongify(self);
        confirmBlock(self);
    } forControlEvents:UIControlEventTouchUpInside];
    
    modalViewController.willHideByDimmingViewTappedBlock = ^{
        @strongify(self);
        [self dismiss:NO];
    };
    
    
    self.modalViewController = modalViewController;
//    TMUIWeakObjectContainer *weakModalVC = [[TMUIWeakObjectContainer alloc] initWithObject:modalViewController];
}


#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THKCalculateQuotationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKCalculateQuotationCell.class) forIndexPath:indexPath];
    [self customRightViewWithIndex:indexPath.row cell:cell];
    return cell;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


#pragma mark - Private
- (void)customRightViewWithIndex:(NSInteger)idx cell:(THKCalculateQuotationCell *)cell{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.rightContentView tmui_removeAllSubviews];
    cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    switch (idx) {
            
        case 0:
        {
            cell.titleLbl.text = @"房屋面积";
            
            TMUITextField *tf = [[TMUITextField alloc] init];
            tf.font = UIFont(14);
            tf.placeholder = @"请输入";
            tf.textAlignment = NSTextAlignmentRight;
            tf.placeholderColor = UIColorPlaceholder;
            tf.keyboardType = UIKeyboardTypeNumberPad;
            [cell.rightContentView addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-54);
//                make.top.bottom.equalTo(cell.rightContentView);
                make.centerY.equalTo(cell.rightContentView);
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(103);
            }];
            
            UILabel *lbl = [UILabel new];
            lbl.textColor = UIColorDark;
            lbl.font = UIFontMedium(14);
            lbl.text = @"㎡";
            [cell.rightContentView addSubview:lbl];
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.rightContentView);
                make.centerY.equalTo(cell.rightContentView);
            }];
            
            self.areaMeterTF = tf;
        }
            break;
        case 1:
        {
            cell.titleLbl.text = @"户型信息";
            
            
            TMUITextField *tf = [[TMUITextField alloc] init];
            tf.font = UIFont(14);
            tf.placeholder = @"请填写";
            tf.textAlignment = NSTextAlignmentRight;
            tf.placeholderColor = UIColorPlaceholder;
            [cell.rightContentView addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-54);
//                make.top.bottom.equalTo(cell.rightContentView);
                make.centerY.equalTo(cell.rightContentView);
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(103);
            }];
            
            self.houseTypeTF = tf;
            
            UIImageView *imgV = [[UIImageView alloc] initWithImage:UIImageMake(@"od_arrow_black_icon")];
            [cell.rightContentView addSubview:imgV];
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.rightContentView);
                make.centerY.equalTo(cell.rightContentView);
            }];
        }
            break;
        case 2:
        {
            cell.titleLbl.text = @"所在城市";
            
            TMUITextField *tf = [[TMUITextField alloc] init];
            tf.font = UIFont(14);
            tf.placeholder = @"请填写";
            tf.textAlignment = NSTextAlignmentRight;
            tf.placeholderColor = UIColorPlaceholder;
            [cell.rightContentView addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-54);
//                make.top.bottom.equalTo(cell.rightContentView);
                make.centerY.equalTo(cell.rightContentView);
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(103);
            }];
            
            self.cityNameTF = tf;
            
            UIImageView *imgV = [[UIImageView alloc] initWithImage:UIImageMake(@"od_arrow_black_icon")];
            [cell.rightContentView addSubview:imgV];
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.rightContentView);
                make.centerY.equalTo(cell.rightContentView);
            }];
        }
            break;
        case 3:
        {
            cell.titleLbl.text = @"房屋类型";
            
            THKCalculateQuotationSelectButtonView *buttonView = [THKCalculateQuotationSelectButtonView new];
            [cell.rightContentView addSubview:buttonView];
            [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 0));
            }];
            buttonView.datas = @[@"新房装修",@"旧房改造"];
            buttonView.tapItem = ^(NSString * _Nonnull text) {
                NSLog(@"%@",text);
            };
            
        }
            break;;
            
        default:
            break;
    }
}



- (UIView *)view{
    if (!_view) {
        _view = [UIView new];
        _view.backgroundColor = UIColorWhite;
        _view.layer.cornerRadius = 16;
    }
    return _view;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorWhite;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:THKCalculateQuotationCell.class forCellReuseIdentifier:NSStringFromClass(THKCalculateQuotationCell.class)];
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}


- (UIButton *)commitButton{
    if (!_commitButton) {
        _commitButton = [TMUIButton tmui_button];
        _commitButton.backgroundColor = UIColorGreen;
        _commitButton.tmui_titleColor = UIColorWhite;
        _commitButton.cornerRadius = 8;
        _commitButton.tmui_font = UIFontMedium(18);
        _commitButton.tmui_text = @"立即发送";
        [_commitButton tmui_addTarget:self action:@selector(commit:)];
    }
    return _commitButton;
}

- (CGSize)sizeThatFits:(CGSize)size{
    return UIScreen.mainScreen.bounds.size;
}



@end
