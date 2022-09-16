//
//  THKDirDetailDiaryPageRequest.m
//  Demo
//
//  Created by Joe.cheng on 2021/10/27.
//

#import "THKDirDetailDiaryPageRequest.h"

@implementation THKDirDetailDiaryPageRequest
- (NSString *)requestDomain {
    return kJavaServerDomain;
}

- (NSString *)requestUrl {
    return @"/dir/detail/diaryPage";
}

- (NSDictionary *)parameters {
    NSMutableDictionary *para = [@{@"snapshotId":self.snapshotId?:@"",
                                   @"diaryBookId":@(self.diaryBookId).stringValue,
                                   @"diaryId":self.diaryId?:@"",
                                   @"firstStageId":self.firstStageId?:@"",
                                   @"range":self.range?:@[],
                                 } mutableCopy];
    
    if (self.offset.length) {
        para[@"offset"] = self.offset;
    }
    return para;
}

- (THKHttpMethod)httpMethod {
    return THKHttpMethodPOST;
}

- (THKParameterType)parameterType {
    return THKParameterTypeArgsWithUrl;
}


- (Class)modelClass {
    return [THKDirDetailDiaryPageResponse class];
}

@end

@implementation THKDirDetailDiaryPageResponseData

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"diaryInfos":THKDiaryInfoModel.class};
}

@end

@implementation THKDirDetailDiaryPageResponse

@end
