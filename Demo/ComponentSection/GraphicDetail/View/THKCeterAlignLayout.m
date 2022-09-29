//
//  THKCeterAlignLayout.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/27.
//

#import "THKCeterAlignLayout.h"

@implementation THKCeterAlignLayout


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSArray *attributesForElementsInRect = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newAttributesForElementsInRect = [[NSMutableArray alloc] initWithCapacity:attributesForElementsInRect.count];

    CGFloat leftMargin = self.sectionInset.left;
    NSMutableArray *lines = [NSMutableArray array];
    NSMutableArray *currLine = [NSMutableArray array];

    for (UICollectionViewLayoutAttributes *attributes in attributesForElementsInRect) {
        // Handle new line
        BOOL newLine = attributes.frame.origin.x <= leftMargin;
        if (newLine) {
            leftMargin = self.sectionInset.left; //will add outside loop
            currLine = [NSMutableArray arrayWithObject:attributes];
        } else {
            [currLine addObject:attributes];
        }

        if ([lines indexOfObject:currLine] == NSNotFound) {
            [lines addObject:currLine];
        }

        // Align to the left
        CGRect newLeftAlignedFrame = attributes.frame;
        newLeftAlignedFrame.origin.x = leftMargin;
        attributes.frame = newLeftAlignedFrame;

        leftMargin += attributes.frame.size.width + self.minimumInteritemSpacing;
        [newAttributesForElementsInRect addObject:attributes];
    }

    // Center left aligned lines
    for (NSArray *line in lines) {
        UICollectionViewLayoutAttributes *lastAttributes = line.lastObject;
        CGFloat space = CGRectGetWidth(self.collectionView.frame) - CGRectGetMaxX(lastAttributes.frame);

        for (UICollectionViewLayoutAttributes *attributes in line) {
            CGRect newFrame = attributes.frame;
            newFrame.origin.x = newFrame.origin.x + space / 2;
            attributes.frame = newFrame;

        }
    }

    return newAttributesForElementsInRect;
}
@end
