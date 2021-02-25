//
//  ListCell.h
//  Demo
//
//  Created by Joe.cheng on 2021/2/8.
//

#import <UIKit/UIKit.h>
#import "THKAvatarView.h"
#import "THKIdentityView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet THKAvatarView *avatar;
@property (weak, nonatomic) IBOutlet THKIdentityView *identity;
@property (weak, nonatomic) IBOutlet THKIdentityView *identityIconText;

@property(nonatomic, strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
