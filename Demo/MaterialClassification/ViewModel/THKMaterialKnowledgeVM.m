//
//  THKMaterialKnowledgeVM.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/6/25.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKMaterialKnowledgeVM.h"

@implementation THKMaterialKnowledgeVM

- (THKBaseRequest *)requestWithInput:(id)input{
    THKMaterialRecommendKnowledgeRequest *request = [[THKMaterialRecommendKnowledgeRequest alloc] init];
    request.page = [input integerValue];
    request.subCategoryId = self.subCategoryId;
    return request;
}

@end
