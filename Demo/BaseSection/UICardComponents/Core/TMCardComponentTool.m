//
//  TMCardComponentTool.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/4/8.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentTool.h"
#import "TMCardComponentDataInfoObjects.h"

@implementation TMCardComponentTool

+ (void)loadNetImageInImageView:(UIImageView *)imgView
                          imUrl:(NSString *)imgUrl
         finishPlaceHolderImage:(UIImage *)placeHolderImage {
    if(imgUrl.length == 0) {
        imgView.image = placeHolderImage;
    }else {
        if (nil == placeHolderImage) {
            //若无加载失败的占位图，则直接调用加载网络图片接口
            [imgView loadImageWithUrlStr:imgUrl];
            return;
        }
        
        @weakify(imgView);
        //指定图片加载完显示时fade过渡效果: YYWebImageOptionSetImageWithFadeAnimation
        [imgView loadImageWithUrlStr:imgUrl placeholderImage:nil options:YYWebImageOptionSetImageWithFadeAnimation manager:nil progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            @strongify(imgView);
            if (!image) {
                //若未加载到图片数据则用指定的占位图
                imgView.image = placeHolderImage;
            }
        }];
    }
}

+ (UIImage *)authorAvatarPlaceHolderImage {
    return [UIImage imageNamed:@"cardComponent_authorPlaceholderImg"];
}

+ (void)updateSubIconView:(UIImageView *)iconView subIcon:(TMCardComponentDataCoverSubIcon *)subIcon {
    if (nil == subIcon) {
        iconView.hidden = YES;
        iconView.image = nil;
        return;
    }
    
    BOOL canShow = YES;
    if (subIcon.localImgName.length > 0) {
        iconView.image = [UIImage imageNamed:subIcon.localImgName];
        if (!iconView.image) {
            canShow = NO;
        }
    }else if (subIcon.imgUrl.length > 0) {
        [TMCardComponentTool loadNetImageInImageView:iconView
                                               imUrl:subIcon.imgUrl
                              finishPlaceHolderImage:nil];
    }else {
        canShow = NO;
    }
    if (canShow) {
        iconView.hidden = NO;
        [iconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(subIcon.layout_width);
            make.height.mas_equalTo(subIcon.layout_height);
        }];
    }else {
        iconView.hidden = NO;
        iconView.image = nil;
    }
}

@end
