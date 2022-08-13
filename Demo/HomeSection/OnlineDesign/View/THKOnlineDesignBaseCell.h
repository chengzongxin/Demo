//
//  THKOnlineDesignCell.h
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol THKOnlineDesignBaseCellProtocol <NSObject>

- (void)setupSubviews;

- (void)bindWithModel:(id)model;

@end

@protocol THKOnlineDesignBaseCellDelegate <NSObject>

- (void)searchAreaBtnClick:(UIButton *)btn;
// 按住录音
- (void)recordBtnTouchDown:(UIButton *)btn;
// 松起录音
- (void)recordBtnTouchUp:(UIButton *)btn;

@end

@interface THKOnlineDesignBaseCell : UICollectionViewCell<THKOnlineDesignBaseCellProtocol>

@property (nonatomic, weak) id<THKOnlineDesignBaseCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
