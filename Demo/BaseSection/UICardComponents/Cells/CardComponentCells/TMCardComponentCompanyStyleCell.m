//
//  TMCardComponentCompanyStyleCell.m
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "TMCardComponentCompanyStyleCell.h"

@interface TMCardComponentCompanyStyleCell()
@property (nonatomic, strong)UIImageView *imgView;
@property (nonatomic, strong)UILabel *titleLbl;
@property (nonatomic, strong)UILabel *subLbl;
@property (nonatomic, strong)UIImageView *adIconView;///< 装修公司图片左下角展示的广告样式装饰视图
@end

@implementation TMCardComponentCompanyStyleCell
TMCardComponentPropertyLazyLoad(UILabel, titleLbl);
TMCardComponentPropertyLazyLoad(UIImageView, imgView);
TMCardComponentPropertyLazyLoad(UILabel, subLbl);


- (void)loadSubUIElement {
    [super loadSubUIElement];
    
    [self.coverImgView addSubview:self.imgView];
    [self.coverImgView addSubview:self.titleLbl];
    [self.coverImgView addSubview:self.subLbl];
    
    self.imgView.clipsToBounds = YES;
    self.imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imgView.layer.borderWidth = 0.5;
    self.imgView.layer.cornerRadius = 9;
    self.imgView.layer.allowsEdgeAntialiasing = YES;
        
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(24);
        make.width.height.mas_equalTo(18);
    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.imgView.mas_trailing).mas_offset(8);
        make.trailing.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.imgView.mas_centerY);
    }];
    [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.imgView.mas_bottom).mas_offset(10);
    }];
    //
    self.titleLbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.titleLbl.textColor = [UIColor whiteColor];
    
    self.subLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.subLbl.textColor = [UIColor whiteColor];
    
    self.adIconView = [[UIImageView alloc] init];
    self.adIconView.hidden = YES;
    self.adIconView.clipsToBounds = YES;
    self.adIconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.coverImgView addSubview:self.adIconView];
    [self.adIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(0);
    }];

#if DEBUG
    MASAttachKeys(self.titleLbl, self.subLbl, self.imgView);
#endif
    
}

- (void)updateUIElement:(NSObject<TMCardComponentCellDataProtocol> *)data {
    [super updateUIElement:data];
    
    self.titleLbl.text = data.cover.title.length > 0 ? data.cover.title : nil;
    self.subLbl.text = data.cover.subTitle.length > 0 ? data.cover.subTitle : nil;
    
    //处理头像视图
    NSInteger count = MIN(4, data.cover.imgs.count);
    self.imgView.hidden = count > 0 ? NO : YES;
    if (count > 0) {        
        [TMCardComponentTool loadNetImageInImageView:self.imgView
                                               imUrl:data.cover.imgs[0]
                              finishPlaceHolderImage:[TMCardComponentTool authorAvatarPlaceHolderImage]];
        
        [self.titleLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.imgView.mas_trailing).mas_offset(8);
        }];
    }else {
        self.imgView.image = nil;
        [self.titleLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.imgView.mas_trailing).mas_offset(-18);
        }];
    }
    
    //处理其它广告装饰视图
    if (self.data.cover.subIcons.count == 0) {
        self.adIconView.hidden = YES;
        self.adIconView.image = nil;
    }else {
        TMCardComponentDataCoverSubIcon *subIcon = self.data.cover.subIcons.firstObject;
        [TMCardComponentTool updateSubIconView:self.adIconView subIcon:subIcon];
    }
}

@end
