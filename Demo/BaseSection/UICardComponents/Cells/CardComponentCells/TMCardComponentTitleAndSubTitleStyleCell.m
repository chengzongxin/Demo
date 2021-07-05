//
//  TMCardComponentTitleAndSubTitleStyleCell.m
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "TMCardComponentTitleAndSubTitleStyleCell.h"
#import "TMCardComponentCellSizeTool.h"

@interface TMCardComponentTitleAndSubTitleStyleCell()
@property (nonatomic, strong)UILabel *titleLbl;
@property (nonatomic, strong)UIView *middleLineView;
@property (nonatomic, strong)UILabel *subLbl;
@end

@implementation TMCardComponentTitleAndSubTitleStyleCell
TMCardComponentPropertyLazyLoad(UILabel, titleLbl);
TMCardComponentPropertyLazyLoad(UIView, middleLineView);
TMCardComponentPropertyLazyLoad(UILabel, subLbl);

- (void)loadSubUIElement {
    [super loadSubUIElement];
    
    [self.coverImgView addSubview:self.titleLbl];
    [self.coverImgView addSubview:self.subLbl];
    [self.coverImgView addSubview:self.middleLineView];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(24);
    }];
    [self.middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.titleLbl.mas_bottom).mas_offset(12);
        make.height.mas_equalTo(1);
    }];
    [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.middleLineView.mas_bottom).mas_offset(12);
    }];
            
    //
    self.titleLbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.titleLbl.textColor = [UIColor whiteColor];
    self.titleLbl.numberOfLines = 2;
    
    self.subLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.subLbl.textColor = [UIColor whiteColor];
    self.subLbl.numberOfLines = 2;
    
    self.middleLineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];

#if DEBUG
    MASAttachKeys(self.titleLbl, self.subLbl, self.middleLineView);
#endif
    
}

- (void)updateUIElement:(NSObject<TMCardComponentCellDataProtocol> *)data {
    [super updateUIElement:data];
    
    if (data.cover.title.length > 0) {
        NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
        pStyle.lineSpacing = [TMCardComponentCellSizeTool NormalStyleCellTitleLineGap];
        pStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLbl.attributedText = [[NSAttributedString alloc] initWithString:data.cover.title
                                                                       attributes:@{NSParagraphStyleAttributeName: pStyle}];
        // 使搜索分词高亮
        TSearchContentMakeKeywordsShowHighlightInLabelIfNeed(self.titleLbl, data);
        
    }else {
        self.titleLbl.text = nil;
    }
    
    if (data.cover.subTitle.length > 0) {
        NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
        pStyle.lineSpacing = [TMCardComponentCellSizeTool NormalStyleCellTitleLineGap];
        pStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        self.subLbl.attributedText = [[NSAttributedString alloc] initWithString:data.cover.subTitle
                                                                       attributes:@{NSParagraphStyleAttributeName: pStyle}];
        // 使搜索分词高亮
        TSearchContentMakeKeywordsShowHighlightInLabelIfNeed(self.subLbl, data);
        
    }else {
        self.subLbl.text = nil;
    }
}

@end
