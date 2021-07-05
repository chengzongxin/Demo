//
//  QuickMethod.m
//  Demo
//
//  Created by Joe.cheng on 2021/7/5.
//

#import "QuickMethod.h"
#import <objc/runtime.h>
UIColor *kTo8toGreen;

@implementation QuickMethod
@end


@implementation UIViewController (TCategory)

- (BOOL)navBarHidden {
    kTo8toGreen = UIColor.greenColor;
    BOOL hidden = [objc_getAssociatedObject(self, _cmd) boolValue];
    return hidden;
}

- (void)setNavBarHidden:(BOOL)navBarHidden {
    objc_setAssociatedObject(self, @selector(navBarHidden), @(navBarHidden), OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - api

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)previousViewController {
    NSArray* viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1) {
        NSUInteger controllerIndex = [viewControllers indexOfObject:self];
        if (controllerIndex != NSNotFound && controllerIndex > 0) {
            return [viewControllers objectAtIndex:controllerIndex-1];
        }
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)nextViewController {
    NSArray* viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1) {
        NSUInteger controllerIndex = [viewControllers indexOfObject:self];
        if (controllerIndex != NSNotFound && controllerIndex+1 < viewControllers.count) {
            return [viewControllers objectAtIndex:controllerIndex+1];
        }
    }
    return nil;
}


#pragma mark - api

- (void)navBackAction:(id)sender {
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -

- (void)t_presentViewController:(UIViewController *)viewControllerToPresent
                      animated:(BOOL)flag
                    completion:(void (^)(void))completion {
    
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
    
    UIViewController *rootVc;
    if ([currentWindow rootViewController].presentedViewController) {
        rootVc = [currentWindow rootViewController].presentedViewController;
    } else {
        rootVc = [currentWindow rootViewController];
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewControllerToPresent];
    
    [rootVc presentViewController:nav animated:flag completion:completion];
}


@end

@implementation UIImage (QuickMethod)

+ (UIImage *)imgAtBundleWithName:(NSString *)imageName {
    if (![imageName isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString *imgPath = [[NSBundle mainBundle]pathForResource:[self fullImgNameWithName:imageName] ofType:@""];
    UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
    
    // 使用Images Assets 时候使用imageNamed方法
    if (!img) {
        img = [UIImage imageNamed:imageName];
    }
    
    if (!img && imageName.length>0) {
        if ([[UIScreen mainScreen]scale]>2) {//没有3x图片使用2x图片代替
            imgPath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@@2x.png",imageName] ofType:@""];
            img = [UIImage imageWithContentsOfFile:imgPath];
            return img;
        }
        
        TMUI_DEBUG_Code(
                         [NSString stringWithFormat:@"no img for imageName:%@ imgPath:%@",imageName,imgPath];
                         )
        
    }
    return img;
}

+ (NSString *)fullImgNameWithName:(NSString *)imageName {
    if (![imageName isKindOfClass:[NSString class]] || imageName.length<1) {
        return @"";
    }
    if ([imageName rangeOfString:@"."].length>0) {
        return imageName;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ([[UIScreen mainScreen]respondsToSelector:@selector(scale)] && [[UIScreen mainScreen]scale] == 2) {
            return [NSString stringWithFormat:@"%@@2x.png",imageName];
        }else{
            return [NSString stringWithFormat:@"%@.png",imageName];
        }
    } else {
        NSInteger scale = (NSInteger)[[UIScreen mainScreen]scale];
        if (scale<2) {//iphone端不考虑1x的图片
            scale = 2;
        }
        return [NSString stringWithFormat:@"%@@%@x.png",imageName,@(scale)];
    }
}


@end


@implementation UIImageView (QuickMethod)

- (void)loadImageWithUrlStr:(NSString *)urlStr{
    [self setImageURL:[NSURL URLWithString:urlStr]];
}

- (void)loadImageWithUrlStr:(NSString *)urlStr placeHolderImage:(UIImage *)img_holder {
//    [self loadImageWithUrlStr:urlStr placeHolderImage:img_holder finishedBlock:nil];
    [self loadImageWithUrlStr:urlStr];
}


- (void)loadImageWithUrlStr:(NSString *)urlStr placeholderImage:(UIImage *)img_holder options:(YYWebImageOptions)options manager:(YYWebImageManager *)manager progress:(YYWebImageProgressBlock)progress transform:(YYWebImageTransformBlock)transform completion:(YYWebImageCompletionBlock)completion{
    [self setImageURL:[NSURL URLWithString:urlStr]];
}

@end


@implementation NSArray (Safe)

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    } else {
        return [self objectAtIndex:index];
    }
}

+ (instancetype)safeArrayWithObject:(id)object
{
    if (object == nil) {
        return [self array];
    } else {
        return [self arrayWithObject:object];
    }
}

- (instancetype)safeInitWithObjects:(const id  _Nonnull     __unsafe_unretained *)objects count:(NSUInteger)cnt
{
    BOOL hasNilObject = NO;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (objects[i] == nil) {
            hasNilObject = YES;
#if DEBUG
            NSString *errorMsg = [NSString stringWithFormat:@"数组元素不能为nil，其index为: %lu", (unsigned long)i];
            NSCAssert(objects[i] != nil, errorMsg);
#endif
        }
    }
    
    // 过滤掉值为nil的元素
    if (hasNilObject) {
        id __unsafe_unretained newObjects[cnt];
        NSUInteger index = 0;
        for (NSUInteger i = 0; i < cnt; ++i) {
            if (objects[i] != nil) {
                newObjects[index++] = objects[i];
            }
        }
        return [self safeInitWithObjects:newObjects count:index];
    }
    return [self safeInitWithObjects:objects count:cnt];
}


