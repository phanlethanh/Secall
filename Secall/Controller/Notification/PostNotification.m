//
//  PostNotification.m
//  SeCall
//
//  Created by Bi Brain on 7/2/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostNotification.h"

@implementation PostNotification

// Display incoming call screen
- (void) postIncomingCall:(NSString *)uri{
     NSDictionary *_dictionary = [NSDictionary dictionaryWithObject:uri forKey:@"CallUri"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationIdentifier" object:nil userInfo:_dictionary];
}

-(void) postAcceptCall{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AcceptCall" object:nil];
}

-(void) postDeclineOrFinishCall{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeclineorFinishCall" object:nil];
}

@end