//
//  TMEmptyView+THKOnlineDesignEmptyView.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/18.
//

#import "TMEmptyView+THKOnlineDesignEmptyView.h"
#import "TMEmptyContentItem.h"
#import "THKOnlineDesignUploadNoHouseTypeView.h"

@implementation TMEmptyView (THKOnlineDesignEmptyView)

+ (instancetype)showOnlineDesignEmptyInView:(UIView *)view safeMargin:(UIEdgeInsets)margin contentType:(TMEmptyContentType)contentType configContentBlock:(void (^)(NSObject<TMEmptyContentItemProtocol> * _Nonnull))configContentBlock clickBlock:(void (^)(void))block{
    TMEmptyView *emptyView = [TMEmptyView showEmptyInView:view safeMargin:margin contentType:TMEmptyContentTypeNoData configContentBlock:^(NSObject<TMEmptyContentItemProtocol> * _Nonnull content) {
        NSLog(@"%@",content);
        content.title = @" ";
        content.desc = nil;
    } clickBlock:block];
    
    TMEmptyContentItem *item = [TMEmptyContentItem new];
    configContentBlock(item);
    
    UIView *contentView = [[UIView alloc] initWithFrame:emptyView.bounds];
    [emptyView addSubview:contentView];
    
    UILabel *titleLbl = [UILabel new];
    titleLbl.textColor = UIColorPlaceholder;
    titleLbl.font = UIFont(14);
    titleLbl.text = item.title;
    [contentView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(160);
        make.centerX.equalTo(contentView);
    }];
    
    THKOnlineDesignUploadNoHouseTypeView *noHouseTypeView = [THKOnlineDesignUploadNoHouseTypeView new];
    [contentView addSubview:noHouseTypeView];
    [noHouseTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView).inset(20);
        make.top.equalTo(titleLbl.mas_bottom).offset(30);
        make.height.mas_equalTo(75);
    }];
    noHouseTypeView.clickUploadBlock = block;
    
    return emptyView;
}
@end
