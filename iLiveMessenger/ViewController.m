//
//  ViewController.m
//  iLiveMessenger
//
//  Created by Rajesh on 3/16/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "ViewController.h"
#import "Controller.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldRespondForKeybordNotification {
    return NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.shouldRespondForKeybordNotification) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    if (self.shouldRespondForKeybordNotification) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [super viewDidDisappear:animated];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    [self adjustTextViewByKeyboardState:YES keyboardInfo:[notification userInfo]];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self adjustTextViewByKeyboardState:NO keyboardInfo:[notification userInfo]];
}


- (void)adjustTextViewByKeyboardState:(BOOL)showKeyboard keyboardInfo:(NSDictionary *)info {
    UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
    if (animationCurve == UIViewAnimationCurveEaseIn) {
        animationOptions |= UIViewAnimationOptionCurveEaseIn;
    }
    else if (animationCurve == UIViewAnimationCurveEaseInOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseInOut;
    }
    else if (animationCurve == UIViewAnimationCurveEaseOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseOut;
    }
    else if (animationCurve == UIViewAnimationCurveLinear) {
        animationOptions |= UIViewAnimationOptionCurveLinear;
    }
    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:animationOptions animations:^{
        [self.view layoutIfNeeded];
    }                completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (Controller *)controller {
    return [Controller sharedController];
}

- (void)showMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showLoader {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
}

- (void)hideLoader {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
