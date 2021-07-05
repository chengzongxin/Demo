//
//  TMCardComponentRecommendTagsCell.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/8/19.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentRecommendTagsCell.h"

@interface TMCardComponentRecommendTagsCell()
@property (nonatomic, strong)NSObject<TMCardComponentCellDataProtocol> *data;
@end

@implementation TMCardComponentRecommendTagsCell

- (void)updateUIElement:(NSObject<TMCardComponentCellDataProtocol> *)data {
    self.data = data;
    
    if (data.insert.title.length > 0) {
        self.titleLabel.text = data.insert.title;
    }else {
        self.titleLabel.text = self.defaultTitleLabelText;
    }
    [self.tagNameLbls enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < data.insert.guideWords.count) {
            TMCardComponentDataInsertRecommendTagModel *guideWord = data.insert.guideWords[idx];
            obj.text = guideWord.content;
            obj.hidden = NO;
        }else {
            obj.text = nil;
            obj.hidden = YES;
        }
    }];
    
    [self.tagImgViews enumerateObjectsUsingBlock:^(YYAnimatedImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < data.insert.guideWords.count) {
            TMCardComponentDataInsertRecommendTagModel *guideWord = data.insert.guideWords[idx];
            [obj loadImageWithUrlStr:guideWord.imageUrl];
            obj.hidden = NO;
        }else {
            obj.image = nil;
            obj.hidden = YES;
        }
    }];
    [self.tagControls enumerateObjectsUsingBlock:^(UIControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < data.insert.guideWords.count) {
            obj.hidden = NO;
        }else {
            obj.hidden = YES;
        }
    }];
     
}

- (void)tagControlClick:(UIControl *)tagControl {
    NSInteger idx = tagControl.tag;
    if (idx < self.data.insert.guideWords.count) {
        NSString *routerStr = self.data.insert.guideWords[idx].targetUrl;
        if (routerStr.length > 0) {
            //默认按通用单一的路由跳转处理
            TRouter *router = [TRouter routerFromUrl:routerStr jumpController:self.tmui_viewController.navigationController];
            [[TRouterManager sharedManager] performRouter:router];
        }
    }
}

@end
