//
//  THKMaterialClassificationViewModel.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialClassificationVM.h"

@interface THKMaterialClassificationVM ()

//@property (nonatomic, strong) NSString *imgUrl;
//
//@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) THKRequestCommand *requestCMD;

@end

@implementation THKMaterialClassificationVM

- (THKRequestCommand *)requestCMD{
    if (!_requestCMD) {
        @weakify(self);
        _requestCMD = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            @strongify(self);
            THKMaterialRecommendRankRequest *request = [[THKMaterialRecommendRankRequest alloc] init];
            request.mainCategoryId = self.mainCategoryId;
            request.subCategoryId = self.subCategoryId;
            request.needTopSubCategoryList = 1;
            return request;
        }];
    }
    return _requestCMD;
}

@end
