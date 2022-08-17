//
//  THKOnlineDesignHomeDetailResponse.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/17.
//

#import "THKOnlineDesignHomeDetailResponse.h"


@implementation THKOnlineDesignHomeDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"columnList":THKOnlineDesignHomeEditColumnList.class,
             @"planImgList":THKOnlineDesignHomeEditPlanImgList.class,
             @"recordingInfoList":THKOnlineDesignHomeEditRecordingInfoList.class
    };
}

@end

@implementation THKOnlineDesignHomeDetailResponse

@end
