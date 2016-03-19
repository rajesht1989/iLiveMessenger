//
//  SignUpViewController.m
//  iLiveMessenger
//
//  Created by Rajesh on 3/16/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)goAction:(id)sender {
    [self showLoader];
    [[self controller] validateUser:_textField.text completion:^(BOOL isAvail) {
        [self hideLoader];
        if (isAvail) {
            [self showMessage:@"User exist. Choose other"];
        } else {
            [[self controller] addUser:_textField.text];
            [[self controller] setUser:_textField.text];
            [self performSegueWithIdentifier:@"toChatList" sender:nil];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
