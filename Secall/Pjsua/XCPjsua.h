//
//  XCPjsua.h
//  TestPJsua
//
//  Created by BrainBi on 4/26/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

#ifndef TestPJsua_XCPjsua_h
#define TestPJsua_XCPjsua_h
#include <pjsua-lib/pjsua.h>
#include <UIKit/UIKit.h>
/**
 * Initialize and start pjsua.
 *
 * @param sipUser the sip username to be used for register
 * @param sipDomain the domain of the sip register server
 *
 * @return When successful, returns 0.
 */
int startPjsip(char *sipUser, char* sipDomain, char* password);
int swfStartPjsip(NSString *sipUser,NSString *sipDomain, NSString *password);
void swfMakeCall(NSString *destUri);
/**
 * Make VoIP call.
 *
 * @param destUri the uri of the receiver, something like "sip:192.168.43.106:5080"
 */
void makeCall(char* destUri);
void swfAcceptComingCall();
void swfDestroy();
/**
 * End ongoing VoIP calls
 */
void endCall();
void swfEndCall();
/**
 * Mute/Unmute microphone
 */
void swfMuteMicrophone();
void swfUnmuteMicrophone();

@protocol ClassADelegate
-(void)CallOncommingCall: (pjsua_acc_id)id;

@property (nonatomic, assign) id<ClassADelegate> delegate;

@end
#endif
