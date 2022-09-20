//
//  THKOnlineDesignUploadHouseVM.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/16.
//

#import "THKOnlineDesignUploadHouseVM.h"
#import "THKOnlineDesignHouseStyleTagRequest.h"

@interface THKOnlineDesignUploadHouseVM ()

@property (nonatomic, strong) THKRequestCommand *requestHoustTagCommand;

@property (nonatomic, strong) NSArray <THKOnlineDesignHouseStyleTagModel *>*styleTags;

@end

@implementation THKOnlineDesignUploadHouseVM

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    [self.requestHoustTagCommand.nextSignal subscribeNext:^(THKOnlineDesignHouseStyleTagResponse *  _Nullable x) {
        @strongify(self);
        self.styleTags = x.data;
    }];
    
    [self.requestHoustTagCommand execute:nil];
}

- (THKRequestCommand *)requestHoustTagCommand{
    if (!_requestHoustTagCommand) {
        _requestHoustTagCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            return THKOnlineDesignHouseStyleTagRequest.new;
        }];
    }
    return _requestHoustTagCommand;
}

@end
