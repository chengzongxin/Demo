//
//  THKCompanyDetailBannerViewModel.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "THKCompanyDetailBannerViewModel.h"

@interface THKCompanyDetailBannerViewModel ()

@property (nonatomic, strong) RACSubject *tapItemSubject;
@property (nonatomic, strong) RACSubject *tapRemindLiveSubject;
@property (nonatomic, strong) RACSubject *tapVideoImageTagSubject;

@end

@implementation THKCompanyDetailBannerViewModel

- (id)mainViewModel{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:self.model.videoList];
    [arr addObjectsFromArray:self.model.bannerList];
    return arr;
}

- (id)rollModel{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:self.model.videoList];
    [arr addObjectsFromArray:self.model.bannerList];
    return arr;
}

- (id)entryModel{
    return self.model.decShortName;
}

TMUI_PropertyLazyLoad(RACSubject, tapItemSubject);
TMUI_PropertyLazyLoad(RACSubject, tapRemindLiveSubject);
TMUI_PropertyLazyLoad(RACSubject, tapVideoImageTagSubject);

@end
