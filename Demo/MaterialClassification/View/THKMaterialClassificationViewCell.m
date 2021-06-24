//
//  THKMaterialClassificationViewCell.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialClassificationViewCell.h"

#define kBackgroundColor UIColorHex(#29D181)
#define kArrorHeight 8

@implementation THKMaterialClassificationViewCell

#pragma mark - Init

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self thk_setupView];
    }
    return self;
}

- (void)thk_setupView {
    
    self.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CGCustomFloat(5));
        make.size.mas_equalTo(CGSizeMake(CGCustomFloat(60), CGCustomFloat(60)));
        make.centerX.equalTo(self.contentView);
        //        make.bottom.equalTo(self.titleLabel.mas_top).offset(-8);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(4);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(CGCustomFloat(17));
    }];
}


- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (selected) {
        _titleLabel.textColor = UIColor.whiteColor;
    }else{
        _titleLabel.textColor = UIColorHex(#333333);
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];

//    self.layer.shadowColor = [[UIColor grayColor] CGColor];
//    self.layer.shadowOpacity = 1.0;
//    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 1.0);
    UIColor *bgColor = self.selected ? kBackgroundColor : UIColor.whiteColor;
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;

    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);

    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}



- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor grayColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.cornerRadius = 4;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorHex(#333333);
        _titleLabel.font = [UIFont systemFontOfSize:CGCustomFont(12.0)];
    }
    return _titleLabel;
}


@end
