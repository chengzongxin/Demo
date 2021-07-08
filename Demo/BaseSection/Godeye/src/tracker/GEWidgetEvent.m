//
//  GEWidgetEvent.m
//  AFNetworking
//
//  Created by jerry.jiang on 2018/12/27.
//

#import "GEWidgetEvent.h"
#import "UIViewController+Godeye.h"
#import "GEWidgetProcessor.h"
#import <objc/runtime.h>
#import "UIView+Godeye.h"
#import "UIResponder+Godeye.h"
#import "GEPageViewProcessor.h"
#import "GEEnvironmentParameter.h"
#import "UIScrollView+Godeye.h"

@interface GEWidgetResource ()

@property (nonatomic, weak) UIView *cellWidget;
@property (nonatomic, weak) UIView *tableWidget;
@property (nonatomic, strong) NSMutableDictionary *dictResource;

@end

@implementation GEWidgetResource

- (instancetype)init {
    if (self = [super init]) {
        self.dictResource = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (instancetype)resourceWithWidget:(UIView *)widget {
    return [self resourceWithCellWidget:widget tableWidget:nil indexPath:nil];
}

+ (instancetype)resourceWithCellWidget:(UIView *)widget tableWidget:(UIView *)tableWidget indexPath:(NSIndexPath *)indexPath {
    
    GEWidgetResource *resource = [[GEWidgetResource alloc] init];
    if (widget) {
        
        if ([widget isKindOfClass:[UITableViewCell class]] || [widget isKindOfClass:[UICollectionViewCell class]]) {
            resource.cellWidget = widget; //保存后面曝光的时候要用到
            resource.tableWidget = tableWidget;
        }
        
        resource.dictResource[@"widget_class"] = NSStringFromClass([widget class])?:@"";
        if (!indexPath) {
            indexPath = [resource getIndexPathWithWidget:widget];
        }
        if (indexPath) {
            resource.dictResource[@"widget_index"] = [NSString stringWithFormat:@"%zd", indexPath.row];
        }
        [resource setPageUidWithWidget:widget tableWidget:tableWidget];
        [resource setPageReferUidWithWidget:widget tableWidget:tableWidget];

        if ([widget isKindOfClass:[UILabel class]]) {
            NSString *text = ((UILabel *)widget).text?:@"";
            if (text.length > 0) { //有文字内容时才添加
                resource.dictResource[@"widget_title"] = text;
            }
        } else if ([widget isKindOfClass:[UIButton class]]) {
            NSString *text = ((UIButton *)widget).currentTitle?:@"";
            if (text.length > 0) { //有文字内容时才添加
                resource.dictResource[@"widget_title"] = text;
            }
        }
    }

    return resource;
}

+ (instancetype)resourceWithExposeScrollView:(UIScrollView *)widget atIndexPath:(NSIndexPath *)indexPath {
    
    GEWidgetResource *resource = [[GEWidgetResource alloc] init];
    if (widget) {
        if (indexPath) {
            resource.dictResource[@"widget_index"] = [NSString stringWithFormat:@"%zd", indexPath.row];
        }
        [resource setPageUidWithWidget:nil tableWidget:widget];
        [resource setPageReferUidWithWidget:nil tableWidget:widget];
    }

    return resource;
}

- (void)addObject:(id)object forKey:(NSString *)key {
    [self.dictResource setObject:object?:@"" forKey:key?:@""];
}

- (void)removeObjectForKey:(NSString *)key {
    if (key) {
        [self.dictResource removeObjectForKey:key];
    }
}

- (void)addEntries:(NSDictionary *)dict {
    if (dict) {
        [self.dictResource addEntriesFromDictionary:dict];
    }
}

- (NSDictionary *)geResource {
    return self.dictResource.copy;
}

- (void)setPageUidWithWidget:(UIView *)widget tableWidget:(UIView *)tableWidget {
    
    if (!widget && !tableWidget) {
        return ;
    }

    void (^block)(void) = ^{
        UIViewController *vc = (UIViewController *)[tableWidget?:widget nextResponder];
        while (![vc isKindOfClass:[UIViewController class]] && vc) {
           vc = (UIViewController *)[vc nextResponder];
        }
        if (vc) {
            self.dictResource[@"page_uid"] = vc.gePageUid;
        } else {
            self.dictResource[@"page_uid"] = [[GEPageViewProcessor defaultProcessor] topViewController].gePageUid;
        }
    };
    if ([NSThread currentThread].isMainThread) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

- (void)setPageReferUidWithWidget:(UIView *)widget tableWidget:(UIView *)tableWidget {
    if (!widget && !tableWidget) {
        return ;
    }

    void (^block)(void) = ^{
        UIViewController *vc = (UIViewController *)[tableWidget?:widget nextResponder];
        while (vc) {
            if ([vc isKindOfClass:[UIViewController class]]) {
                self.gePageReferUid = vc.gePageReferUid;
                break;
            }
            vc = (UIViewController *)[vc nextResponder];
        }
        if (!self.gePageReferUid) {
            self.gePageReferUid = [[GEPageViewProcessor defaultProcessor] topViewController].gePageReferUid;
        }
    };
    if ([NSThread currentThread].isMainThread) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

- (NSIndexPath *)getIndexPathWithWidget:(UIView *)widget {
    
    if (![widget isKindOfClass:[UITableViewCell class]] && ![widget isKindOfClass:[UICollectionViewCell class]]) {
        return nil;
    }
    __block NSIndexPath *indexPath = nil;
    void (^block)(void) = ^{
        if ([widget isKindOfClass:[UITableViewCell class]]) {
            UIView *tableView = widget.superview;
            while (![tableView isKindOfClass:[UITableView class]] && tableView.superview != nil) {
                tableView = tableView.superview;
            }
            if (tableView && [tableView isKindOfClass:[UITableView class]]) {
                indexPath = [((UITableView *)tableView) indexPathForCell:(UITableViewCell*)widget];
            }
        } else if ([widget isKindOfClass:[UICollectionViewCell class]]) {
            UIView *collectionView = widget.superview;
            while (![collectionView isKindOfClass:[UICollectionView class]] && collectionView.superview != nil) {
                collectionView = collectionView.superview;
            }
            if (collectionView && [collectionView isKindOfClass:[UICollectionView class]]) {
                indexPath = [((UICollectionView *)collectionView) indexPathForCell:(UICollectionViewCell *)widget];
            }
        }
    };
    if ([NSThread currentThread].isMainThread) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
    
    return indexPath;
}

- (void)setGeWidgetUid:(NSString *)geWidgetUid {
    if (geWidgetUid) {
        self.dictResource[@"widget_uid"] = geWidgetUid;
    }
}

- (void)setGePageReferUid:(NSString *)gePageReferUid {
    if (gePageReferUid) {
        self.dictResource[@"page_refer_uid"] = gePageReferUid;
    }
}

@end

@interface GEWidgetEvent ()

@property (nonatomic, weak) UIView *geWidget;
@property (nonatomic, weak) UIView *geSuperWidget;
@property (nonatomic, strong) GEWidgetResource *resource;

@end

@implementation GEWidgetEvent

+ (instancetype)eventWithResource:(GEWidgetResource *)resource {
    
    GEWidgetEvent *model = nil;
    char * key = [NSStringFromClass([self class]) cStringUsingEncoding:NSUTF8StringEncoding];
    if ([resource.cellWidget isKindOfClass:[UITableViewCell class]] || [resource.cellWidget isKindOfClass:[UICollectionViewCell class]]) {
        model = objc_getAssociatedObject(resource.accessibilityLabel, key);
    }
    if (!model) {
        model = [[self alloc] init];
        if ([resource.cellWidget isKindOfClass:[UITableViewCell class]] || [resource.cellWidget isKindOfClass:[UICollectionViewCell class]]) {
            objc_setAssociatedObject(resource.cellWidget, key, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    model.resource = resource;
    return model;
}

+ (instancetype)eventWithWidget:(UIView *)widget
{
    if (![self isWidgetUidExist:widget]) {
        NSLog(@"Godeye Error:%@'s WidgetUid should not be nil", widget);
        return nil;
    }
    return [self eventWithWidget:widget indexPath:nil];
}

+ (instancetype)eventWithWidget:(UIView *)widget indexPath:(NSIndexPath *)indexPath
{
    if (![self isWidgetUidExist:widget]) {
        NSLog(@"Godeye Error:%@'s WidgetUid should not be nil", widget);
        return nil;
    }
    return [self eventWithUid:widget.geWidgetUid
                       widget:widget
                  superWidget:nil
                    indexPath:indexPath
                     resource:widget.geResource];
}

+ (instancetype)eventWithWidget:(UIView *)widget superWidget:(UIView *)superWidget {
    if (![self isWidgetUidExist:widget]) {
        NSLog(@"Godeye Error:%@'s WidgetUid should not be nil", widget);
        return nil;
    }
    return [self eventWithWidget:widget superWidget:superWidget indexPath:nil];
}

+ (instancetype)eventWithWidget:(UIView *)widget
                    superWidget:(UIView *)superWidget
                      indexPath:(NSIndexPath *)indexPath {
    if (![self isWidgetUidExist:widget]) {
        NSLog(@"Godeye Error:%@'s WidgetUid should not be nil", widget);
        return nil;
    }
    return [self eventWithUid:widget.geWidgetUid
                       widget:widget
                  superWidget:superWidget
                    indexPath:indexPath
                     resource:widget.geResource];
}

+ (BOOL)isWidgetUidExist:(UIView *)widget {
    
    if (!widget.geWidgetUid) {
        NSDictionary *resource = widget.geResource;
        if (resource && [resource isKindOfClass:[NSDictionary class]]) {
            NSString *widgetUid = resource[@"widget_uid"];
            if (widgetUid && [widgetUid isKindOfClass:[NSString class]]) {
                widget.geWidgetUid = widgetUid;
            }
        }
        
        if (!widget.geWidgetUid) {
            return NO;
        }
    }
    
    return YES;
}

+ (instancetype)eventWithUid:(NSString *)widgetUid
                      widget:(UIView *)widget
                 superWidget:(UIView *)superWidget
                   indexPath:(NSIndexPath *)indexPath
                    resource:(NSDictionary *)resource;
{
    NSParameterAssert(widgetUid);
    GEWidgetEvent *model = nil;
    char * key = [NSStringFromClass([self class]) cStringUsingEncoding:NSUTF8StringEncoding];
    if ([widget isKindOfClass:[UITableViewCell class]] || [widget isKindOfClass:[UICollectionViewCell class]]) {
        model = objc_getAssociatedObject(widget, key);
    }
    if (!model) {
        model = [[self alloc] init];
        if ([widget isKindOfClass:[UITableViewCell class]] || [widget isKindOfClass:[UICollectionViewCell class]]) {
            objc_setAssociatedObject(widget, key, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }

    model.widgetUid = widgetUid;
    model.geResource = resource;
    model.indexPath = indexPath;
    model.pageUid = resource[@"page_uid"];
    model.gePageReferUid = resource[@"page_refer_uid"];
    
    model.onReportFinish = nil;
    model.title = nil;
    model.subTitle = nil;
    model.widgetSrc = nil;
    model.widgetHref = nil;
    
    if (superWidget) {
        model.geSuperWidget = superWidget;
    }
    
    if (widget) {
        model.widgetHref = widget.geWidgetHref;
        model.geWidget = widget;
        model.widgetClass = NSStringFromClass([widget class]);
        if (!model.pageUid) {
            [model getPageUid];
        }
        if (!model.gePageReferUid) {
            [model getPageReferUid];
        }
        if ([widget isKindOfClass:[UILabel class]]) {
            model.title = ((UILabel *)widget).text;
        } else if ([widget isKindOfClass:[UIButton class]]) {
            model.title = ((UIButton *)widget).currentTitle;;
        }
    }
    return model;
}

- (NSDictionary *)dictionaryValue
{
    NSParameterAssert(self.widgetUid);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.widgetUid) {
        dic[@"widget_uid"] = self.widgetUid;
    }
    if (self.widgetClass) {
        dic[@"widget_class"] = self.widgetClass;
    }
    if (!self.pageUid && self.geWidget) {
        [self getPageUid];
    }
    if (self.pageUid) {
        dic[@"page_uid"] = self.pageUid;
    }
    if (self.gePageReferUid) {
        dic[@"page_refer_uid"] = self.gePageReferUid;
    }
    if (!self.indexPath) {
        [self getIndexPath];
    }
    if (self.indexPath) {
        dic[@"widget_index"] = [NSString stringWithFormat:@"%zd", self.indexPath.row];
    }
    if (self.title) {
        dic[@"widget_title"] = self.title;
    }
    if (self.subTitle) {
        dic[@"widget_subtitle"] = self.subTitle;
    }
    if (self.widgetSrc) {
        dic[@"widget_src"] = self.widgetSrc;
    }
    if (self.widgetHref) {
        dic[@"widget_href"] = self.widgetHref;
    }
    [dic addEntriesFromDictionary:self.geResource];
    return [NSDictionary dictionaryWithDictionary:dic];
}

- (void)getIndexPath
{
    if (![self.geWidget isKindOfClass:[UITableViewCell class]] && ![self.geWidget isKindOfClass:[UICollectionViewCell class]]) {
        return;
    }
    dispatch_block_t block = ^{
        if ([self.geWidget isKindOfClass:[UITableViewCell class]]) {
            UITableView *tableView = self.geWidget.superview;
            while (![tableView isKindOfClass:[UITableView class]] && tableView.superview != nil) {
                tableView = tableView.superview;
            }
            if (tableView) {
                self.indexPath = [tableView indexPathForCell:self.geWidget];
            }
        } else if ([self.geWidget isKindOfClass:[UICollectionViewCell class]]) {
            UICollectionView *collectionView = self.geWidget.superview;
            while (![collectionView isKindOfClass:[UICollectionView class]] && collectionView.superview != nil) {
                collectionView = collectionView.superview;
            }
            if (collectionView) {
                self.indexPath = [collectionView indexPathForCell:self.geWidget];
            }
        }
    };
    if ([NSThread currentThread].isMainThread) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void)getPageUid
{
    if (!_geWidget) {
        return;
    }
    dispatch_block_t block = ^{
        UIView *widget = _geSuperWidget ?: _geWidget;
        UIViewController *vc = (UIViewController *)[widget nextResponder];
        while (![vc isKindOfClass:[UIViewController class]] && vc) {
            vc = (UIViewController *)[vc nextResponder];
        }
        if (vc) {
            self.pageUid = vc.gePageUid;
        } else {
            self.pageUid = [[GEPageViewProcessor defaultProcessor] topViewController].gePageUid;
        }
    };
    if ([NSThread currentThread].isMainThread) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void)getPageReferUid
{
    if (!_geWidget) {
        return;
    }
    dispatch_block_t block = ^{
        UIView *widget = _geSuperWidget ?: _geWidget;
        UIViewController *vc = (UIViewController *)[widget nextResponder];
        while (vc) {
            if ([vc isKindOfClass:[UIViewController class]]) {
                self.gePageReferUid = vc.gePageReferUid;
                break;
            }
            vc = (UIViewController *)[vc nextResponder];
        }
        if (!self.gePageReferUid) {
            self.gePageReferUid = [[GEPageViewProcessor defaultProcessor] topViewController].gePageReferUid;
        }
    };
    if ([NSThread currentThread].isMainThread) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}


- (void)report
{
    if (!self.onReportFinish) {
        return;
    }
    if ([NSThread currentThread].isMainThread) {
        self.onReportFinish();
    } else {
        dispatch_async(dispatch_get_main_queue(), self.onReportFinish);
    }
}

- (void)resetWidgetTitle {
    //重新获取控件标题，防止在初始化和上报的这个时间段内标题发生变化
    if ([self.resource.cellWidget isKindOfClass:[UILabel class]]) {
        NSString *text = ((UILabel *)self.resource.cellWidget).text?:@"";
        if (text.length > 0) { //有文字内容时才添加
            self.resource.dictResource[@"widget_title"] = text;
        }
    } else if ([self.resource.cellWidget isKindOfClass:[UIButton class]]) {
        NSString *text = ((UIButton *)self.resource.cellWidget).currentTitle?:@"";
        if (text.length > 0) { //有文字内容时才添加
            self.resource.dictResource[@"widget_title"] = text;
        }
    }
}

@end



@implementation GEWidgetClickEvent

- (void)report
{
    if (![GEEnvironmentParameter defaultParameter].isInBackground) {
        [self resetWidgetTitle];
        [[GEWidgetProcessor defaultProcessor] reportClickEvent:self.resource.dictResource.copy?:[self dictionaryValue]];
    }
    
    [super report];
}

@end



@implementation GEWidgetExposeEvent

- (void)report
{
    if (![GEEnvironmentParameter defaultParameter].isInBackground) {
        [self resetWidgetTitle];
        [[GEWidgetProcessor defaultProcessor] reportExposeEvent:self.resource.dictResource.copy?:[self dictionaryValue]];
    }
    
    [super report];
    NSLog(@"reporting expose event: %@", self.indexPath);
}

- (void)regist {
    if (self.resource.tableWidget && ([self.resource.tableWidget isKindOfClass:[UITableView class]] || [self.resource.tableWidget isKindOfClass:[UICollectionView class]])) {
        UIScrollView *scrollView = (UIScrollView *)self.resource.tableWidget;
        [scrollView registerSubview:self.resource.cellWidget forExposeEvent:self];
    }
}

@end

@interface GEWidgetCustomEvent ()

@property (nonatomic, copy)     NSString *eventName;

@end

@implementation GEWidgetCustomEvent

+ (instancetype)eventWithResource:(GEWidgetResource *)resource eventName:(NSString *)eventName {
    GEWidgetCustomEvent *model = [self eventWithResource:resource];
    model.eventName = eventName;
    return model;
}

- (void)report
{
    NSAssert(self.eventName && self.eventName.length > 0, @"You must set the eventName");
    if (!self.eventName && self.eventName.length == 0) {
        return;
    }
    if (![GEEnvironmentParameter defaultParameter].isInBackground) {
        NSDictionary *dictParam = self.resource.dictResource.copy?:[self dictionaryValue];
        NSString *widgetUid = self.widgetUid?:[dictParam objectForKey:@"widget_uid"];
        NSParameterAssert(widgetUid);
        [[GEWidgetProcessor defaultProcessor] reportCustomEvent:self.eventName property:self.resource.dictResource.copy?:[self dictionaryValue]];
    }
    
    [super report];
    NSLog(@"reporting custom event: %@", self.eventName);
}

@end
