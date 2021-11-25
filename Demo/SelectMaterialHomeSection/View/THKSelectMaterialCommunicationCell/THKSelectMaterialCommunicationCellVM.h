//
//  THKSelectMaterialCommunicationCellVM.h
//  Demo
//
//  Created by Joe.cheng on 2021/11/24.
//

#import "THKViewModel.h"
#import "THKAvatarViewModel.h"
#import "THKMaterialCommunicateListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKSelectMaterialCommunicationCellVM : THKViewModel

@property (nonatomic, strong, readonly) THKMaterialCommunicateListModel *model;
@property (nonatomic, strong, readonly) THKAvatarViewModel *avatarVM;
//@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSAttributedString *name;
@property (nonatomic, strong, readonly) NSAttributedString *tags;
@property (nonatomic, strong, readonly) NSAttributedString *content;
//@property (nonatomic, strong, readonly) NSString *diaryBook;
//@property (nonatomic, strong, readonly) NSArray <THKDecorationDiaryImages *>*imageList;
//@property (nonatomic, strong, readonly) TInteractiveModel *interactiveModel;
@property (nonatomic, strong, readonly) NSString *companyLogo;
@property (nonatomic, strong, readonly) NSString *companyName;
@property (nonatomic, strong, readonly) NSString *companyTag;

/// 点击展开按钮
@property (nonatomic, strong, readonly) RACSubject *clickUnfoldSignal;
/// 点击日记本链接
@property (nonatomic, strong, readonly) RACSubject *clickDiarySignal;
/// 点击头像
@property (nonatomic, strong, readonly) RACSubject *clickAvatarSignal;
/// 点击图片
@property (nonatomic, strong, readonly) RACSubject *clickImagesSignal;
/// 点击装修公司
@property (nonatomic, strong, readonly) RACSubject *clickCompanySignal;
/// 点击签约业主
@property (nonatomic, strong, readonly) RACSubject *clickSignUserSignal;
/// 点击装修清单
@property (nonatomic, strong, readonly) RACSubject *clickShoppingListSignal;
@end

NS_ASSUME_NONNULL_END
