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

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [NSBundle.mainBundle pathForResource:@"data.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSString *str = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        TDecDetailFirstModel *model = [TDecDetailFirstModel mj_objectWithKeyValues:str];
        self.model = model;
    }
    return self;
}

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
