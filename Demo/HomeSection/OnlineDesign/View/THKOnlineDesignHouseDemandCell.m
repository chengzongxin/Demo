//
//  THKOnlineDesignHouseDemandCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignHouseDemandCell.h"
#import "THKOnlineDesignHouseDemandView.h"
@interface THKOnlineDesignHouseDemandCell ()

@property (nonatomic, strong) THKOnlineDesignHouseDemandView *demandView;

@property (nonatomic, strong) UIButton *recordBtn;

@end

@implementation THKOnlineDesignHouseDemandCell

- (void)setupSubviews{
    [self.contentView addSubview:self.demandView];
    
    [self.contentView addSubview:self.recordBtn];
    
    [self.demandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(44);
    }];
}

- (void)bindWithModel:(NSArray *)model{
    self.demandView.demands = model;
}

- (void)clickRecordBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(clickRecordBtn:)]) {
        [self.delegate clickRecordBtn:btn];
    }
}

- (THKOnlineDesignHouseDemandView *)demandView{
    if (!_demandView) {
        _demandView = [[THKOnlineDesignHouseDemandView alloc] init];
    }
    return _demandView;
}

- (UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [UIButton tmui_button];
        _recordBtn.tmui_text = @"按住说话";
        [_recordBtn tmui_addTarget:self action:@selector(clickRecordBtn:)];
    }
    return _recordBtn;
}


@end
