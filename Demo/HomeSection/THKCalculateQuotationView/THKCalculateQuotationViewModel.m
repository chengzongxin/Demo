//
//  THKCalculateQuotationViewModel.m
//  Demo
//
//  Created by 程宗鑫 on 2022/10/12.
//

#import "THKCalculateQuotationViewModel.h"

@interface THKCalculateQuotationViewModel ()

@property (nonatomic, strong, readwrite) THKRequestCommand *requestConfigCommand;

@property (nonatomic, strong, readwrite) RACSubject *refreshSignal;

@property (nonatomic, strong, readwrite) RACSubject *errorMsgSignal;

@property (nonatomic, strong, readwrite) NSArray <NSArray <THKCalcQuataConfigHouseBaseListItem *>*> *houseTypeArray;

@property (nonatomic, strong, readwrite) NSArray *shiArray;

@property (nonatomic, strong, readwrite) NSArray *tingArray;

@property (nonatomic, strong, readwrite) NSArray *weiArray;

@property (nonatomic, strong, readwrite) NSArray *yangArray;

@property (nonatomic, strong, readwrite) NSArray <THKCalcQuataConfigCityListItem *> *cityModels;

@property (nonatomic, assign) NSInteger defaultArea;

@property (nonatomic ,strong) NSArray <THKCalcQuataConfigHouseTypeListItem *> *houseConfigArray;

@end

@implementation THKCalculateQuotationViewModel


- (void)initialize{
    [super initialize];
    
    @weakify(self);
    [self.requestConfigCommand.nextSignal subscribeNext:^(THKCalcConfigResponse * _Nullable x) {
        @strongify(self);
        NSLog(@"%@",x);
        if (x.status == THKStatusSuccess) {
            self.defaultArea = x.data.defaultArea;
            self.houseConfigArray = x.data.houseTypeList;
            [self createHouseTypeArray:x.data];
            [self createCityModelArray:x.data];
            [self.refreshSignal sendNext:nil];
        }else{
            [self.errorMsgSignal sendNext:x.errorMsg];
        }
    }];
    
    [self.requestConfigCommand.errorSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.errorMsgSignal sendNext:k_toast_msg_weakNet];
    }];
}

- (void)createHouseTypeArray:(THKCalcQuataConfigModel *)data {
//    NSArray *arr = @[@[@"五室",@"四室",@"三室",@"二室"],
//                     @[@"五厅",@"四厅",@"三厅",@"二厅"],
//                     @[@"五卫",@"四卫",@"三卫",@"二卫"],
//                     @[@"五阳台",@"四阳台",@"三阳台",@"二阳台"]];
//    self.houseTypeArray = arr;
    
    NSArray *houseArr = @[data.fangList?:@[],
                          data.tingList?:@[],
                          data.weiList?:@[],
                          data.yangtaiList?:@[],
                          data.chuList?:@[]
    ];
    self.houseTypeArray = houseArr;
    
}
- (void)createCityModelArray:(THKCalcQuataConfigModel *)data {
    self.cityModels = data.cityList;
}

- (THKRequestCommand *)requestConfigCommand{
    if (!_requestConfigCommand) {
        _requestConfigCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            return [THKCalcConfigRequest new];
        }];
    }
    return _requestConfigCommand;
}

TMUI_PropertyLazyLoad(RACSubject, refreshSignal);
TMUI_PropertyLazyLoad(RACSubject, errorMsgSignal);

@end
