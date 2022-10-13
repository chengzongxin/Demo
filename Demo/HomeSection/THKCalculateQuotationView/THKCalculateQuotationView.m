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
<UITableViewDelegate,UITableViewDataSource,TMUITextFieldDelegate>


@property (nonatomic, strong, readwrite) THKCalculateQuotationViewModel *viewModel;

@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UITableView *tableView;
/// 面积
@property (nonatomic, strong) TMUITextField *areaMeterTF;
/// 户型信息
@property (nonatomic, strong) TMUITextField *houseTypeTF;
/// 所在城市
@property (nonatomic, strong) TMUITextField *cityNameTF;

@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, strong) TMUIModalPresentationViewController *modalViewController;

@property (nonatomic, strong) TMUIWeakObjectContainer *weakModalVC;

@end

@implementation THKCalculateQuotationView
@dynamic viewModel;

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

- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self);
    [self.viewModel.refreshSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self.viewModel.errorMsgSignal subscribeNext:^(id  _Nullable x) {
        [TMToast toast:x];
    }];
    
    [self.viewModel.requestConfigCommand execute:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.view.layer tmui_setLayerShadow:[UIColor.blackColor colorWithAlphaComponent:0.06] offset:CGSizeMake(0, -5) alpha:1 radius:10 spread:10];
}

+ (void)showWithViewModel:(THKViewModel *)viewModel success:(void (^)(THKCalculateQuotationView * _Nonnull))confirmBlock cancelBlock:(void (^)(THKCalculateQuotationView * _Nonnull))cancelBlock{
    THKCalculateQuotationView *alert = [[THKCalculateQuotationView alloc] initWithViewModel:viewModel];
    [alert handleShowingConfirmBlock:confirmBlock cancelBlock:cancelBlock];
}

