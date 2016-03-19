//
//  LoginViewController.m
//  iLiveMessenger
//
//  Created by Rajesh on 3/16/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)goAction:(id)sender {
    [self showLoader];
    [[self controller] validateUser:_textField.text completion:^(BOOL isAvail) {
        [self hideLoader];
        if (isAvail) {
            [[self controller] setUser:_textField.text];
            [self performSegueWithIdentifier:@"toChatList" sender:nil];
        } else {
            [self showMessage:@"Invalid Username"];
        }
    }];
}



@end
