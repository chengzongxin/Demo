//
//  THKDecorationToDoVM+Godeye.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2022/7/22.
//  Copyright © 2022 binxun. All rights reserved.
//

#import "THKDecorationToDoVM+Godeye.h"
#import "Godeye.h"

@implementation THKDecorationToDoVM (Godeye)


- (void)exposeView:(UIView *)view paraBlock:(NSDictionary *(^)(void))block{
    GEWidgetResource *resource = [GEWidgetResource resourceWithWidget:view];
    [resource addEntries:block()];
    [[GEWidgetExposeEvent eventWithResource:resource] report];
}

- (void)clickView:(UIView *)view paraBlock:(NSDictionary *(^)(void))block{
    GEWidgetResource *resource = [GEWidgetResource resourceWithWidget:view];
    [resource addEntries:block()];
    [[GEWidgetClickEvent eventWithResource:resource] report];
}

- (void)stageCardShow:(UIView *)view
          widgetTitle:(NSString *)widgetTitle{
    [self exposeView:view paraBlock:^NSDictionary *{
        return @{@"widget_uid":@"stage_card",
                 @"widget_title":widgetTitle?:@"",
        };
    }];
}

- (void)stageCardClick:(UIView *)view
           widgetTitle:(NSString *)widgetTitle{
    [self clickView:view paraBlock:^NSDictionary *{
        return @{@"widget_uid":@"stage_card",
                 @"widget_title":widgetTitle?:@"",
        };
    }];
}

- (void)listUnfoldShow:(UIView *)view
           widgetTitle:(NSString *)widgetTitle
             widgetTag:(NSString *)widgetTag{
    [self exposeView:view paraBlock:^NSDictionary *{
        return @{@"widget_uid":@"unfold_btn",
                 @"widget_title":widgetTitle?:@"",
                 @"widget_tag":widgetTag?:@"",
        };
    }];
}

- (void)listUnfoldClick:(UIView *)view
            widgetTitle:(NSString *)widgetTitle
              widgetTag:(NSString *)widgetTag{
    [self clickView:view paraBlock:^NSDictionary *{
        return @{@"widget_uid":@"unfold_btn",
                 @"widget_title":widgetTitle?:@"",
                 @"widget_tag":widgetTag?:@"",
        };
    }];
}

- (void)listCheckOffShow:(UIView *)view
             widgetTitle:(NSString *)widgetTitle
          widgetSubtitle:(NSString *)widgetSubtitle
               widgetTag:(NSString *)widgetTag{
    [self exposeView:view paraBlock:^NSDictionary *{
        return @{@"widget_uid":@"checked_off_btn",
                 @"widget_title":widgetTitle?:@"",
                 @"widget_subtitle":widgetSubtitle?:@"",
                 @"widget_tag":widgetTag?:@"",
        };
    }];
}

- (void)listCheckOffClick:(UIView *)view
              widgetTitle:(NSString *)widgetTitle
           widgetSubtitle:(NSString *)widgetSubtitle
                widgetTag:(NSString *)widgetTag{
    [self clickView:view paraBlock:^NSDictionary *{
        return @{@"widget_uid":@"checked_off_btn",
                 @"widget_title":widgetTitle?:@"",
                 @"widget_subtitle":widgetSubtitle?:@"",
                 @"widget_tag":widgetTag?:@"",
        };
    }];
}

- (void)listLearnMoreShow:(UIView *)view
              widgetTitle:(NSString *)widgetTitle
           widgetSubtitle:(NSString *)widgetSubtitle
                widgetTag:(NSString *)widgetTag
              widgetIndex:(NSInteger)widgetIndex
              widgetValue:(NSString *)widgetValue
               widgetType:(NSString *)widgetType{
    [self exposeView:view paraBlock:^NSDictionary *{
        return @{@"widget_uid":@"learn_more_link",
                 @"widget_title":widgetTitle?:@"",
                 @"widget_subtitle":widgetSubtitle?:@"",
                 @"widget_tag":widgetTag?:@"",
                 @"widget_index":@(widgetIndex),
                 @"widget_value":widgetValue?:@"",
                 @"widget_type":widgetType?:@"",
        };
    }];
}

- (void)listLearnMoreClick:(UIView *)view
               widgetTitle:(NSString *)widgetTitle
            widgetSubtitle:(NSString *)widgetSubtitle
                 widgetTag:(NSString *)widgetTag
               widgetIndex:(NSInteger)widgetIndex
               widgetValue:(NSString *)widgetValue
                widgetType:(NSString *)widgetType{
    [self clickView:view paraBlock:^NSDictionary *{
        return @{@"widget_uid":@"learn_more_link",
                 @"widget_title":widgetTitle?:@"",
                 @"widget_subtitle":widgetSubtitle?:@"",
                 @"widget_tag":widgetTag?:@"",
                 @"widget_index":@(widgetIndex),
                 @"widget_value":widgetValue?:@"",
                 @"widget_type":widgetType?:@"",
        };
    }];
}

@end
