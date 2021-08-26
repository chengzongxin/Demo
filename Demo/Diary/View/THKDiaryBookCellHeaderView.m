//
//  THKDiaryBookCellHeaderView.m
//  Demo
//
//  Created by Joe.cheng on 2021/8/26.
//

#import "THKDiaryBookCellHeaderView.h"
#import "THKDiaryIndexView.h"

@interface THKDiaryBookCellHeaderView ()
@property(nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) THKDiaryIndexView *indexView;
@end

@implementation THKDiaryBookCellHeaderView
#pragma mark - Life Cycle

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    // remove system subviews
    self.textLabel.hidden = YES;
    self.detailTextLabel.hidden = YES;
    self.backgroundView = [[UIView alloc] init];// 去掉默认的背景，以便屏蔽系统对背景色的控制
    
    
    self.backgroundColor = UIColor.whiteColor;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = UIColor.blackColor;
    self.titleLabel.font = UIFontSemibold(18);
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(36);
    }];
    
    _indexView = [[THKDiaryIndexView alloc] init];
    [self.contentView addSubview:_indexView];
    _indexView.position = THKDiaryIndexPosition_Top;
    [_indexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
//        make.top.equalTo(self.titleLabel.mas_centerY).inset(-_indexView.normalSize.height/2.0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(13);
        make.bottom.mas_equalTo(0);
    }];
}



- (void)setPosition:(THKDiaryIndexPosition)position{
    _indexView.position = position;
}








// 系统的 UITableViewHeaderFooterView 不允许修改 backgroundColor，都应该放到 backgroundView 里，但却没有在文档中写明，只有不小心误用时才会在 Xcode 控制台里提示，所以这里做个转换，保护误用的情况。
- (void)setBackgroundColor:(UIColor *)backgroundColor {
//    [super setBackgroundColor:backgroundColor];
    self.backgroundView.backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor {
//    return [super backgroundColor];
    return self.backgroundView.backgroundColor;
}




#pragma mark - Public
// initWithModel or bindViewModel: 方法来到这里
// MARK: 初始化,刷新数据和UI,xib,重新设置时调用
- (void)bindViewModel{

}


#pragma mark - Private



#pragma mark - Getter && Setter


@end
