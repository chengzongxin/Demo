//
//  THKDecorationCompareImageView.m
//  Demo
//
//  Created by Joe.cheng on 2022/10/28.
//

#import "THKDecorationCompareImageView.h"
#import "IrregularBtn.h"
#define kViewWidth(View) CGRectGetWidth(View.frame)
#define kViewHeight(View) CGRectGetHeight(View.frame)

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface THKDecorationCompareImageView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) IrregularBtn *leftImgBtn;

@property (nonatomic, strong) IrregularBtn *rightImgBtn;

@property (nonatomic, strong) UIImageView *vsIcon;

@property (nonatomic, strong) UILabel *leftLbl;

@property (nonatomic, strong) UILabel *rightLbl;

@end

@implementation THKDecorationCompareImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}


- (void)setupSubviews{
    self.space = 8;
    self.degree = 75;
    self.isRightSperateStyle = YES;
    [self addSubview:self.contentView];
    [self addSubview:self.vsIcon];
    [self addSubview:self.leftLbl];
    [self addSubview:self.rightLbl];
    
    [self.vsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(10);
        make.centerX.equalTo(self).multipliedBy(0.5);
        make.size.mas_equalTo(CGSizeMake(43, 20));
    }];
    
    [self.rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(10);
        make.centerX.equalTo(self).multipliedBy(1.5);
        make.size.mas_equalTo(CGSizeMake(43, 20));
    }];
    
    [self setupCompareView];
}


- (void)btnAction:(UIButton *)btn{
    NSLog(@"%@",btn);
}

- (void)setImgs:(NSArray<NSString *> *)imgs{
    _imgs = imgs;
    
    [self.leftImgBtn setBackgroundImageWithURL:[NSURL URLWithString:imgs.firstObject] forState:UIControlStateNormal options:0];
    [self.rightImgBtn setBackgroundImageWithURL:[NSURL URLWithString:imgs.lastObject] forState:UIControlStateNormal options:0];
}

- (void)setupCompareView{
    [self setupLeftImgBtn];
    [self setupRightImgBtn];
}

//右斜边梯形
- (void)setupLeftImgBtn
{
    
    CGFloat space = self.space;
    CGRect frame = self.contentView.bounds;
    CGFloat fullW = frame.size.width;
    CGFloat fullH = frame.size.height;
    CGFloat diff = fullH / tanf(DEGREES_TO_RADIANS(self.degree));
    CGFloat shortX = (fullW - diff - space) / 2;
    CGFloat btnW = shortX + diff;
    
    IrregularBtn * btn = [IrregularBtn buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = UIColorRed;
    frame.size.width = btnW;
    btn.frame = frame;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setBackgroundImageWithURL:[NSURL URLWithString:@"https://cdn.pixabay.com/photo/2020/03/31/19/20/dog-4988985_1280.jpg"] forState:UIControlStateNormal options:0];
    // 添加路径关键点array
    NSMutableArray *pointArray = [NSMutableArray array];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(0.f, 0.f))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(0.f, kViewHeight(btn)))];
    if (self.isRightSperateStyle) {
        [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn), btn.frame.size.height))];
        [pointArray addObject:NSStringFromCGPoint(CGPointMake(shortX, 0.f))];
    }else{
        [pointArray addObject:NSStringFromCGPoint(CGPointMake(shortX, btn.frame.size.height))];
        [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn), 0.f))];
    }
    
    btn.cornerPointArray = [pointArray mutableCopy];
    
    self.leftImgBtn = btn;
    [self.contentView addSubview:btn];
}

- (void)setupRightImgBtn{
    CGFloat space = self.space;
    CGRect frame = self.contentView.bounds;
    CGFloat fullW = frame.size.width;
    CGFloat fullH = frame.size.height;
    CGFloat diff = fullH / tanf(DEGREES_TO_RADIANS(self.degree));
    CGFloat shortX = (fullW - diff - space) / 2;
    CGFloat btnW = shortX + diff;
    
    IrregularBtn * btn = [IrregularBtn buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = UIColorGreen;
    frame.size.width = btnW;
    frame.origin.x = self.bounds.size.width - frame.size.width;
    btn.frame = frame;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setBackgroundImageWithURL:[NSURL URLWithString:@"https://cdn.pixabay.com/photo/2022/05/21/09/30/cat-7211080_1280.jpg"] forState:UIControlStateNormal options:0];
    // 添加路径关键点array
    NSMutableArray *pointArray = [NSMutableArray array];
    if (self.isRightSperateStyle) {
        [pointArray addObject:NSStringFromCGPoint(CGPointMake(0.f, 0.f))];
        [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn) - shortX, kViewHeight(btn)))];
    }else{
        [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn) - shortX, 0.f))];
        [pointArray addObject:NSStringFromCGPoint(CGPointMake(0.f, kViewHeight(btn)))];
    }
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn), btn.frame.size.height))];
    [pointArray addObject:NSStringFromCGPoint(CGPointMake(kViewWidth(btn), 0.f))];
    
    btn.cornerPointArray = [pointArray mutableCopy];
    
    self.rightImgBtn = btn;
    [self.contentView addSubview:btn];
}

- (UIView *)contentView{
    if (!_contentView) {
        CGRect frame = self.bounds;
//        frame.size.height -= 10;
        _contentView = [[UIView alloc] initWithFrame:frame];
        _contentView.cornerRadius = 8;
    }
    return _contentView;
}

- (UIImageView *)vsIcon{
    if (!_vsIcon) {
        _vsIcon = [[UIImageView alloc] initWithImage:UIImageMake(@"graphic_vs")];
        [_vsIcon tmui_addSingerTapWithBlock:^{
            NSLog(@"tap vs");
        }];
    }
    return _vsIcon;
}

- (UILabel *)leftLbl{
    if (!_leftLbl) {
        _leftLbl = [UILabel new];
        _leftLbl.backgroundColor = UIColorPrimary;
        _leftLbl.cornerRadius = 4;
        _leftLbl.textColor = UIColorWhite;
        _leftLbl.font = UIFont(11);
        _leftLbl.textAlignment = NSTextAlignmentCenter;
        _leftLbl.text = @"装修前";
    }
    return _leftLbl;
}


- (UILabel *)rightLbl{
    if (!_rightLbl) {
        _rightLbl = [UILabel new];
        _rightLbl.backgroundColor = UIColorPrimary;
        _rightLbl.cornerRadius = 4;
        _rightLbl.textColor = UIColorWhite;
        _rightLbl.font = UIFont(11);
        _rightLbl.textAlignment = NSTextAlignmentCenter;
        _rightLbl.text = @"装修后";
    }
    return _rightLbl;
}


@end
