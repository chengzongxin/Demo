//
//  THKMaterialRecommendRankVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/21.
//

#import "THKMaterialRecommendRankVM.h"

@interface THKMaterialRecommendRankVM ()


@property (nonatomic, strong) NSArray <NSArray *> *headerTitles;
@property (nonatomic, strong) NSArray <NSArray *> *icons;
@property (nonatomic, strong) NSArray <NSArray *> *titles;
@property (nonatomic, strong) NSArray <NSArray *> *subtitles;

@property (nonatomic, strong) THKRequestCommand *requestCommand;

@property (nonatomic, strong, nullable) NSArray *data;

@end

@implementation THKMaterialRecommendRankVM
@dynamic requestCommand;
@dynamic data;


- (void)initialize{
    [super initialize];
    
    self.subCategoryId = 0;
    self.needTopSubCategoryList = 0;
}

- (THKBaseRequest *)requestWithInput:(id)input{
    THKMaterialRecommendRankRequest *request = [[THKMaterialRecommendRankRequest alloc] init];
    request.subCategoryId = self.subCategoryId;
    request.needTopSubCategoryList = self.needTopSubCategoryList;
    return request;
}

@end
