//
//  THKSelectMaterialCommunicationCellVM.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/24.
//

#import "THKSelectMaterialCommunicationCellVM.h"

@interface THKSelectMaterialCommunicationCellVM ()

//@property (nonatomic, strong) THKDecorationDiaryListModel *model;

@property (nonatomic, strong) THKAvatarViewModel *avatarVM;
@property (nonatomic, strong) NSAttributedString *name;
@property (nonatomic, strong) NSAttributedString *tags;
@property (nonatomic, strong) NSAttributedString *content;
//@property (nonatomic, strong) NSString *diaryBook;
//@property (nonatomic, strong) NSArray <THKDecorationDiaryImages *>*imageList;
//@property (nonatomic, strong) TInteractiveModel *interactiveModel;
@property (nonatomic, strong) NSString *companyLogo;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *companyTag;

@property (nonatomic, strong) RACSubject *clickUnfoldSignal;
@property (nonatomic, strong) RACSubject *clickDiarySignal;
@property (nonatomic, strong) RACSubject *clickAvatarSignal;
@property (nonatomic, strong) RACSubject *clickImagesSignal;
@property (nonatomic, strong) RACSubject *clickCompanySignal;
@property (nonatomic, strong) RACSubject *clickSignUserSignal;
@property (nonatomic, strong) RACSubject *clickShoppingListSignal;
//@property (nonatomic, assign) BOOL isFold;

// private
@property (nonatomic, strong) NSAttributedString *contentAttr;

@property (nonatomic, assign) CGFloat contentlimitHeight;
@end

@implementation THKSelectMaterialCommunicationCellVM

- (void)initialize{
    NSLog(@"%@",self.model);
    
//    self.avatarVM = [[THKAvatarViewModel alloc] initWithAvatarUrl:self.model.userInfo.authorAvatar identityType:self.model.userInfo.identificationType identitySubType:self.model.userInfo.subCategory];
//    
////    self.name = self.model.userInfo.authorName;
//    
//    self.name = self.model.nameAttrString;
//    self.tags = self.model.houseInfoAttrString;
//    self.content = self.model.contentAttrString;
//    self.diaryBook = [self.model.bookInfo.title tmui_trim];
//    self.imageList = self.model.diaryInfo.images;
////    self.interactiveModel = [self interactiveViewModel];
//    self.companyLogo = self.model.companyInfo.logoURL;
//    self.companyName = self.model.companyInfo.shortName?:@"";
//    self.companyTag = @"提供服务";
    
    self.name = [NSAttributedString tmui_attributedStringWithString:@"土巴兔小王" lineSpacing:10];;
    self.tags = [NSAttributedString tmui_attributedStringWithString:@"土巴兔资深质检师" lineSpacing:10];
    self.content = [NSAttributedString tmui_attributedStringWithString:@"暴力测评👷‍♂️二十年经验的装修工人为你们揭秘挑选瓷砖的秘密" lineSpacing:10];
    
}

//- (TInteractiveModel *)interactiveViewModel{
//    TInteractiveModel *interactiveModel = [[TInteractiveModel alloc] init];
//    interactiveModel.moduleCode = TInteractiveHelperModuleCodeOfType(TCollectType_Diary);
//    interactiveModel.objId = self.model.diaryInfo.id;
//    interactiveModel.isPraise = 99;//self.model.isPraise;
//    interactiveModel.isCollect = 100;//self.model.isCollect;
//    interactiveModel.praiseCount = 101;//self.model.praiseNum;
//    interactiveModel.commentCount = 102;//self.model.commentNum;
//    interactiveModel.collectCount = 103;//self.model.collectNum;
//    interactiveModel.customCommentReport = YES;
//    interactiveModel.authorUid = self.model.userInfo.uid;//self.model.ownerId;
//    return interactiveModel;
//}


TMUI_PropertyLazyLoad(RACSubject, clickUnfoldSignal)
TMUI_PropertyLazyLoad(RACSubject, clickDiarySignal)
TMUI_PropertyLazyLoad(RACSubject, clickAvatarSignal)
TMUI_PropertyLazyLoad(RACSubject, clickImagesSignal)
TMUI_PropertyLazyLoad(RACSubject, clickCompanySignal)
TMUI_PropertyLazyLoad(RACSubject, clickSignUserSignal)
TMUI_PropertyLazyLoad(RACSubject, clickShoppingListSignal)

@end
