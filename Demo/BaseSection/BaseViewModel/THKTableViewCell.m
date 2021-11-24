//
//  THKTableViewCell.m
//  HouseKeeper
//
//  Created by kevin.huang on 15-3-13.
//  Copyright (c) 2015年 binxun. All rights reserved.
//

#import "THKTableViewCell.h"

@interface THKTableViewCell()

@property (nonatomic,strong) id model;

@property (nonatomic,strong) THKViewModel *viewModel;
@end

@implementation THKTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self thk_setupViews];
        [self bindViewModel];
    }
    return self;
}


- (void)bindWithModel:(id)model {
    self.model = model;
}

- (void)bindViewModel:(THKViewModel *)viewModel {
    self.viewModel = viewModel;
}

#pragma mark - THKTableViewCellProtocol

- (void)thk_setupViews {}

- (void)bindViewModel {}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
    [super setAccessoryType:accessoryType];
    if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
//        kSetArrowForCell(self);
    }else{
        self.accessoryView = nil;
    }
}

@end
