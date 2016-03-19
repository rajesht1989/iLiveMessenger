//
//  ChatViewController.h
//  iLiveMessenger
//
//  Created by Rajesh on 3/16/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "ViewController.h"
#import "JSQMessagesViewController.h"

@interface ChatViewController : JSQMessagesViewController
@property (nonatomic, strong) NSString *toUser;
@end
