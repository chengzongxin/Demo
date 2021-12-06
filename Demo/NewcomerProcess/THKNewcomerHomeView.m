//
//  THKNewcomerHomeView.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/6.
//

#import "THKNewcomerHomeView.h"
#import "THKNewcomerAnimation.h"
@interface THKNewcomerHomeSelectStageCell : UITableViewCell
@property (nonatomic, strong) UIView *bgView;
/// icon
@property (nonatomic, strong) UIImageView *iconView;
/// title
@property (nonatomic, strong) UILabel  *titleLabel;
/// 箭头
@property (nonatomic, strong) UIImageView  *arrowView;

@end

@implementation THKNewcomerHomeSelectStageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(20);
        make.right.greaterThanOrEqualTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.centerY.equalTo(self.contentView);
    }];
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.cornerRadius = 10;
    }
    return _bgView;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"1A1C1A"];
        _titleLabel.font = UIFontRegular(18);
        _titleLabel.text = @"准备装修";
    }
    return _titleLabel;
}

- (UIImageView *)arrowView{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:UIImageMake(@"newcomer_dec_arrow")];
    }
    return _arrowView;
}


@end

static UIEdgeInsets const kContentInset = {0,20,0,20};

@interface THKNewcomerHomeView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) THKNewcomerHomeViewModel *viewModel;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *descLbl;

@property (nonatomic, strong) UIView *selectStageView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *tableTitles;

@property (nonatomic, copy) NSArray *tableIcons;

@end

@implementation THKNewcomerHomeView
@dynamic viewModel;

- (void)thk_setupViews{
    NSLog(@"THKNewcomerHomeView setup");
    self.userInteractionEnabled = YES;
    
    [self addSubview:self.bgImgView];
    [self addSubview:self.titleLbl];
    [self addSubview:self.descLbl];
    [self addSubview:self.selectStageView];
    [self addSubview:self.tableView];
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.left.right.equalTo(self).inset(kContentInset.left);
    }];
    
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(30);
        make.left.right.equalTo(self).inset(kContentInset.left);
    }];
    
    [self.selectStageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLbl.mas_bottom).offset(100);
        make.left.right.equalTo(self).inset(kContentInset.left);
        make.height.mas_equalTo(270);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLbl.mas_bottom).offset(100);
        make.left.right.equalTo(self).inset(kContentInset.left);
        make.height.mas_equalTo(270);
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.selectStageView tmui_shadowColor:UIColor.blackColor opacity:0.1 offsetSize:CGSizeZero corner:5];
}

- (void)bindViewModel{
    NSLog(@"THKNewcomerHomeView bindvm");
    
    _tableIcons = @[@"newcomer_prepare_stage",@"newcomer_decoration_stage",@"newcomer_renovate_stage"];
    _tableTitles = @[@"准备装修",@"正在装修",@"装修完毕"];
    
    [self.tableView reloadData];
}


#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THKNewcomerHomeSelectStageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKNewcomerHomeSelectStageCell.class) forIndexPath:indexPath];
    NSString *title = _tableTitles[indexPath.row];
    UIImage *placeImg = UIImageMake(_tableIcons[indexPath.row]);
//    [cell.iconView loadImageWithUrlStr:@"" placeHolderImage:placeImg];
    cell.iconView.image = placeImg;
    cell.titleLabel.text = title;
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == _tableTitles.count-1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
    }else{
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    THKNewcomerHomeSelectStageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
//    CAAnimation *anim = [THKNewcomerAnimation selectBgViewScale];
//    [self.selectStageView.layer addAnimation:anim forKey:nil];
    
    [self.selectStageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:10 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.selectStageView.frame = self.bounds;
        [self layoutSubviews];
    } completion:^(BOOL finished) {
        !self.tapItem?:self.tapItem(indexPath.row,cell.titleLabel);
    }];
    
    [tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = [obj tmui_convertRect:obj.bounds toViewOrWindow:tableView];
        CGPoint startP = CGRectGetCenter(rect);
        CGPoint endP = CGPointMake(startP.x, startP.y - idx * 90 / 2 - 200);
        CAAnimation *anim = [THKNewcomerAnimation cellDismiss:startP endPoint:endP];
        [obj.layer addAnimation:anim forKey:nil];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}


#pragma mark - Lazy load

- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithImage:UIImageMake(@"newcomer_dec_bg")];
    }
    return _bgImgView;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = @"Hi\n欢迎来到土巴兔~\n请选择你的装修阶段";
        _titleLbl.numberOfLines = 0;
    }
    return _titleLbl;
}

- (UILabel *)descLbl{
    if (!_descLbl) {
        _descLbl = [[UILabel alloc] init];
        _descLbl.text = @"为你推荐更合适的内容和装修服务";
    }
    return _descLbl;
}

- (UIView *)selectStageView{
    if (!_selectStageView) {
        _selectStageView = [[UIView alloc] init];
        _selectStageView.backgroundColor = UIColor.whiteColor;
        _selectStageView.layer.cornerRadius = 10;
    }
    return _selectStageView;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.layer.cornerRadius = 10;
        _tableView.layer.masksToBounds = NO;
        _tableView.clipsToBounds = NO;
        [_tableView registerClass:THKNewcomerHomeSelectStageCell.class forCellReuseIdentifier:NSStringFromClass(THKNewcomerHomeSelectStageCell.class)];
    }
    return _tableView;
}

@end
