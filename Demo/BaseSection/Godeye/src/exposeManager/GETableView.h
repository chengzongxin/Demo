//
//  GETableView.h
//  THKMyTestApp
//
//  Created by amby.qin on 2020/12/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (GEExpose)

@property (nonatomic, strong)   UIScrollView    *nestScrollView;//是否有嵌套的列表并且只对嵌套列表进行曝光

@end

/**
 用于天眼曝光，如果你的TableView需要曝光，则使用GETableView
 */
@interface GETableView : UITableView

@end

NS_ASSUME_NONNULL_END
