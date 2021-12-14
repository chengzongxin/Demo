//
//  THKSelectMaterialCommunicationCell.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/24.
//

#import "THKSelectMaterialCommunicationCell.h"

static const UIEdgeInsets kContentInsets = {22, 15, 0, 15};
static const CGSize kAvatarSize = {36, 36};
static const CGFloat kAvatarBottomMargin = 10;
static const CGFloat kContentBotomMargin = 10;

@interface THKSelectMaterialCommunicationCell ()

@property (nonatomic, strong) THKSelectMaterialCommunicationCellVM *viewModel;
/// 头像
@property (nonatomic, strong) THKAvatarView *avatarView;
/// 名字
@property (nonatomic, strong) UILabel *nameLabel;
/// 标签
@property (nonatomic, strong) UILabel *tagsLabel;
/// 内容
@property (nonatomic, strong) UILabel *contentLabel;
/// 图片集合
//@property (nonatomic, strong, readonly) THKDecorationDiaryImagesView *imagesView;
/// 互动组件
//@property (nonatomic, strong, readonly) TInteractiveToolBar *interactiveToolBar;
@end

@implementation THKSelectMaterialCommunicationCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self didInitializeWithStyle:style];
    }
    return self;
}

- (void)didInitializeWithStyle:(UITableViewCellStyle)style {
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.tagsLabel];
    [self.contentView addSubview:self.contentLabel];
//    [self.contentView addSubview:self.imagesView];
//    [self.contentView addSubview:self.interactiveToolBar];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kContentInsets.top);
        make.left.mas_equalTo(kContentInsets.left);
        make.size.mas_equalTo(kAvatarSize);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kContentInsets.top);
        make.left.equalTo(self.avatarView.mas_right).offset(10);
        make.right.mas_equalTo(100);
    }];
    
    [self.tagsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(1);
        make.left.equalTo(self.avatarView.mas_right).offset(10);
        make.right.mas_equalTo(100);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarView.mas_bottom).offset(9.5);
        make.left.mas_equalTo(kContentInsets.left);
        make.right.mas_equalTo(-kContentInsets.right);
    }];
    
    
//    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.diaryBookButton.mas_bottom).offset(10);
//        make.left.mas_equalTo(kContentInsets.left);
//        make.right.mas_equalTo(-kContentInsets.right);
////        make.height.mas_equalTo(1).priorityLow();  使用内置高度
//    }];
    
//    [self.interactiveToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.imagesView.mas_bottom).offset(kContentBotomMargin);
//        make.left.mas_equalTo(kContentInsets.left);
//        make.right.mas_equalTo(-kContentInsets.right);
//        make.height.mas_equalTo(56);
//    }];
}


- (void)bindViewModel:(THKSelectMaterialCommunicationCellVM *)viewModel{
    [super bindViewModel:viewModel];
    // 更新数据
    [self.avatarView bindViewModel:self.viewModel.avatarVM];
    self.avatarView.userInteractionEnabled = YES;
    self.nameLabel.attributedText = self.viewModel.name;
    self.tagsLabel.attributedText = self.viewModel.tags;
    self.contentLabel.attributedText = self.viewModel.content;
//    self.imagesView.diaryInfo = self.viewModel.model.diaryInfo;
//    self.interactiveToolBar.interactiveModel = self.viewModel.interactiveModel;
    // 更新约束 & 布局
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize resultSize = CGSizeMake(size.width, 0);
    CGFloat contentLabelWidth = size.width - UIEdgeInsetsGetHorizontalValue(kContentInsets);
    
    CGFloat resultHeight = UIEdgeInsetsGetHorizontalValue(kContentInsets) + kAvatarSize.height + kAvatarBottomMargin;
    
    if (self.contentLabel.text.length > 0) {
        CGSize contentSize = [self.contentLabel sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
        resultHeight += contentSize.height + kContentBotomMargin;
    }
    
    // 图片
    resultHeight += 113;
    
    // interactive tool bar
    resultHeight += 56;
    
    resultSize.height = resultHeight;
//    NSLog(@"%@ 的 cell 的 sizeThatFits: 被调用（说明这个 cell 的高度重新计算了一遍）", self.nameLabel.text);
    return resultSize;
}




#pragma mark - Lazy Getter
- (THKAvatarView *)avatarView{
    if (!_avatarView) {
        _avatarView = [[THKAvatarView alloc] init];
        @weakify(self);
        [_avatarView tmui_addSingerTapWithBlock:^{
            @strongify(self);
            [self.viewModel.clickAvatarSignal sendNext:self.viewModel];
        }];
    }
    return _avatarView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorHex(#1A1C1A);
        _nameLabel.font = UIFont(16);
        @weakify(self);
        [_nameLabel tmui_addSingerTapWithBlock:^{
            @strongify(self);
            [self.viewModel.clickAvatarSignal sendNext:self.viewModel];
        }];
    }
    return _nameLabel;
}

- (UILabel *)tagsLabel{
    if (!_tagsLabel) {
        _tagsLabel = [[UILabel alloc] init];
        _tagsLabel.textColor = UIColorHex(#878B99);
        _tagsLabel.font = UIFont(12);
        _tagsLabel.tmui_enlargeClickArea = CGPointMake(-20, 0);
    }
    return _tagsLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 2;
        _contentLabel.textAlignment = NSTextAlignmentJustified;
        _contentLabel.textColor = UIColorHex(#1A1C1A);
        _contentLabel.font = UIFont(16);
    }
    return _contentLabel;
}

//- (THKDecorationDiaryImagesView *)imagesView{
//    if (!_imagesView) {
//        _imagesView = [[THKDecorationDiaryImagesView alloc] init];
//        @weakify(self);
//        _imagesView.clickImage = ^(NSInteger value) {
//            @strongify(self);
//            [self.viewModel.clickImagesSignal sendNext:RACTuplePack(@(value),self.viewModel)];
//        };
//    }
//    return _imagesView;
//}


@end
