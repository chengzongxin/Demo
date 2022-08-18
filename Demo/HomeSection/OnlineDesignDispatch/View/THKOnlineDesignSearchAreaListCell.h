//
//  THKOnlineDesignSearchAreaListCell.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import <UIKit/UIKit.h>
#import "THKOnlineDesignAreaListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKOnlineDesignSearchAreaListCell : UITableViewCell

@property (nonatomic, strong) NSString *keyWord;

@property (nonatomic, strong) THKOnlineDesignAreaListDataItem *model;

@end

NS_ASSUME_NONNULL_END
