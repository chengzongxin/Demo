//
//  THKGraphicDetailModel.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import "THKGraphicDetailModel.h"

@implementation THKGraphicDetailGeneratePicture

@end

@implementation THKGraphicDetailReportData

@end

@implementation THKGraphicDetailShareData

@end

@implementation THKGraphicDetailCategoryData

@end

@implementation THKGraphicDetailImgInfoItem

@end

@implementation THKGraphicDetailContentListItem

@end

@implementation THKGraphicDetailModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"imgInfo":THKGraphicDetailImgInfoItem.class,
             @"contentList":THKGraphicDetailContentListItem.class
    };
}
@end
