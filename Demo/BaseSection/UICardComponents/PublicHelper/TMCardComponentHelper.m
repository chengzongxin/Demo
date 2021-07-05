//
//  TMCardComponentHelper.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/9/7.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentHelper.h"
#import "TMCardComponentBaseListView.h"

@implementation TMCardComponentHelper


+ (void)registCardComponentCellsInCollectionView:(UICollectionView *)collectionView {
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout*)collectionView.collectionViewLayout;
    NSAssert([layout isKindOfClass:[CHTCollectionViewWaterfallLayout class]], @"the layout of collectionview should be kind of class :registCardComponentCellsInCollectionView");
    if (![layout isKindOfClass:[CHTCollectionViewWaterfallLayout class]]) {
        return;
    }
    
    NSArray<TMBasicCardCellIdentifier *> *cellIdentifiers = [TMCardComponentBaseListView allCellIdentifiers];
    for (TMBasicCardCellIdentifier *identifier in cellIdentifiers) {
        Class cellCls = [TMCardComponentBaseListView cellClassOfCellIdentifier:identifier];
        if (cellCls) {
            [collectionView registerClass:cellCls forCellWithReuseIdentifier:identifier];
        }
    }
}

+ (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(CHTCollectionViewWaterfallLayout*)layout
                cellData:(__kindof TMCardComponentCellDataModel *)cellData sectionInset:(UIEdgeInsets)inset {
    
    NSAssert([cellData isKindOfClass:[TMCardComponentCellDataModel class]], @"cellData should be kind of class : TMCardComponentCellDataModel");
    if ([cellData isKindOfClass:[TMCardComponentCellDataModel class]]) {
        if (CGSizeEqualToSize(CGSizeZero, cellData.layout_cellSize)) {
            if (cellData.style != TMCardComponentCellStyleCustom) {
                [TMCardComponentCellSizeTool loadCellSizeToCellDataIfNeed:cellData layout:(CHTCollectionViewWaterfallLayout*)collectionView.collectionViewLayout sectionInset:inset];
            }
        }
        return cellData.layout_cellSize;
    }
    
    return CGSizeZero;
}

+ (__kindof UICollectionViewCell<TMCardComponentCellProtocol> *)collectionViewCellInCollectionView:(UICollectionView *)collectionView
                                                             cellData:(__kindof TMCardComponentCellDataModel *)cellData
                                                        itemIndexPath:(NSIndexPath *)indexPath
                                                godEyeReportDataBlock:(void(^)(NSString **cellWidgetUid, NSDictionary **cellResource))godEyeReportDataBlock {
    
    NSAssert([cellData isKindOfClass:[TMCardComponentCellDataModel class]], @"cellData should be kind of class : TMCardComponentCellDataModel");
    if (![cellData isKindOfClass:[TMCardComponentCellDataModel class]]) {
        return nil;
    }
    
    TMBasicCardCellIdentifier *identifier = [TMCardComponentBaseListView cellIdentifierOfCellStyle:cellData.style];
    NSAssert(identifier.length > 0, @"cellData.style 不能为custom");
    
    if (identifier.length > 0) {
        UICollectionViewCell<TMCardComponentCellProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if ([cell conformsToProtocol:@protocol(TMCardComponentCellProtocol)]) {
            [cell updateUIElement:cellData];
        }else {
            NSAssert(NO, @"cell from style: %@ is kind of <%@> and must comforms to protocol : <%@>", @(cellData.style), NSStringFromClass(cell.class), NSStringFromProtocol(@protocol(TMCardComponentCellProtocol)));
        }
        
        //天眼埋点相关数据赋值
        NSString *geWidgetUid = nil;
        NSDictionary *geResource = nil;
        if (godEyeReportDataBlock) {
            godEyeReportDataBlock(&geWidgetUid, &geResource);
        }
//        cell.geWidgetUid = geWidgetUid;
//        cell.geResource = geResource;
//        if (geWidgetUid.length > 0) {
//            if (![cellData exposeFlag]) {
//                GEWidgetExposeEvent *event = [GEWidgetExposeEvent eventWithWidget:cell superWidget:collectionView indexPath:indexPath];
//                [event setOnReportFinish:^{
//                    [cellData setExposeFlag:YES];
//                }];
//                [collectionView registerSubview:cell forExposeEvent:event];
//            }
//        }
        
        return cell;
    }
        
    return nil;
}

@end
