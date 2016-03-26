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

+ (instancetype)messageWithDictionary:(NSDictionary *)dictionary identifier:(NSString *)identifier {
    return [[self alloc] initWithDictionary:dictionary identifier:identifier];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary identifier:(NSString *)identifier {
    if (self = [super initWithSenderId:dictionary[@"from"] senderDisplayName:dictionary[@"from"] date:[[self class] dateWithFirebaseDate:dictionary[@"created_at"]] text:dictionary[@"content"]]) {
        [self setSeen:[dictionary[@"seen"] boolValue]];
        [self setIdentifier:identifier];
        [self setIsFromMe:[self.senderId isEqualToString:[[Controller sharedController] user]]];
    }
    return self;
}

+ (NSDate *)dateWithFirebaseDate:(NSNumber *)dateNumber {
    return [NSDate dateWithTimeIntervalSince1970:[dateNumber integerValue]/1000];
}

@end
