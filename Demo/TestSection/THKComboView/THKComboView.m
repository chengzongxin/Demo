//
//  THKComboView.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/30.
//

#import "THKComboView.h"

#define kComboImg(x) [UIImage imageNamed:[NSString stringWithFormat:@"diary_combo_num_%zi",x]]
#define kAddViewIfNeed(x,superview) do {\
    [superview addSubview:x];\
} while (0);

@interface NSArray (mas_distri)
- (void)distributeViewsAlongAxis:(MASAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing;
@end

static CGFloat const kComboNumW = 17;
@interface THKComboView ()

@property (nonatomic ,strong) UIImageView * xIV;
@property (nonatomic ,strong) UIImageView * digitIV;
@property (nonatomic ,strong) UIImageView * tenIV;
@property (nonatomic ,strong) UIImageView * hundredIV;
@property (nonatomic ,strong) UIImageView * thousandIV;

@end

@implementation THKComboView


@synthesize number = _number;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxNumber = 9999;
    }
    return self;
}

- (void)combo{
    //每调用一次self.numberView.number get方法 自增1
    self.number++;
    NSInteger num = self.number;
    [self changeNumber:num];
}

/**
 改变数字显示
 
 @param numberStr 显示的数字
 */
- (void)changeNumber:(NSInteger)numberStr{
    if (numberStr <= 0) {
        return;
    }
    
    if (numberStr > self.maxNumber) {
        numberStr = self.maxNumber;
    }
    
    NSInteger num = numberStr;
    NSInteger qian = num / 1000;
    NSInteger qianYu = num % 1000;
    NSInteger bai = qianYu / 100;
    NSInteger baiYu = qianYu % 100;
    NSInteger shi = baiYu / 10;
    NSInteger shiYu = baiYu % 10;
    NSInteger ge = shiYu;
    
    if (numberStr > 9999) {
        qian = 9;
        bai = 9;
        shi = 9;
        ge = 9;
    }
    
    
    [self.xIV mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-kComboNumW * length);
        make.left.equalTo(self);
        make.centerY.equalTo(self).offset(2);
    }];
    
    
    self.digitIV.image = kComboImg(ge);
    kAddViewIfNeed(self.digitIV, self);
    
    NSInteger length = 1;
    
    if (qian > 0) {
        length = 4;
        self.thousandIV.image = kComboImg(qian);
        self.hundredIV.image = kComboImg(bai);
        self.tenIV.image = kComboImg(shi);
        
        kAddViewIfNeed(self.thousandIV, self);
        kAddViewIfNeed(self.hundredIV, self);
        kAddViewIfNeed(self.tenIV, self);
        
//        NSArray *showArr = @[self.thousandIV,self.hundredIV,self.tenIV,self.digitIV];
//        [showArr enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(self);
//            }];
//        }];
//        [showArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:kComboNumW tailSpacing:0];
//
        [self.thousandIV mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_right).offset(-kComboNumW * (length - 1));
            make.left.equalTo(self.xIV.mas_right);
            make.centerY.equalTo(self);
        }];

        [self.hundredIV mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_right).offset(-kComboNumW * (length - 2));
            make.left.equalTo(self.thousandIV.mas_right);
            make.centerY.equalTo(self);
        }];

        [self.tenIV mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_right).offset(-kComboNumW * (length - 3));
            make.left.equalTo(self.hundredIV.mas_right);
            make.centerY.equalTo(self);
        }];
        
        [self.digitIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tenIV.mas_right);
            make.centerY.equalTo(self);
        }];
    }else if (bai > 0){
        length = 3;
        self.thousandIV.image = nil;
        [self.thousandIV removeFromSuperview];
        self.hundredIV.image = kComboImg(bai);
        self.tenIV.image = kComboImg(shi);
        kAddViewIfNeed(self.hundredIV, self);
        kAddViewIfNeed(self.tenIV, self);
        
//        NSArray *showArr = @[self.hundredIV,self.tenIV,self.digitIV];
//        [showArr enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(self);
//            }];
//        }];
//        [showArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:kComboNumW tailSpacing:0];
        
        [self.hundredIV mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_right).offset(-kComboNumW * (length - 1));
            make.left.equalTo(self.xIV.mas_right);
            make.centerY.equalTo(self);
        }];

        [self.tenIV mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_right).offset(-kComboNumW * (length - 2));
            make.left.equalTo(self.hundredIV.mas_right);
            make.centerY.equalTo(self.digitIV);
        }];
        
        [self.digitIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tenIV.mas_right);
            make.centerY.equalTo(self);
        }];
    }else if (shi > 0){
        length = 2;
        self.thousandIV.image = nil;
        self.hundredIV.image = nil;
        [self.thousandIV removeFromSuperview];
        [self.hundredIV removeFromSuperview];
        
        self.tenIV.image = kComboImg(shi);
        kAddViewIfNeed(self.tenIV, self);
        
//        NSArray *showArr = @[self.tenIV,self.digitIV];
//        [showArr enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(self);
//            }];
//        }];
//        [showArr distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:kComboNumW tailSpacing:0];
        
        
        [self.tenIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.xIV.mas_right);
            make.centerY.equalTo(self);
        }];
        
        [self.digitIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tenIV.mas_right);
            make.centerY.equalTo(self);
        }];
    }else {
        length = 1;
        self.tenIV.image = nil;
        self.thousandIV.image = nil;
        self.hundredIV.image = nil;
        [self.thousandIV removeFromSuperview];
        [self.hundredIV removeFromSuperview];
        [self.tenIV removeFromSuperview];
        
//        self.tenIV.image = kComboImg(shi);
//        kAddViewIfNeed(self.tenIV, self);
//        NSArray *showArr = @[self.tenIV,self.digitIV];
//        [showArr enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(self);
//            }];
//        }];
//        [showArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:kComboNumW tailSpacing:0];
        
        [self.digitIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.xIV.mas_right);
            make.centerY.equalTo(self);
        }];
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kComboNumW * (length + 1), 20));
    }];
    
    [self layoutIfNeeded];
}

