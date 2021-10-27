//
//  THKDiaryListModel.m
//  HouseKeeper
//
//  Created by amby.qin on 2019/7/22.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "THKDiaryInfoModel.h"
//#import "THKConfigFileReader.h"
//#import "TSDiaryBookHelper.h"
//#import "THKCommunityFeedImagesView.h"
//#import "THKDiaryVideoInfoModel.h"
//#import "THKVideoDetailMinorRequest.h"
//#import "THKDiaryBookDetailModel.h"
//#import "THKShareMessageModel.h"
//#import "THKDiaryBookCell.h"

@implementation THKDiaryStageModel

@end

@implementation THKDiaryInfoModel

//@synthesize shareModel, godeyeProperties;

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"diaryId":@"id",
             @"imageList": @[@"imageVOList", @"imageList",@"images"],
             @"diaryBookDataModel":@"diaryBookVO",
             @"diaryBookDetailModel":@"diaryBookVO",
             @"videoInfoList":@"video",
             @"longitude":@"location.lon",
             @"latitude":@"location.lat",
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"productList": @"THKDiaryProductDataModel",
             @"comments": @"TInteractiveCommentViewModel",
             @"imageList": @"THKDiaryCommonImageModel",
             @"videoInfoList":@"THKDiaryVideoInfoModel"
    };
}

// 忽略归档属性，以下属性尚未实现coding协议
+ (NSArray *)mj_ignoredCodingPropertyNames{
    return @[@"comments",@"shareModel"];
}

//+ (id)createDiary {
//    THKDiaryInfoModel *diary = [[THKDiaryInfoModel alloc]init];
//    diary.auditStatus = THKDiaryStatusCreating;
////    diary.diaryBookId = [kCurrentUser.liveid integerValue];
////    NSInteger stateId = kCurrentUser.progress_id;
//    diary.stageBigName = [THKConfigFileReader progressNameWithId:stateId];// self.diary.progress_name;
//    diary.stageBigId =  stateId;
////    diary.createDate = @"刚刚";
//    return diary;
//}
//
//- (CGFloat)contentTopCH {
//    _contentTopCH = 20;
//    return _contentTopCH;
//}
//
//-(BOOL)isOwner{
//    
//    if (self.comeFormStyle == kDiaryComeFrom_PersonCeter) {
//        return NO;
//    }
//    
//    return (self.ownerId == [UID_TO8TO integerValue]);
//}
//
//-(BOOL)isOwnerDiary {
//    
//    if (self.comeFormStyle == kDiaryComeFrom_PersonCeter) {
//        return NO;
//    }
//    
//    return self.ownerId == [UID_TO8TO integerValue];//(self.ownerId == [UID_TO8TO integerValue] && _jianli_id==0);
//}
//
//- (CGFloat)productTotalPrice {
//    _productTotalPrice = 0.0;
//    
//    if (!self.productList || self.productList.count == 0) {
//        return _productTotalPrice;
//    }
//    
//    for (THKDiaryProductDataModel *listItem in self.productList) {
//        
//        if (![listItem isKindOfClass:[THKDiaryProductDataModel class]]) {
//           
//            continue;
//        }
//        
//        _productTotalPrice += listItem.totalPrice;
//    }
//    
//    return _productTotalPrice;
//}

//-(NSArray *)arrImgUrl{
//    NSMutableArray *arr = [NSMutableArray array];
//    [self.imageList enumerateObjectsUsingBlock:^(THKDiaryCommonImageModel *obj, NSUInteger idx, BOOL *stop) {
//        NSString *imgUrl = obj.imageUrl;
//        if (kUnNilStr(imgUrl).length == 0) {
//            imgUrl = obj.fileName;
//        }
//        [arr safeAddObject:imgUrl];
//    }];
//    return arr;
//}

- (BOOL)checkShieldCanAction {
    if (self.auditStatus == THKDiaryStatusShield) {
        [TMToast toast:@"日记被屏蔽，无法进行此操作！"];
        return NO;
    }
    return YES;
}

