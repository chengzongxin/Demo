//
//  THKMyHomeDesignDemandsVM.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKMyHomeDesignDemandsVM.h"
#import "THKHouseCardConfigRequest.h"
#import "THKHomeQueryCardRequest.h"
#import "THKHomeEditCardRequest.h"

@interface THKMyHomeDesignDemandsVM ()

@property (nonatomic, strong) THKRequestCommand *configCommand;

@property (nonatomic, strong) THKRequestCommand *queryCommand;

@property (nonatomic, strong) THKRequestCommand *editCommand;

@end


@implementation THKMyHomeDesignDemandsVM

- (THKRequestCommand *)configCommand{
    if (!_configCommand) {
        _configCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            return [THKHouseCardConfigRequest new];
        }];
    }
    return _configCommand;
}

- (THKRequestCommand *)queryCommand{
    if (!_queryCommand) {
        _queryCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            return [THKHomeQueryCardRequest new];
        }];
    }
    return _queryCommand;
}

- (THKRequestCommand *)editCommand{
    if (!_editCommand) {
        _editCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            return [THKHomeEditCardRequest new];
        }];
    }
    return _editCommand;
}




@end
