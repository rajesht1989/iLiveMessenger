//
//  Controller.h
//  iLiveMessenger
//
//  Created by Rajesh on 3/17/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Firebase.h"
#import "Message.h"

@interface Controller : NSObject

+ (Controller *)sharedController;
+ (NSString *)chatIdForToUser:(NSString *)toUser;

@property(nonatomic, strong)NSString *user;

- (void)addUser:(NSString *)user;
- (Firebase *)getAllUser:(void (^)(NSArray *array))completion;
- (void)validateUser:(NSString *)user completion:(void (^)(BOOL isValid))completion;
- (void)validateChatAndGetListOfMessages:(NSString *)chatId completion:(void (^)(NSMutableArray <Message *>*array))completion;
- (void)createChat:(NSString *)chatId;
- (Firebase *)registerForChat:(NSString *)chatId completion:(void (^)(Message *message))completion;
- (void)sendMessage:(Message *)message chatId:(NSString *)chatId;

@end
