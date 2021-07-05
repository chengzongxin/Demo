//
//  TMCardComponentDataInfoObjects.m
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "TMCardComponentDataInfoObjects.h"

/**显示在封面上的类型icon数据对象*/
@implementation TMCardComponentDataCoverSubIcon
@synthesize layout_width = _layout_width, layout_height = _layout_height;

- (NSInteger)layout_width {
    if (_layout_width == 0) {
        _layout_width = 1.0f / 3.0f * self.width;
    }
    return _layout_width;
}

- (NSInteger)layout_height {
    if (_layout_height == 0) {
        _layout_height = 1.0f / 3.0f * self.height;
    }
    return _layout_height;
}

@end

/**显示封面图内容上的相关数据*/
@implementation TMCardComponentDataCoverInfo

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"subIcons" : [TMCardComponentDataCoverSubIcon class]};
}

@end

/**显示在底部，头像、认证icon、标题的相关数据*/
@implementation TMCardComponentDataBottomInfo

@end

/**真实类型的业务内容数据*/
@implementation TMCardComponentDataContentInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}

@end

/** 显示在标题前面的文本标签数据*/
@implementation TMCardComponentDataContentTextTag

@end

@implementation TMCardComponentDataInsertRecommendTagsInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"guideWords" : @"guideWordVos"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"guideWords" : [TMCardComponentDataInsertRecommendTagModel class]};
}
@end

/** 推荐标签数据的单个对象*/
@implementation TMCardComponentDataInsertRecommendTagModel

@end

/**底部右下角相关的互动数据*/
@implementation TMCardComponentDataInteractionInfo

@end

/** 单独调用接口上报的配置对象 */
@implementation TMCardComponentDataReportConfig

@end
