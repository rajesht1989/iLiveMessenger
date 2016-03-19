//
//  ChatListViewController.m
//  iLiveMessenger
//
//  Created by Rajesh on 3/16/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"

@interface ChatListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) Firebase *firebase;
@property (strong, nonatomic) NSString *toUser;

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showLoader];
    _firebase = [[self controller] getAllUser:^(NSArray *array) {
        [self hideLoader];
        _array = array;
        [_tableView reloadData];
    }];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

- (void)dealloc {
    [_firebase removeAllObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"chatListCell" forIndexPath:indexPath];
    [tableViewCell.textLabel setText:_array[indexPath.row]];
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _toUser = [_array objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toChat" sender:nil];
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     ChatViewController *chatViewController = [segue destinationViewController];
     [chatViewController setToUser:_toUser];
 }

@end
