//
//  THKDiaryDirectoryServiceCell.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/30.
//

#import "THKDiaryDirectoryServiceCell.h"

@implementation THKDiaryDirectoryServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame{
    CGRect realFrame = frame;
    realFrame.size.width = 300;
    [super setFrame:realFrame];
}

@end