- (BOOL)checkRejectCanAction {
    if (self.auditStatus == THKDiaryStatusReject) {
        [TMToast toast:@"日记审核不通过，无法进行此操作！"];
        return NO;
    }
    return YES;
}

- (BOOL)checkSendingStatus {
    if (self.auditStatus == THKDiaryStatusPosting) {
        [TMToast toast:@"努力上传中，请稍后再试"];
        return NO;
    }
    if (self.auditStatus == THKDiaryStatusPostFail) {
        [TMToast toast:@"发布失败，请重试~"];        
        return NO;
    }
    return YES;
}

//-(void)deleteWithCompleteHandle:(T8TBOOLBlock)aBlock HUDVIew:(UIView *)aView {
//    //日记删除
//    THKDeleteDairyRequest *request = [[THKDeleteDairyRequest alloc] init];
//    request.diaryId = self.diaryId;
//    [request sendSuccess:^(THKResponse *response) {
//        if (response.status == THKStatusSuccess) {
//            if (aBlock) {
//                aBlock(YES);
//
//                [[NSNotificationCenter defaultCenter]postNotificationName:TSDiaryListVCUpdateNotification object:nil];
//            }
//        }else{
//            if (aBlock) {
//                aBlock(NO);
//            }
//        }
//
//    } failure:^(NSError * _Nonnull error) {
//        if (aBlock) {
//            aBlock(YES);
//        }
//    }];
//}

//- (NSInteger)totalTRow
//{
//    if (_totalTRow > 0) {
//        return _totalTRow;
//    }
//    NSInteger lines = [self.content numberOfLinesWithFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] contrainstedToWidth:kScreenWidth - UIEdgeInsetsGetHorizontalValue(kDiaryContentInset)];
//    _totalTRow = lines;
//    return _totalTRow;
//
//}
//
//- (BOOL)isMoreContentHidden
//{
//    //文字超过6行,折叠
//    return (self.totalTRow > 5);
//}
//
////- (void)setComments:(NSArray<TInteractiveCommentViewModel *> *)comments {
////    _comments = comments;
////}
//
//#pragma mark - 评论控件高度
//- (CGFloat)commentVH
//{
//    if (!self.comments || self.comments.count == 0) {
//        return 0.0;
//    }
//
//    if (_commentVH > 20.0) {
//        return _commentVH;
//    }
//
//    __block CGFloat commentCellH = 0.0;
//
//    [self.comments enumerateObjectsUsingBlock:^(TInteractiveCommentViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        if ([obj isKindOfClass:[THKDiaryCommonCommentModel class]]) {
//            if (idx == 3) {
//
//            }else if (idx > 3){
//                *stop = YES;
//            }else{
//                commentCellH += 20;//obj.commentHeight;
//            }
//        }
//
//    }];
//
//    //查看更多的高度
//    if (self.isNeedMoreComment) {
//        commentCellH += KNDiary_commentSeeMore_H;
//    }
//
//    //    CGFloat commentCellH = self.comments.count > 3 ? TPLNDairyCmitCellH * 3.0 + 30.0 : self.comments.count * TPLNDairyCmitCellH;
//
//    //添加上下间距
//    commentCellH += KNDiary_commentHF_Margin * 2.0;
//
//    return commentCellH;
//
//}
//
//- (BOOL)isListNeedFold
//{
//    //清单超过三个折叠
//    return (self.productList.count > 3);
//}
//
//- (BOOL)isNeedMoreComment
//{
//    //self.comment_number > 3 && self.comments.count >= 3
//    if (self.commentNum > 3 && self.comments.count >= 3) {
//        return YES;
//    }else{
//        return NO;
//    }
//}

-(NSTimeInterval)ctime{
    if (_ctime > 0) {
        return _ctime;
    }
    return _publishTime;
}


-(void)setWithDict:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [self mj_setKeyValues:dict];
}

