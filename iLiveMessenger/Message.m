//
//  Message.m
//  iLiveMessenger
//
//  Created by Rajesh on 3/18/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "Message.h"
#import "Controller.h"

@implementation Message

+ (instancetype)message:(NSString *)strMessage {
    Message *message = [[Message alloc] init];
    [message setContent:strMessage];
    [message setFrom:[[Controller sharedController] user]];
    return message;
}

+ (instancetype)messageWithDictionary:(NSDictionary *)dictionary identifier:(NSString *)identifier {
    Message *message = [[Message alloc] init];
    [message setIdentifier:identifier];
    [message setContent:dictionary[@"content"]];
    [message setCreatedAt:[dictionary[@"created_at"] integerValue]];
    [message setFrom:dictionary[@"from"]];
    [message setUpdatedAt:[dictionary[@"updated_at"] integerValue]];
    [message setSeen:[dictionary[@"seen"] boolValue]];
    [message setIsFromMe:[message.from isEqualToString:[[Controller sharedController] user]]];
    return message;
}

- (NSString *)senderId {
    return self.from;
}

- (NSString *)senderDisplayName {
    return self.from;
}

- (NSDate *)date {
    return [NSDate date];
}

- (BOOL)isMediaMessage {
    return NO;
}

- (NSUInteger)messageHash {
    return 0;
}

- (NSString *)text {
    return self.content;
}

- (id<JSQMessageMediaData>)media {
    return nil;
}


@end
