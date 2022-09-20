//
//  THKGraphicDetailVM.h
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import "THKViewModel.h"
#import "THKMeituDetailv2Request.h"
#import "THKRequestCommand.h"
#import "THKGraphicDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKGraphicDetailVM : THKViewModel

@property (nonatomic, strong, readonly) THKRequestCommand *requestCommand;

@property (nonatomic, copy, readonly) NSArray <THKGraphicDetailContentListItem *> *contentList;

@end

NS_ASSUME_NONNULL_END
