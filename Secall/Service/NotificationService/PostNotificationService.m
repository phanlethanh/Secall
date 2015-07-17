//
//  PostNotificationService.m
//  SeCall
//
//  Created by BiBrain on 7/5/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostNotificationService.h"

@implementation PostNotificationService
// Display incoming call screen
-(id)init
{
    self = [super init];
    postNotification = [[PostNotification alloc]init];
    return self;
}

- (void) postIncomingCall:(NSString *)uri{
   [postNotification postIncomingCall:uri];
}

-(void) postAcceptCall{
    [postNotification postAcceptCall];
}

-(void) postDeclineOrFinishCall{
    [postNotification postDeclineOrFinishCall];
}

@end