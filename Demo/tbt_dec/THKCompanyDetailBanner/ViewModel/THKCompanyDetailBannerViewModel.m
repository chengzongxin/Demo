//
//  THKCompanyDetailBannerViewModel.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "THKCompanyDetailBannerViewModel.h"

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

@end
