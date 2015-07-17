//
//  PostNotificationService.h
//  SeCall
//
//  Created by BiBrain on 7/5/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

#ifndef SeCall_PostNotificationService_h
#define SeCall_PostNotificationService_h
#import "PostNotification.h"
@interface PostNotificationService : NSObject
{
    PostNotification *postNotification;
}

- (void) postIncomingCall: (NSString*)uri;
- (void) postAcceptCall;
- (void) postDeclineOrFinishCall;

@end

#endif
