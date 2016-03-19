//
//  ViewController.h
//  iLiveMessenger
//
//  Created by Rajesh on 3/16/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Controller.h"
#import "MBProgressHUD.h"

@interface ViewController : UIViewController

@property (nonatomic, readonly) Controller *controller;
- (void)showMessage:(NSString *)message;
- (BOOL)shouldRespondForKeybordNotification;
- (void)adjustTextViewByKeyboardState:(BOOL)showKeyboard keyboardInfo:(NSDictionary *)info;
- (void)showLoader;
- (void)hideLoader;
@end

