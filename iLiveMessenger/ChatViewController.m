//
//  ChatViewController.m
//  iLiveMessenger
//
//  Created by Rajesh on 3/16/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "ChatViewController.h"
#import "Message.h"
#import "JSQMessagesBubbleImageFactory.h"
#import "JSQMessagesAvatarImageFactory.h"

@interface ChatViewController () {
    JSQMessagesBubbleImage *bubbleImageOutgoing;
    JSQMessagesBubbleImage *bubbleImageIncoming;
    JSQMessagesAvatarImage *avatarImageBlank;
}

@property (strong, nonatomic) NSMutableArray<Message *>*messages;
@property (strong, nonatomic) Firebase *firebase;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic)  NSString *chatId;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:_toUser];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    _chatId = [Controller chatIdForToUser:_toUser];
    [self setSenderId:[Controller sharedController].user];
    [self setSenderDisplayName:self.senderId];
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor redColor]];
    bubbleImageIncoming = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor greenColor]];
    
    [[Controller sharedController] validateChatAndGetListOfMessages:_chatId completion:^(NSMutableArray<Message *> *array) {
        if (!array) {
            [[Controller sharedController] createChat:_chatId];
        }
        _messages = [NSMutableArray array];
        [self.collectionView reloadData];
        _firebase = [[Controller sharedController] registerForChat:_chatId completion:^(Message *message) {
            [_messages addObject:message];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[_messages indexOfObject:message] inSection:0];
            [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
            [self scrollToBottomAnimated:YES];
        }];
    }];
}

- (void)dealloc {
    [_firebase removeAllObservers];
}

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    Message *message = [Message message:text];
    [[Controller sharedController] sendMessage:message chatId:_chatId];
    [self.inputToolbar.contentView.textView setText:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _messages.count;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = _messages[indexPath.row];
    return message;
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
             messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = _messages[indexPath.row];
    if (message.isFromMe) return bubbleImageOutgoing;
    else return bubbleImageIncoming;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}



@end