- (void)addViewIfNeed:(UIView *)x superview:(UIView *)superview{
    do {
        if (x.superview == nil) {
            [superview addSubview:x];
        };
    } while (0);
}


//- (UIImage *)imageForNum:(NSInteger)num{
//    return [UIImage imageNamed:[NSString stringWithFormat:@"diary_combo_num_%zi",num]];
//}

- (UIImageView *)xIV{
    if (!_xIV) {
        _xIV = [self creatIV];
        _xIV.image = [UIImage imageNamed:@"diary_combo_num_×"];
    }
    return _xIV;
}

- (UIImageView *)digitIV{
    if (!_digitIV) {
        _digitIV = [self creatIV];
    }
    return _digitIV;
}

- (UIImageView *)tenIV{
    if (!_tenIV) {
        _tenIV = [self creatIV];
    }
    return _tenIV;
}

- (UIImageView *)hundredIV{
    if (!_hundredIV) {
        _hundredIV = [self creatIV];
    }
    return _hundredIV;
}

- (UIImageView *)thousandIV{
    if (!_thousandIV) {
        _thousandIV = [self creatIV];
    }
    return _thousandIV;
}

- (UIImageView *)creatIV{
    UIImageView * iv = [[UIImageView alloc] init];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:iv];
    return iv;
}

- (void)dealloc{
    NSLog(@"Delloc Me Already!!! %@",self);
}


@end



@implementation NSArray (mas_distri)

- (void)distributeViewsAlongAxis:(MASAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    MAS_VIEW *tempSuperView = [self mas_commonSuperviewOfViews];
    if (axisType == MASAxisTypeHorizontal) {
        MAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            MAS_VIEW *v = self[i];
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                if (prev) {
//                    make.width.equalTo(prev);
                    make.left.equalTo(prev.mas_right).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
//                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
    else {
        MAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            MAS_VIEW *v = self[i];
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                if (prev) {
                    make.height.equalTo(prev);
                    make.top.equalTo(prev.mas_bottom).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
}

- (MAS_VIEW *)mas_commonSuperviewOfViews
{
    MAS_VIEW *commonSuperview = nil;
    MAS_VIEW *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[MAS_VIEW class]]) {
            MAS_VIEW *view = (MAS_VIEW *)object;
            if (previousView) {
                commonSuperview = [view mas_closestCommonSuperview:commonSuperview];
            } else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}


@end
