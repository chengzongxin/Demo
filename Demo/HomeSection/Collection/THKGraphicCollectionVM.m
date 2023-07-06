//
//  THKGraphicCollectionVM.m
//  Demo
//
//  Created by Joe.cheng on 2023/7/6.
//

#import "THKGraphicCollectionVM.h"

@interface THKGraphicCollectionVM ()

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, strong) NSString *briefStr;


@end

@implementation THKGraphicCollectionVM


#pragma mark - Super
- (THKBaseRequest *)requestWithInput:(id)input {
    return [[THKGraphicCollectionRequest alloc] init];
}

- (NSArray *)appendData:(THKGraphicCollectionResponse *)response{
    THKGraphicCollectionModel *model = response.data;
    self.titleStr = model.title;
    self.briefStr = model.brief;
    return model.list;
}

@end
