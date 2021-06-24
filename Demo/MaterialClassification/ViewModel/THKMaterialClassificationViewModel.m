//
//  THKMaterialClassificationViewModel.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialClassificationViewModel.h"

@interface THKMaterialClassificationViewModel ()

//@property (nonatomic, strong) NSString *imgUrl;
//
//@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) THKRequestCommand *requestCMD;

@end

@implementation THKMaterialClassificationViewModel

- (THKRequestCommand *)requestCMD{
    if (!_requestCMD) {
        _requestCMD = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            THKMaterialRecommendRankRequest *request = [[THKMaterialRecommendRankRequest alloc] init];
            request.subCategoryId = self.subCategoryId;
            request.needTopSubCategoryList = 1;
            return request;
        }];
    }
    return _requestCMD;
}

@end