//-(NSArray<THKDiaryProductDataModel *> *)productList{
//    if (_productVO) {
//        return @[_productVO];
//    }
//    return _productList;
//}
//
//
//
//- (THKCommunityFeedFlowSetImageModel *)cFlowImageModel
//{
//    //空数据处理
//    if (self.isVideo && (!_cFlowImageModel.webpThumb || !_cFlowImageModel.imgUrl)) {
//        _cFlowImageModel = nil;
//    }
//    if (!_cFlowImageModel) {
//        _cFlowImageModel = [[THKCommunityFeedFlowSetImageModel alloc] init];
//        if (self.isVideo && self.imageList && self.imageList.count > 0) {
//            THKDiaryCommonImageModel *videoImageModel = self.imageList.firstObject;
//            if ([videoImageModel isLocalFilePath]) {
//                CGSize imgSize = [UIImage imageWithContentsOfFile:videoImageModel.fileName].size;
//                videoImageModel.imageWidth = imgSize.width;
//                videoImageModel.imageHeight = imgSize.height;
//                _cFlowImageModel.imgUrl = videoImageModel.fileName;
//            }
//            _cFlowImageModel.width = videoImageModel.imageWidth;
//            _cFlowImageModel.height = videoImageModel.imageHeight;
//            _cFlowImageModel.webpThumb = videoImageModel.imageUrl;
//            [THKCommunityFeedImagesView calculateHeightOfImages:@[_cFlowImageModel] isVideo:YES];
//        }
//    }
//    return _cFlowImageModel;
//}


//- (CGSize)videoWidgetSize
//{
//    if (!self.isVideo || !self.cFlowImageModel) {
//        return CGSizeZero;
//    }
//    
//    if (_videoWidgetSize.width > 10 && !self.isNeedCalCellH) {
//        return _videoWidgetSize;
//    }
//
//    _videoWidgetSize = self.cFlowImageModel.itemFrame.size;
//    return _videoWidgetSize;
//}
//
//- (BOOL)isVideo {
//    if (self.videoId > 0 && self.diaryType == 1) {
//        return YES;
//    }
//    if (self.assetResourceModel && self.assetResourceModel.resourceType == THKAssetResourceType_Video) {
//        return YES;
//    }
//    return NO;
//}
//
//- (THKDiaryVideoInfoModel *)editVideoInfo {
//    if (self.videoInfoList) {
//        __block NSInteger size = 0;
//        __block THKDiaryVideoInfoModel *info = nil;
//        [self.videoInfoList enumerateObjectsUsingBlock:^(THKDiaryVideoInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.size < size || size == 0) {
//                info = obj;
//                size = obj.size;
//            }
//        }];
//        return info;
//    }
//    return nil;
//}

//- (void)updateVideoInfo:(T8TBOOLBlock)block {
//    THKVideoDetailMinorRequest *req = [[THKVideoDetailMinorRequest alloc] init];
//    req.videoIds = @[@(self.videoId)];
//    req.bizIds = @[@(self.diaryId)];
//    req.bizType = @"b0011";
//
//    @weakify(self);
//    [req sendSuccess:^(THKVideoDetailMinorResponse * _Nonnull response) {
//        @strongify(self)
//        if (response.status == THKStatusSuccess && response.itemsDics.count > 0 && response.itemsDics[0][@"video"]) {
//            self.videoInfoList = [THKDiaryVideoInfoModel mj_objectArrayWithKeyValuesArray:response.itemsDics[0][@"video"]];
//            !block ? : block(YES);
//        } else {
//            !block ? : block(NO);
//        }
//    } failure:^(NSError * _Nonnull error) {
//        !block ? : block(NO);
//    }];
//}
//
//-(THKShareMessageModel *)shareModel{
//    return [THKShareMessageModel modelWithMessageDic:self.shareData placeholderImageName:@"icon_share_case_strategy_diary.jpg"];
//}
//

#pragma mark - THKDraftCacheFillDataProtocol

+ (NSArray *)draftFillData {
    return @[@"imageList", @"content"];
}

+ (NSArray *)editNullData {
    return @[@"imageList", @"content"];
}



@end
