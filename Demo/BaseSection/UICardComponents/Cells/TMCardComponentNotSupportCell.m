//
//  TMCardComponentNotSupportCell.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/8/18.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMCardComponentNotSupportCell.h"

@interface TMCardComponentNotSupportCell()

@property (nonatomic, strong)UILabel *tipMsgLbl;

@end

@implementation TMCardComponentNotSupportCell

TMCardComponentPropertyLazyLoad(UILabel, tipMsgLbl);

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubUIElement];
    }
    return self;
}

- (void)loadSubUIElement {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.contentView.layer.cornerRadius = 4;
    self.contentView.clipsToBounds = YES;
    [self.contentView addSubview:self.tipMsgLbl];
    
    self.tipMsgLbl.numberOfLines = 0;
    self.tipMsgLbl.textAlignment = NSTextAlignmentCenter;
    self.tipMsgLbl.font = UIFontMedium(13);
    self.tipMsgLbl.textColor = [UIColor whiteColor];
    self.tipMsgLbl.text = @"该内容无法查看\n请升级到最新版本";
    
    [self.tipMsgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(8);
        make.trailing.mas_equalTo(-8);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

- (void)updateUIElement:(NSObject<TMCardComponentCellDataProtocol> *)data {}

@end