- (void)dismiss{
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)animated{
    @weakify(self);
    [self.modalViewController hideInView:TMUIHelper.topViewController.view animated:animated completion:^(BOOL finished) {
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
    modalViewController.contentViewMargins = UIEdgeInsetsMake(0, 0, tmui_tabbarHeight(), 0);
    // 以 UIWindow 的形式来展示
//    [modalViewController showWithAnimated:YES completion:nil];
    [modalViewController showInView:TMUIHelper.topViewController.view animated:YES completion:nil];
    
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


#pragma mark - Cell event
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.houseTypeTF) {
        [TMUIPickerView showPickerWithConfigBlock:^(TMUIPickerViewConfig * _Nonnull config) {
            config.type = TMUIPickerViewType_MultiColumn;
            config.title = @"请选择房屋户型";
        } numberOfColumnsBlock:^NSInteger(UIPickerView * _Nonnull pickerView) {
            return self.viewModel.houseTypeArray.count;
        } numberOfRowsBlock:^NSInteger(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSArray<NSNumber *> * _Nullable selectRows) {
            return self.viewModel.houseTypeArray[columnIndex].count;
        } scrollToRowBlock:^(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSInteger rowIndex, NSArray<NSNumber *> * _Nonnull selectRows) {
            
        } textForRowBlock:^NSString * _Nullable(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSInteger rowIndex, NSArray<NSNumber *> * _Nonnull selectRows) {
            return self.viewModel.houseTypeArray[columnIndex][rowIndex].itemName;
        } selectRowBlock:^(NSArray<TMUIPickerIndexPath *> * _Nonnull indexPaths, NSArray<NSString *> * _Nonnull texts) {
            textField.text = [texts tmui_reduce:^id _Nonnull(NSString * _Nonnull accumulator, NSString * _Nonnull item) {
                return [NSString stringWithFormat:@"%@%@",accumulator,item];
            } initial:@""];
        }];
    }else if (textField == self.cityNameTF) {
        if (self.viewModel.cityModels.count == 0) {
            return NO;
        }
        NSArray <THKCalcQuataConfigCityListItem *> * arr = self.viewModel.cityModels;
        [TMUIPickerView showPickerWithConfigBlock:^(TMUIPickerViewConfig * _Nonnull config) {
            config.type = TMUIPickerViewType_MultiColumnConcatenation;
        } numberOfColumnsBlock:^NSInteger(UIPickerView * _Nonnull pickerView) {
            return 2;
        } numberOfRowsBlock:^NSInteger(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSArray<NSNumber *> * _Nonnull selectRows) {
            if (columnIndex == 0) {
                return arr.count;
            }else{
                NSInteger idx = selectRows.firstObject.integerValue;
                if (idx >= arr.count) {
                    idx = 0;
                }
                THKCalcQuataConfigCityListItem *cityModel = [arr tmui_safeObjectAtIndex:idx];
                return cityModel.townList.count;
            }
        } scrollToRowBlock:^(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSInteger rowIndex, NSArray<NSNumber *> * _Nonnull selectRows) {
            if (columnIndex == 0) {
                [pickerView reloadComponent:1];
                [pickerView selectRow:0 inComponent:1 animated:YES];
            }
        } textForRowBlock:^NSString * _Nullable(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSInteger rowIndex, NSArray<NSNumber *> * _Nonnull selectRows) {
            if (columnIndex == 0) {
                THKCalcQuataConfigCityListItem *cityModel = [arr tmui_safeObjectAtIndex:rowIndex];
                return cityModel.cityName?:@"";
            }else{
                NSInteger idx = selectRows.firstObject.integerValue;
                if (idx >= arr.count) {
                    idx = 0;
                }
                THKCalcQuataConfigCityListItem *cityModel = [arr tmui_safeObjectAtIndex:idx];
                return cityModel.townList[rowIndex].townName?:@"";
            }
        } selectRowBlock:^(NSArray<TMUIPickerIndexPath *> * _Nonnull indexPaths, NSArray<NSString *> * _Nonnull texts) {
//            if (selectBlock) {
                TMUIPickerIndexPath *provinceIdxPath = indexPaths.firstObject;
                TMUIPickerIndexPath *cityIdxPath = indexPaths.lastObject;
                THKCalcQuataConfigCityListItem *provinceModel = [arr tmui_safeObjectAtIndex:provinceIdxPath.row];
                THKCalcQuataConfigTownListItem *cityModel = provinceModel.townList[cityIdxPath.row];
//                selectBlock(cityModel,indexPaths);
                textField.text = [NSString stringWithFormat:@"%@ %@",provinceModel.cityName,cityModel.townName];
//            }
        }];
    }
    return NO;
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
            tf.font = UIFontSemibold(15);
            tf.placeholder = @"请输入";
            tf.textAlignment = NSTextAlignmentLeft;
            tf.placeholderColor = UIColorPlaceholder;
            tf.keyboardType = UIKeyboardTypeNumberPad;
            [cell.rightContentView addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_greaterThanOrEqualTo(-54);
                make.centerY.equalTo(cell.rightContentView);
                make.height.mas_equalTo(20);
                make.left.mas_equalTo(0);
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
            tf.font = UIFontSemibold(15);
            tf.placeholder = @"请填写";
            tf.textAlignment = NSTextAlignmentLeft;
            tf.placeholderColor = UIColorPlaceholder;
            tf.delegate = self;
            [cell.rightContentView addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_greaterThanOrEqualTo(-54);
                make.centerY.equalTo(cell.rightContentView);
                make.height.mas_equalTo(20);
                make.left.mas_equalTo(0);
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
            tf.font = UIFontSemibold(15);
            tf.placeholder = @"请填写";
            tf.textAlignment = NSTextAlignmentLeft;
            tf.placeholderColor = UIColorPlaceholder;
            tf.delegate = self;
            [cell.rightContentView addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_greaterThanOrEqualTo(-54);
                make.centerY.equalTo(cell.rightContentView);
                make.height.mas_equalTo(20);
                make.left.mas_equalTo(0);
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
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
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
