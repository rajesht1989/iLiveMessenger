//
//  Controller.m
//  iLiveMessenger
//
//  Created by Rajesh on 3/17/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "Controller.h"
#import "Firebase.h"

@interface Controller ()

@property (nonatomic, strong) Firebase *firebase;

@end

@implementation Controller

+ (Controller *)sharedController {
    static Controller *controller ;
    if (!controller) {
        controller = [[Controller alloc] init];
    }
    return controller;
}

+ (NSString *)chatIdForToUser:(NSString *)toUser {
    NSString *me = [self sharedController].user;
    NSComparisonResult result = [toUser compare:me];
    if (result == NSOrderedAscending) return [NSString stringWithFormat:@"%@_%@",toUser,me];
    else return [NSString stringWithFormat:@"%@_%@",me,toUser];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setFirebase:[[Firebase alloc] initWithUrl:@"https://livemessenger.firebaseio.com/"]];
    }
    return self;
}

- (void)addUser:(NSString *)user {
    [[_firebase childByAppendingPath:@"users"] updateChildValues:@{user:@{@"createdAt":kFirebaseServerValueTimestamp}}];
}

- (void)validateUser:(NSString *)user completion:(void (^)(BOOL isValid))completion {
    Firebase *firebaseChild = [[_firebase childByAppendingPath:@"users"] childByAppendingPath:user];
    FirebaseHandle handle = [firebaseChild observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@",snapshot.value);
        [firebaseChild removeObserverWithHandle:handle];
        if ([snapshot exists]) {
            completion(YES);
        } else {
            completion(NO);
        }
    }];
}

- (Firebase *)getAllUser:(void (^)(NSArray *array))completion {
    Firebase *firebaseChild = [_firebase childByAppendingPath:@"users"];
    FirebaseHandle handle = [firebaseChild observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@, %lu",snapshot.value,(unsigned long)handle);
        NSMutableArray *array = [NSMutableArray array];
        for(NSString *aKey in snapshot.value) {
            [array addObject:aKey];
        }
        completion(array);
    }];
    return firebaseChild;
}

- (void)validateChatAndGetListOfMessages:(NSString *)chatId completion:(void (^)(NSMutableArray <Message *>*array))completion {
    Firebase *firebaseChild = [[_firebase childByAppendingPath:@"chats"] childByAppendingPath:chatId];
    [firebaseChild observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@",snapshot.value);
        [firebaseChild removeAllObservers];
        if ([snapshot exists]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSString *aKey  in snapshot.value) {
                NSDictionary *dictionary = snapshot.value[aKey];
                if ([dictionary isKindOfClass:[NSDictionary class]]) {
                    [array addObject:[Message messageWithDictionary:snapshot.value[aKey] identifier:aKey]];
                }
            }
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
            completion([NSMutableArray arrayWithArray:[array sortedArrayUsingDescriptors:@[sortDescriptor]]]);
        } else {
            completion(nil);
        }
    }];
}

- (void)createChat:(NSString *)chatId {
    [[_firebase childByAppendingPath:@"chats"] updateChildValues:@{chatId:@{@"created_at":kFirebaseServerValueTimestamp}}];
}

- (Firebase *)registerForChat:(NSString *)chatId completion:(void (^)(Message *message))completion {
    Firebase *firebaseChild = [[_firebase childByAppendingPath:@"chats"] childByAppendingPath:chatId];
    [[firebaseChild queryLimitedToFirst:50] observeEventType:FEventTypeChildAdded andPreviousSiblingKeyWithBlock:^(FDataSnapshot *snapshot, NSString *prevKey){
        NSLog(@"%@",snapshot.value);
        if ([snapshot exists]) {
            NSDictionary *dictionary = snapshot.value;
            if ([dictionary isKindOfClass:[NSDictionary class]]) {
                Message *message = [Message messageWithDictionary:snapshot.value identifier:prevKey];
                if (message) {
                    completion(message);
                }
            }
        }
    }];
    return firebaseChild;
}

- (void)sendMessage:(NSString *)message chatId:(NSString *)chatId{
    [[[[_firebase childByAppendingPath:@"chats"] childByAppendingPath:chatId] childByAutoId] setValue:@{@"content":message,@"from":[[Controller sharedController] user],@"created_at":kFirebaseServerValueTimestamp}];
}



@end
