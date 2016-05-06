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
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor darkGrayColor]];
    bubbleImageIncoming = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor purpleColor]];
    
    /*
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
    */
    _messages = [NSMutableArray array];
    _firebase = [[Controller sharedController] registerForChat:_chatId completion:^(Message *message) {
        [_messages addObject:message];
        [self finishReceivingMessage];
    }];
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setShowTypingIndicator:YES];
    });
     */
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
    [[Controller sharedController] sendMessage:text chatId:_chatId];
    [self finishSendingMessage];
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
    Message *message = _messages[indexPath.row];
    return [self avatarColorWithName:message.senderId incoming:!message.isFromMe];
}

- (JSQMessagesAvatarImage *)avatarColorWithName:(NSString *)name incoming:(BOOL)incoming  {
    NSInteger rgbValue = [name hash];
    CGFloat r = (CGFloat) (((rgbValue & 0xFF0000) >> 16)/255.0);
    CGFloat g = (CGFloat) (((rgbValue & 0xFF00) >> 8)/255.0);
    CGFloat b = (CGFloat) ((rgbValue & 0xFF)/255.0);
    UIColor *color= [UIColor colorWithRed:r green:g blue:b alpha:0.5f];
    NSString *inital = [name length]? [name substringWithRange:NSMakeRange(0, 1)] : @"";
    inital = [inital uppercaseString];
    JSQMessagesAvatarImage *userImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:inital backgroundColor: color textColor:[UIColor blackColor] font: [UIFont systemFontOfSize:13] diameter: (NSUInteger) (incoming ? self.collectionView.collectionViewLayout.incomingAvatarViewSize.width : self.collectionView.collectionViewLayout.outgoingAvatarViewSize.width)];
        return userImage;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[(NSUInteger) indexPath.item];
    
    // Sent by me, skip
    if([message.senderId isEqualToString:self.senderId]){
        return nil;
    }
    
    // Same as previous sender, skip
    if (indexPath.item > 0) {
        Message *previousMessage = self.messages[indexPath.item - 1];
        if([previousMessage.senderId isEqualToString:message.senderId]) {
            return nil;
        }
    }
    return [[NSAttributedString alloc] initWithString:message.senderId];
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[(NSUInteger) indexPath.item];
    
    // Sent by me, skip
    if([message.senderId isEqualToString:self.senderId]){
        return 0;
    }
    
    // Same as previous sender, skip
    if (indexPath.item > 0) {
        Message *previousMessage = self.messages[indexPath.item - 1];
        if([previousMessage.senderId isEqualToString:message.senderId]) {
            return 0;
        }
    }
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[(NSUInteger) indexPath.item];
    if (indexPath.item + 1< self.messages.count) {
        Message *previousMessage = self.messages[indexPath.item + 1];
        if([previousMessage.senderId isEqualToString:message.senderId]) {
            return nil;
        }
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm"];

    return [[NSAttributedString alloc] initWithString:[dateFormat stringFromDate:message.date]];
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[(NSUInteger) indexPath.item];
    if (indexPath.item + 1 < self.messages.count) {
        Message *previousMessage = self.messages[indexPath.item + 1];
        if([previousMessage.senderId isEqualToString:message.senderId]) {
            return 0;
        }
    }
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

@end
