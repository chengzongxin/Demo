//
//  THKGraphicDetailVM.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import "THKGraphicDetailVM.h"
#import "THKMeituDetailv2Request.h"
@interface THKGraphicDetailVM ()

@property (nonatomic, strong) THKRequestCommand *requestCommand;

@property (nonatomic, copy) NSArray <THKGraphicDetailContentListItem *> *contentList;

@property (nonatomic , strong) NSArray <THKGraphicDetailImgInfoItem *>              * imgInfo;

@end

@implementation THKGraphicDetailVM

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    [self.requestCommand.nextSignal subscribeNext:^(THKMeituDetailv2Response *  _Nullable x) {
        NSLog(@"%@",x);
        @strongify(self);
        self.contentList = x.data.contentList;
        self.imgInfo = x.data.imgInfo;
    }];
}


- (THKRequestCommand *)requestCommand{
    if (!_requestCommand) {
        _requestCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            THKMeituDetailv2Request *request = [THKMeituDetailv2Request new];
            request.baseId = [input integerValue];
            return request;
        }];
    }
    return _requestCommand;
}

@end
