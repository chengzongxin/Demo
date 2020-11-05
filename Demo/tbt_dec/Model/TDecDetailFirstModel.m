//
//  TDecDetailFirstModel.m
//  HouseKeeper
//
//  Created by cl w on 2019/7/31.
//  Copyright © 2019年 binxun. All rights reserved.
//

#import "TDecDetailFirstModel.h"
// 8.6 wcl 0618

@implementation TDecDetailVideoModel

- (instancetype)mj_setKeyValues:(id)keyValues
{
    TDecDetailVideoModel *vm = [super mj_setKeyValues:keyValues];
    if (vm.videoUrl.length) {
        vm.vid = [keyValues[@"videoId"] integerValue];
        vm.pid = [keyValues[@"imgId"] integerValue];
    }
    else {
        vm.pid = [keyValues[@"id"] integerValue];
    }
    return vm;
}

@end

@implementation TDecDetailRankingModel

@end

@implementation TDecDetailLabelModel

@end

@implementation TDecDetailBizModel

@end

@implementation TDecDetailActivityConfig

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"activityId":@"id"};
}

- (TDecActivityRemaingTime)midAdRemainTime
{
    TDecActivityRemaingTime timeStruct;
    timeStruct.day = -1;
    timeStruct.hour = -1;
    timeStruct.minute = -1;
    timeStruct.second = -1;
    if (self.positionType==2) {
        NSInteger timeStamp = self.endTime-self.serverTime;
        NSInteger day = timeStamp/(24*60*60);
        NSInteger hour = (timeStamp-day*24*60*60)/(60*60);
        NSInteger minute = (timeStamp-day*24*60*60-hour*60*60)/60;
        NSInteger second = timeStamp-day*24*60*60-hour*60*60-minute*60;
        timeStruct.day = day;
        timeStruct.hour = hour;
        timeStruct.minute = minute;
        timeStruct.second = second;
    }
    return timeStruct;
}

- (BOOL)hasStarted
{
    if (self.serverTime>0 && self.startTime>0 && self.serverTime>self.startTime) {
        return YES;
    }
    return NO;
}

@end

@implementation THKAppointEntranceVO

- (BOOL)showToolBar
{
    if (self.toolBarStyle>0 && self.toolBarStyle<=8) {
        return YES;
    }
    return NO;
}

- (NSInteger)toolBarStyle
{
    if (self.hasPhone && !self.hasIM && !self.hasRegister) {
        return 2;
    }
    if (!self.hasPhone && self.hasIM && !self.hasRegister) {
        return 3;
    }
    if (!self.hasPhone && !self.hasIM && self.hasRegister) {
        return 4;
    }
    if (self.hasPhone && !self.hasIM && self.hasRegister) {
        return 5;
    }
    if (self.hasPhone && self.hasIM && !self.hasRegister) {
        return 6;
    }
    if (!self.hasPhone && self.hasIM && self.hasRegister) {
        return 7;
    }
    if (self.hasPhone && self.hasIM && self.hasRegister) {
        return 8;
    }
    if (self.hasIntention) {
        return 1;
    }
    return 0;
}

@end

@implementation TDecDetailFirstModel


//@synthesize godeyeProperties,shareModel;

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"videoList":@"TDecDetailVideoModel",
             @"labelList":@"TDecDetailLabelModel",
             @"brandLabel":@"TDecDetailLabelModel",
             @"bizServiceList":@"TDecDetailBizModel",
             @"rankingList":@"TDecDetailRankingModel",
             @"bannerList":@"TDecDetailVideoModel",
             @"companyLiveList":@"TDecLiveModel"
             };
}

- (TDecDetailActivityConfig *)topAd
{
    __block TDecDetailActivityConfig *cfg = nil;
    [self.activities enumerateObjectsUsingBlock:^(TDecDetailActivityConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.positionType==1) {
            cfg = obj;
            *stop = YES;
        }
    }];
    return cfg;
}

- (TDecDetailActivityConfig *)midAd
{
    __block TDecDetailActivityConfig *cfg = nil;
    [self.activities enumerateObjectsUsingBlock:^(TDecDetailActivityConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.positionType==2) {
            cfg = obj;
            *stop = YES;
        }
    }];
    return cfg;
}

//-(THKShareMessageModel *)shareModel{
//    NSString *shareTitle = self.companyName;
//    NSString *shareContent = self.companyName;
//    NSString *urlAtH5 = self.h5IndexUrl;
//    NSString *imageUrl = self.companyLogo;
//    NSInteger type = self.typeForShare;
//    if (type == 1) {
//        shareContent = [shareContent stringByAppendingString:@"-公司主页"];
//    }
//    else if (type == 2) {
//        shareContent = [shareContent stringByAppendingString:@"-设计师主页"];
//    }
//    shareTitle = [shareTitle stringByAppendingString:@"-土巴兔装修网"];
//   
//    //微博分享内容
//    NSString *weiboText = @"我在#土巴兔#找到了很好的装修公司，一起来看看吧~";
//
//    THKShareMessageModel *model = [[THKShareMessageModel alloc] init];
//    model.shareData = [THKShareData shareDataWithTitle:shareTitle content:shareContent webpageUrl:urlAtH5 imageUrl:imageUrl image:nil];
//    model.sinaConfig = [THKSinaConfig configWithContent:weiboText];
//    
//    return model;
//}

@end

@implementation TDecLiveModel

- (NSArray *)goodsImgs
{
    __block NSMutableArray *lst = @[].mutableCopy;
    [self.goodsList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx<3) {
            NSString *img = [obj[@"goodsImages"] firstObject];
            if (img) {
                [lst addObject:img];
            }
        }
        else {
            *stop = YES;
        }
    }];
    return lst;
}

- (NSArray *)goodsPrices
{
    __block NSMutableArray *lst = @[].mutableCopy;
    [self.goodsList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx<3) {
            NSString *price = [obj[@"goodsPrice"] description];
            if (price) {
                [lst addObject:[NSString stringWithFormat:@"￥%@",price]];
            }
        }
        else {
            *stop = YES;
        }
    }];
    return lst;
}


@end
