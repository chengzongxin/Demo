//
//  THKGraphicDetailSectionHeaderView.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THKGraphicDetailSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong, readonly) UILabel *titleLbl;

@property (nonatomic, strong) NSString *text;

@end

NS_ASSUME_NONNULL_END
