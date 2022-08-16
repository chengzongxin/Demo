//
//  THKOnlineDesignUploadHouseVC.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKOnlineDesignUploadHouseVC.h"
#import "THKOnlineDesignUploadHouseHeader.h"
#import "THKOnlineDesignUploadHouseCell.h"

@interface THKOnlineDesignUploadHouseVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) THKOnlineDesignUploadHouseVM *viewModel;

@property (nonatomic, strong) THKOnlineDesignUploadHouseHeader *header;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THKOnlineDesignUploadHouseVC
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.thk_title = @"添加我家信息";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(THKNavBarInsets);
    }];
}


#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THKOnlineDesignUploadHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKOnlineDesignUploadHouseCell.class) forIndexPath:indexPath];
    [self customRightViewWithIndex:indexPath.row cell:cell];
    return cell;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}


#pragma mark - Private
- (void)customRightViewWithIndex:(NSInteger)idx cell:(THKOnlineDesignUploadHouseCell *)cell{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.rightContentView tmui_removeAllSubviews];
    cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    switch (idx) {
        case 0:
        {
            cell.titleLbl.text = @"小区名称";
            
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
        }
            break;
        case 1:
        {
            cell.titleLbl.text = @"户型信息";
            
            UIButton *btn = [[UIButton alloc] init];
            btn.tmui_text = @"请选择";
            btn.tmui_titleColor = UIColorPlaceholder;
            btn.tmui_font = UIFont(14);
            [cell.rightContentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(cell.rightContentView);
                make.right.mas_equalTo(-54);
            }];
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
                [TMUIPickerView showSinglePickerWithConfigBlock:^(TMUIPickerViewConfig * _Nonnull config) {
                    config.title = @"请选择户型";
                } texts:@[@"一居室",@"二居室",@"三居室",@"四居室"] selectBlock:^(NSInteger idx, NSString * _Nonnull text) {
                    x.tmui_text = text;
                }];
            }];
            
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
            cell.titleLbl.text = @"房屋面积";
            
            TMUITextField *tf = [[TMUITextField alloc] init];
            tf.font = UIFont(14);
            tf.placeholder = @"请输入";
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
            
            UILabel *lbl = [UILabel new];
            lbl.textColor = UIColorDark;
            lbl.font = UIFontMedium(14);
            lbl.text = @"㎡";
            [cell.rightContentView addSubview:lbl];
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.rightContentView);
                make.centerY.equalTo(cell.rightContentView);
            }];
        }
            break;
            
        default:
            break;
    }
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
        [_tableView registerClass:THKOnlineDesignUploadHouseCell.class forCellReuseIdentifier:NSStringFromClass(THKOnlineDesignUploadHouseCell.class)];
        _tableView.tableHeaderView = self.header;
    }
    return _tableView;
}

- (THKOnlineDesignUploadHouseHeader *)header{
    if (!_header) {
        _header = [[THKOnlineDesignUploadHouseHeader alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, 214)];
    }
    return _header;
}

@end
