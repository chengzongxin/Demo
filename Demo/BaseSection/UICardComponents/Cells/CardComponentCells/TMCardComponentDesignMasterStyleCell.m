//
//  TMCardComponentDesignMasterStyleCell.m
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "TMCardComponentDesignMasterStyleCell.h"

@interface TMCardComponentDesignMasterStyleCell()
@property (nonatomic, strong)UILabel *titleLbl;
@property (nonatomic, strong)UIView *imgListBoxView;
@property (nonatomic, strong)NSArray<UIImageView *> *imgViews;
@property (nonatomic, strong)UILabel *subLbl;
@end

@implementation TMCardComponentDesignMasterStyleCell
TMCardComponentPropertyLazyLoad(UILabel, titleLbl);
TMCardComponentPropertyLazyLoad(UIView, imgListBoxView);
TMCardComponentPropertyLazyLoad(UILabel, subLbl);

- (NSArray<UIImageView *> *)imgViews {
    if (!_imgViews) {
        NSMutableArray *ls = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; ++i) {
            [ls safeAddObject:({
                UIImageView *iView = [[UIImageView alloc] init];
                iView.clipsToBounds = YES;
                iView.layer.borderColor = [UIColor whiteColor].CGColor;
                iView.layer.borderWidth = 1;
                iView.layer.cornerRadius = 8;
                iView.layer.allowsEdgeAntialiasing = YES;
                iView;
            })];
        }
        _imgViews = [NSArray arrayWithArray:ls];
    }
    return _imgViews;
}

- (void)loadSubUIElement {
    [super loadSubUIElement];
    
    [self.coverImgView addSubview:self.titleLbl];
    [self.coverImgView addSubview:self.imgListBoxView];
    self.imgListBoxView.clipsToBounds = YES;
    [self.coverImgView addSubview:self.subLbl];
    for (UIView *v in self.imgViews) {
        [self.imgListBoxView addSubview:v];
        v.hidden = YES;
    }
        
    [self.imgListBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(24);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(16);
    }];
    [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.imgListBoxView.mas_centerY);
        make.leading.mas_equalTo(self.imgListBoxView.mas_trailing).mas_offset(7);
        make.trailing.mas_equalTo(-16);
    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.imgListBoxView.mas_bottom).mas_offset(10);
    }];
    
    for (NSInteger i = 0; i < self.imgViews.count; ++i) {
        UIView *v = self.imgViews[i];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(16);
            make.centerY.mas_equalTo(self.imgListBoxView.mas_centerY);
            make.leading.mas_equalTo(i * 13);
        }];
    }
    
    //
    self.titleLbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.titleLbl.textColor = [UIColor whiteColor];
    self.titleLbl.numberOfLines = 2;
    
    self.subLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.subLbl.textColor = [UIColor whiteColor];
    
#if DEBUG
    MASAttachKeys(self.titleLbl, self.subLbl, self.imgListBoxView);
#endif
    
}

- (void)updateUIElement:(NSObject<TMCardComponentCellDataProtocol> *)data {
    [super updateUIElement:data];
    
    self.titleLbl.text = data.cover.title.length > 0 ? data.cover.title : nil;
    self.subLbl.text = data.cover.subTitle.length > 0 ? data.cover.subTitle : nil;
    
    //处理头像视图
    NSInteger count = MIN(4, data.cover.imgs.count);
    float imgListBoxWidth = 0;
    if (count == 1) {
        imgListBoxWidth = 16;
    }else if (count > 1 && count <= 4) {
        imgListBoxWidth = 13 * (count-1) + 16;
    }
    [self.imgListBoxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(imgListBoxWidth);
    }];
    [self.subLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.imgListBoxView.mas_trailing).mas_offset(imgListBoxWidth > 0 ? 7 : 0);
    }];
    
    for (NSInteger i = 0; i < self.imgViews.count; ++i) {
        if (i < count) {
            self.imgViews[i].hidden = NO;
            [TMCardComponentTool loadNetImageInImageView:self.imgViews[i]
                             imUrl:data.cover.imgs[i]
            finishPlaceHolderImage:[TMCardComponentTool authorAvatarPlaceHolderImage]];
        }else {
            self.imgViews[i].hidden = YES;
        }
    }
}

@end