- (NSMutableArray *)mutableDeepCopy
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    for(id oneValue in self) {
        id oneCopy = nil;
        
        if([oneValue respondsToSelector:@selector(mutableDeepCopy)]) {
            oneCopy = [oneValue mutableDeepCopy];
        } else if([oneValue conformsToProtocol:@protocol(NSMutableCopying)]) {
            oneCopy = [oneValue mutableCopy];
        } else if([oneValue conformsToProtocol:@protocol(NSCopying)]){
            oneCopy = [oneValue copy];
        } else {
            oneCopy = oneValue;
        }
        
        [returnArray addObject:oneCopy];
    }
    
    return returnArray;
}

- (BOOL)safeKindofElementClass:(Class)elementClass {
    if (![self isKindOfClass:[NSArray class]]) {
        return NO;
    }
    for (id e in self) {
        if (![e isKindOfClass:elementClass]) {
            return NO;
        }
    }
    return YES;
}
@end


@implementation NSAttributedString (QuickMethod)

+ (CGFloat)heightForAtsWithStr:(NSString *)str font:(UIFont *)ft width:(CGFloat)w lineH:(CGFloat)lh{
    return [self tmui_heightForString:str font:ft width:w lineSpacing:lh];
}

+ (CGFloat)heightForAtsWithStr:(NSString *)str font:(UIFont *)ft width:(CGFloat)w lineH:(CGFloat)lineGap maxLine:(NSUInteger)lineNum{
    return [self tmui_heightForString:str font:ft width:w lineSpacing:lineGap maxLine:lineNum];
}

@end

@implementation NSMutableArray (safe)


- (void)safeAddObject:(id)object
{
    if (object == nil) {
        return;
    } else {
        [self addObject:object];
    }
}

- (void)safeInsertObject:(id)object atIndex:(NSUInteger)index
{
    if (object == nil) {
        return;
    } else if (index > self.count) {
        return;
    } else {
        [self insertObject:object atIndex:index];
    }
}

- (void)safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexs
{
    if (indexs == nil) {
        return;
    } else if (indexs.count!=objects.count || indexs.firstIndex>self.count) {
        return;
    } else {
        [self insertObjects:objects atIndexes:indexs];
    }
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return;
    } else {
        [self removeObjectAtIndex:index];
    }
}

@end



@implementation NSDictionary (NilSafe)


- (id)safeObjectForKey:(id)key {
    if (!key || ![self isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id obj = [self objectForKey:key];
    return obj;
}

- (NSString *)safeStringForKey:(id)key {
    
    if (!key || ![self isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSString *string = [self objectForKey:key];
    if ([string isKindOfClass:[NSNumber class]]) {
        string = [NSString stringWithFormat:@"%@",string];
    }
    
    if (![string isKindOfClass:[NSString class]]) {
        string = nil;
    }
    return string;
}


- (NSArray *)safeArrayForKey:(id)key {
    if (!key || ![self isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSArray *array = [self objectForKey:key];
    if (![array isKindOfClass:[NSArray class]]) {
        array = nil;
    }
    return array;
}

- (NSDictionary *)safeDictionaryForKey:(id)key {
    if (!key|| ![self isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dictionary = [self objectForKey:key];
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        dictionary = nil;
    }
    return dictionary;
}


@end



