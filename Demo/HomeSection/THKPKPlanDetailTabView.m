//
//  THKPKPlanDetailTabView.m
//  Demo
//
//  Created by Joe.cheng on 2023/8/21.
//

#import "THKPKPlanDetailTabView.h"

@interface THKPKPlanDetailTabBtn : UIControl

@property (nonatomic, strong) UIImageView *avatarImgV;

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation THKPKPlanDetailTabBtn

- (void)setSelected:(BOOL)selected{
    if (selected) {
        self.borderColor = UIColorGreen;
        self.borderWidth = 1;
        self.titleLbl.font = UIFontMedium(14);
    }else {
        self.borderWidth = 0;
        self.titleLbl.font = UIFont(12);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.avatarImgV];
    [self addSubview:self.titleLbl];
    
    [self.avatarImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImgV.mas_right).offset(10);
        make.centerY.equalTo(self);
        make.right.mas_offset(-10);
    }];
}

- (UIImageView *)avatarImgV{
    if (!_avatarImgV) {
        _avatarImgV = [[UIImageView alloc] init];
        _avatarImgV.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImgV.clipsToBounds = YES;
        _avatarImgV.cornerRadius = 12;
    }
    return _avatarImgV;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = UIFont(12);
        _titleLbl.textColor = UIColorRegular;
    }
    return _titleLbl;
}

@end

@interface THKPKPlanDetailTabView ()<UIScrollViewDelegate>


@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray <THKPKPlanDetailTabBtn *>*btns;

@property (nonatomic, strong) THKPKPlanDetailTabBtn *lastBtn;

@end

@implementation THKPKPlanDetailTabView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setData:(NSArray *)data{
    _data = data;
    
    [self.btns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *btns = [NSMutableArray array];
    for (int i = 0; i < data.count; i++) {
        THKPKPlanDetailTabBtn *btn = [[THKPKPlanDetailTabBtn alloc] init];
        btn.cornerRadius = 15;
        btn.titleLbl.text = data[i];
        [btn.avatarImgV loadImageWithUrlStr:@"https://img.to8to.com/newheadphoto/v2/100/102.jpg" placeHolderImage:kDefaultHeadImg];
        btn.tag = i;
        [self.scrollView addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //        btn.frame = CGRectMake(16 + i * 120 + i * 16, 10, 120, 30);
        THKPKPlanDetailTabBtn *preBtn = btns.lastObject;
        CGFloat width = (TMUI_SCREEN_WIDTH - 16 * 2 - 16 * 2) / 3;
//        CGFloat left = preBtn
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.scrollView);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(30);
            if (preBtn) {
                make.left.equalTo(preBtn.mas_right).offset(16);
            }else{
                make.left.mas_equalTo(16);
            }
        }];
        
        [btns addObject:btn];
    }
    self.btns = btns;
}

- (void)btnClick:(UIButton *)btn {
    [self setSelectIdx:btn.tag];
    !_tapItem?:_tapItem(btn.tag);
}

- (void)setSelectIdx:(NSInteger)idx {
    if (idx > self.btns.count) return;
    
    self.lastBtn.selected = NO;
    
    THKPKPlanDetailTabBtn *btn = self.btns[idx];
    
    btn.selected = YES;
    
    [self.lastBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50 + [self.lastBtn.titleLbl.text tmui_widthForFont:self.lastBtn.titleLbl.font]);
    }];
    
    [btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50 + [btn.titleLbl.text tmui_widthForFont:btn.titleLbl.font]);
    }];
    
    self.lastBtn = btn;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        CGFloat maxW = CGRectGetMaxX(self.btns.lastObject.frame);
        self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.btns.lastObject.frame) + 16, self.height);
        if (maxW > self.scrollView.width && idx == self.btns.count - 1) {
            [self.scrollView scrollToRight];
        }else if (idx == 0 && self.scrollView.contentOffset.x > 0) {
            [self.scrollView scrollToLeft];
        }
    }];
    
    
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}


@end
