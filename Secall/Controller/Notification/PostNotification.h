//
//  PostNotification.h
//  SeCall
//
//  Created by Bi Brain on 7/2/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostNotification : NSObject

- (void) postIncomingCall: (NSString*)uri;
- (void) postAcceptCall;
- (void) postDeclineOrFinishCall;

@end


