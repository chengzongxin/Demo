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
// 点击修改
- (void)houseTypeEditClick:(UIView *)btn indexPath:(NSIndexPath *)indexPath;
// 点击搜索
- (void)searchAreaBtnClick:(UIView *)btn;
// 按住录音
- (void)recordBtnTouchDown:(UIButton *)btn;
// 松起录音
- (void)recordBtnTouchUp:(UIButton *)btn;
// 取消录音
- (void)cancelRecordVoice:(UIButton *)btn;
// 向上滑动 提示松开取消录音
- (void)upswipeCancelRecordVoice:(UIButton *)btn;
// 手指重新滑动到范围内 提示向上取消录音
- (void)downSwipeContinueRecordVoice:(UIButton *)btn;
// 播放录音
- (void)recordPlayClick:(UIView *)view idx:(NSUInteger)idx indexPath:(NSIndexPath *)indexPath;
// 删除录音
- (void)recordCloseClick:(UIView *)view idx:(NSUInteger)idx indexPath:(NSIndexPath *)indexPath;
// 输入文字
- (void)demandInput:(TMUITextView *)view text:(NSString *)text heightChange:(BOOL)heightChange height:(CGFloat)height indexPath:(NSIndexPath *)indexPath;

@end

@interface THKOnlineDesignBaseCell : UICollectionViewCell<THKOnlineDesignBaseCellProtocol>

@property (nonatomic, weak) id<THKOnlineDesignBaseCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) NSInteger selectIdx;

@end

NS_ASSUME_NONNULL_END
