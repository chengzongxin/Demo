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
@property (nonatomic, strong, readwrite) NSString *followText;
@property (nonatomic, strong, readwrite) NSString *fansText;
@property (nonatomic, strong, readwrite) NSString *beFollowText;

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
    _serviceTop = 30;
    _serviceH = 237;
    
    [self bindWithModel:@""];
}


- (void)bindWithModel:(id)model{
    [super bindWithModel:model];
    
    self.name = @"永安设计";
    self.tagName = @"v 设计机构 >";
    self.signature = @"123个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名，个性签名";
    self.followText = @"11关注 2434";
    self.fansText = @"1粉丝 2434";
    self.beFollowText = @"2获赞和收藏 2434";
}


#pragma mark Public Method

- (CGFloat)viewHeight{
    
    
    
    return 0;
}

@end
