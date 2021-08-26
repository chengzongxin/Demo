//
//  THKDiaryBookInfoViewModel.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/24.
//

#import "THKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDiaryBookInfoViewModel : THKViewModel
/// 封面图
@property (nonatomic, strong, readonly) NSString *coverImgUrl;
/// 日记本标题
@property (nonatomic, strong, readonly) NSAttributedString *titleAttr;
/// 房屋信息
@property (nonatomic, strong, readonly) NSAttributedString *houseInfoAttr;
/// 装修清单
@property (nonatomic, assign, readonly) BOOL hasShoppingList;
/// 公司信息
@property (nonatomic, strong, readonly) NSAttributedString *companyInfoAttr;


@end

NS_ASSUME_NONNULL_END
