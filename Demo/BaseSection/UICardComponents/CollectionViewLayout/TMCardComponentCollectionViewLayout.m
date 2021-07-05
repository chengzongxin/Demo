//
//  TMCardComponentCollectionViewLayout.m
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "TMCardComponentCollectionViewLayout.h"

@implementation TMCardComponentCollectionViewLayout

+ (instancetype)cardsCollectionLayout {
    
    TMCardComponentCollectionViewLayout *layout = [[[self class] alloc] init];
    layout.columnCount = 2;
    layout.minimumColumnSpacing = 7.0;
    layout.minimumInteritemSpacing = 10.0;
    layout.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    return layout;
}

@end
