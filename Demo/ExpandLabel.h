//
//  ExpandLabel.h
//  Demo
//
//  Created by Joe.cheng on 2021/8/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN




@interface ExpandLabel : UILabel

@property (nonatomic, assign) CGFloat maxWidth;///< 富文本最大宽度
@property (nonatomic, strong) UIFont *preferFont;///< 富文本计算字体，因为富文本可能存在多个字体
//@property (nonatomic, assign) NSInteger maxline;


//@property (nonatomic, assign) BOOL isContentAllShow;

@property (nonatomic, strong) NSString *tagStr;
@property (nonatomic, strong) NSDictionary *tagAttrDict;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) NSDictionary *contentAttrDict;


@property (nonatomic, assign) BOOL isFold;

// attr
@property (nonatomic, assign) NSInteger lineSpacing;



- (void)setTagStr:(NSString *)tagStr contentStr:(NSString *)contentStr;


- (void)setTagStr:(NSString *)tagStr
      tagAttrDict:(NSDictionary *)tagAttrDict
       contentStr:(NSString *)contentStr
  contentAttrDict:(NSDictionary *)contentAttrDict;

@property (nonatomic, copy) void (^unfoldClick)(void);


@end




NS_ASSUME_NONNULL_END
