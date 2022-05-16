//
//  TMUINavigationBar+Tool.m
//  Demo
//
//  Created by Joe.cheng on 2022/5/16.
//

#import "TMUINavigationBar+Tool.h"

@implementation TMUINavigationBarViewModel

@end

@interface TMUINavigationBar (Tool)

@end


@implementation TMUINavigationBar (Tool)

TMUISynthesizeIdStrongProperty(viewModel, setViewModel)


//- (void)bindViewModel:(TMUINavigationBarViewModel *)viewModel{
//    self.viewModel = viewModel;
//    if (self.viewModel.contentType == TMUINavigationBarContentType_Normal) {
//        // 常规导航栏
//        if (self.viewModel.attrTitle) {
//            [self setAttrTitle:self.viewModel.attrTitle];
//        } else if (self.viewModel.title) {
//            [self setTitle:self.viewModel.title];
//        }
//    }else if (self.viewModel.contentType == TMUINavigationBarContentType_Avatar) {
//        // 用户信息
//        THKNavigationAvatarTitleView *avatarTitleView = [[THKNavigationAvatarTitleView alloc] initWithViewModel:self.viewModel];
//        self.titleView = avatarTitleView;
//    }else if (self.viewModel.contentType == TMUINavigationBarContentType_Search) {
//        // 搜索
//        THKNavigationBarSearchViewModel *vm = (THKNavigationBarSearchViewModel *)self.viewModel;
//        TMUISearchBar *searchBar = [[TMUISearchBar alloc] initWithStyle:vm.barStyle];
//        searchBar.showsCancelButton = vm.showsCancelButton;
//        self.titleView = searchBar;
//    }
//
//}


@end
