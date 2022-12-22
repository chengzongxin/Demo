//
//  THKDecPKCompanyModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/12/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKDecPKCompanyModel : NSObject

//@ApiModelProperty(value = "用户id")
@property (nonatomic, assign) NSInteger uid;

//@ApiModelProperty(value = "装企名称")
@property (nonatomic, strong) NSString *authorName;

//@ApiModelProperty(value = "装企头像")
@property (nonatomic, strong) NSString *authorAvatar;

//@ApiModelProperty(value = "好评的文案")
@property (nonatomic, strong) NSString *goodRateText;

//@ApiModelProperty(value = "好评")
@property (nonatomic, assign) float goodRate;

//@ApiModelProperty(value = "案例数的文案")
@property (nonatomic, strong) NSString *caseNumText;

//@ApiModelProperty(value = "案例数")
@property (nonatomic, assign) NSInteger caseNum;

//@ApiModelProperty(value = "近半年咨询人数的文案")
@property (nonatomic, strong) NSString *consultantNumText;

//@ApiModelProperty(value = "近半年咨询人数")
@property (nonatomic, assign) NSInteger consultantNum;

//@ApiModelProperty(value = "擅长风格名称")
@property (nonatomic, strong) NSString *styleName;

//@ApiModelProperty(value = "设计师数量")
@property (nonatomic, assign) NSInteger designerNum;

//@ApiModelProperty(value = "选中状态 1-已选中 0/null-未选中")
@property (nonatomic, assign) NSInteger selectedStatus;

@end


@interface THKDecPKModel : NSObject
//@ApiModelProperty(value = "一级标题")
@property (nonatomic, strong) NSString *firstTitle;

//    @ApiModelProperty(value = "一级标题旁边按钮的文案")
@property (nonatomic, strong) NSString *firstButtonText;

//    @ApiModelProperty(value = "一级标题旁边按钮的路由")
@property (nonatomic, strong) NSString *firstButtonRouter;

//    @ApiModelProperty(value = "一级标题下的图片")
@property (nonatomic, strong) NSString *firstImg;

//    @ApiModelProperty(value = "二级标题")
@property (nonatomic, strong) NSString *secondTitle;

//    @ApiModelProperty(value = "二级标题旁边按钮的文案")
@property (nonatomic, strong) NSString *secondButtonText;

//    @ApiModelProperty(value = "二级标题旁边按钮的路由")
@property (nonatomic, strong) NSString *secondButtonRouter;

//    @ApiModelProperty(value = "装企信息列表")
@property (nonatomic, strong) NSArray <THKDecPKCompanyModel *> *companyInfoList;

//    @ApiModelProperty(value = "底部按钮文案")
@property (nonatomic, strong) NSString *bottomButtonText;

//    @ApiModelProperty(value = "底部icon")
@property (nonatomic, strong) NSString *bottomIcon;

//    @ApiModelProperty(value = "底部文案")
@property (nonatomic, strong) NSString *bottomText;

//    @ApiModelProperty(value = "底部文案路由")
@property (nonatomic, strong) NSString *bottomTextRouter;

@end
NS_ASSUME_NONNULL_END
