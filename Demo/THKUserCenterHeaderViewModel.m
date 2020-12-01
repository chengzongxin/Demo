//
//  THKUserCenterHeaderViewModel.m
//  Demo
//
//  Created by Joe.cheng on 2020/12/1.
//

#import "THKUserCenterHeaderViewModel.h"

@interface THKUserCenterHeaderViewModel ()

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *tagName;
@property (nonatomic, strong, readwrite) NSString *signature;
@property (nonatomic, strong, readwrite) NSAttributedString *followAttrText;
@property (nonatomic, strong, readwrite) NSAttributedString *fansAttrText;
@property (nonatomic, strong, readwrite) NSAttributedString *befollowAttrText;

@end

@implementation THKUserCenterHeaderViewModel

- (void)initialize{
    _bgImageH = 180;
    _avatarTop = 150;
    _avatarH = 72;
    _nameTop = 16;
    _nameH = 30;
    _tagTop = 9;
    _tagH = 24;
    _signatureTop = 12;
    _signatureH = 17;
    _followCountTop = 12;
    _followCountH = 20;
    _storeTop = 16;
    _storeH = 20;
    _ecologicalTop = 23;
    _ecologicalH = 60;
    _serviceTop = 30;
    _serviceH = 237;
    
    [self bindWithModel:@""];
}


- (void)bindWithModel:(id)model{
    [super bindWithModel:model];
    
    self.name = @"装修界的电动小马达";
    self.tagName = @"设计机构";
    self.signature = @"123个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名";
    self.followAttrText = [self attrWithText:@"关注" number:2434];
    self.fansAttrText = [self attrWithText:@"粉丝" number:332];
    self.befollowAttrText = [self attrWithText:@"获赞与收藏" number:4432];
    self.followCountW = [self widthForAttributeString:self.followAttrText];
    self.fansCountW = [self widthForAttributeString:self.fansAttrText];
    self.beFollowCountW = [self widthForAttributeString:self.befollowAttrText];
}


#pragma mark Public Method

- (CGFloat)viewHeight{
    CGFloat height = 0;
    height += _avatarTop;
    height += _avatarH;
    height += _nameTop;
    height += _nameH;
    height += _tagTop;
    height += _tagH;
    height += _signatureTop;
    height += _signatureH;
    height += _followCountTop;
    height += _followCountH;
    height += _storeTop;
    height += _storeH;
    height += _ecologicalTop;
    height += _ecologicalH;
    height += _serviceTop;
    height += _serviceH;
    return height;
}


#pragma mark Private
- (NSAttributedString *)attrWithText:(NSString *)text number:(NSInteger)number{
    NSString *allStr = [NSString stringWithFormat:@"%@ %ld",text,(long)number];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:allStr attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16],NSForegroundColorAttributeName:UIColorHexString(@"111111")}];
    NSRange range = [allStr rangeOfString:text];
    [string addAttributes:@{NSFontAttributeName:UIFont(12),NSForegroundColorAttributeName:UIColorHexString(@"#878B99")} range:range];
    
    return string;
}

- (CGFloat)widthForAttributeString:(NSAttributedString *)attrStr{
    return ceilf([attrStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size.width);
}

@end
