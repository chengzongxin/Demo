//
//  MLeaksMessenger+HookAlert.m
//  Demo
//
//  Created by Joe.cheng on 2021/6/23.
//

#import "MLeaksMessenger+HookAlert.h"

@implementation MLeaksMessenger (HookAlert)

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
              delegate:(id<UIAlertViewDelegate>)delegate
 additionalButtonTitle:(NSString *)additionalButtonTitle {
//    [alertView dismissWithClickedButtonIndex:0 animated:NO];
//    UIAlertView *alertViewTemp = [[UIAlertView alloc] initWithTitle:title
//                                                            message:message
//                                                           delegate:delegate
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:additionalButtonTitle, nil];
//    [alertViewTemp show];
//    alertView = alertViewTemp;
    
    [[UIViewController.new tmui_topViewController] tmui_showAlertWithTitle:title message:message block:^(NSInteger index) {
//        [UIViewController.new tmui_topViewController] 
    } buttons:@"confirm"];
    
    NSLog(@"%@: %@", title, message);
}
@end
