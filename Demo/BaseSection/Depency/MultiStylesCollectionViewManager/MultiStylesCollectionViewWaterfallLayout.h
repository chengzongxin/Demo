//
//  MultiStylesCollectionViewWaterfallLayout.h
//  HouseKeeper
//
//  Created by nigel.ning on 2019/4/1.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "CHTCollectionViewWaterfallLayout.h"

@interface MultiStylesCollectionViewWaterfallLayout : CHTCollectionViewWaterfallLayout

@property (nonatomic, copy)BOOL (^lockHeaderAtTopBlock)(NSIndexPath *indexPath);

@end

