//
//  THKGraphicCollectionCell.m
//  Demo
//
//  Created by Joe.cheng on 2023/7/6.
//

#import "THKGraphicCollectionCell.h"

@interface THKGraphicCollectionCell ()

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UILabel *titleLabel;

//@property (strong, nonatomic) TInteractiveToolBar    *interactiveToolBar; //互动组件


@end

@implementation THKGraphicCollectionCell


- (void)setModel:(THKGraphicCollectionModelList *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    [self.coverImageView loadImageWithUrlStr:model.imgUrl];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 60));
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(16);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(12);
        make.centerY.equalTo(self.contentView);
    }];
}



#pragma mark - Getter && Setter
- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.cornerRadius = 4;
        _coverImageView.borderColor = UIColorBackgroundGray;
        _coverImageView.borderWidth = 0.5;
    }
    return _coverImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFont(14);
        _titleLabel.textColor = UIColorDark;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}


@end
