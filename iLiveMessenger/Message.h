//
//  Message.h
//  iLiveMessenger
//
//  Created by Rajesh on 3/18/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessage.h"

@interface Message : JSQMessage

+ (instancetype)messageWithDictionary:(NSDictionary *)dictionary identifier:(NSString *)identifier;

@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, assign) BOOL seen;
@property(nonatomic, assign) BOOL isFromMe;

@end
