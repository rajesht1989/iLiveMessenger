//
//  Message.h
//  iLiveMessenger
//
//  Created by Rajesh on 3/18/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessageData.h"

@interface Message : NSObject <JSQMessageData>

+ (instancetype)message:(NSString *)message;
+ (instancetype)messageWithDictionary:(NSDictionary *)dictionary identifier:(NSString *)identifier;

@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, strong) NSString *from;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, assign) NSInteger createdAt;
@property(nonatomic, assign) NSInteger updatedAt;
@property(nonatomic, assign) BOOL seen;
@property(nonatomic, assign) BOOL isFromMe;

@end
