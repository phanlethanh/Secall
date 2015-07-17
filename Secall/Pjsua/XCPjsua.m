//
//  XCPJsua.m
//  TestPJsua
//
//  Created by BrainBi on 5/6/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pjsua-lib/pjsua.h>
#import <UIKit/UIKit.h>
#define THIS_FILE "XCPjsua.m"
#import "PostNotificationService.h"
pjsua_acc_id acc_id = -1;
pjsua_call_id global_call_id = -1;
pjsua_call_id outgoing_call_id = -1;
pjsua_conf_port_id conf_audio_id = -1;
bool isCalling = false;

const size_t MAX_SIP_ID_LENGTH = 50;
const size_t MAX_SIP_REG_URI_LENGTH = 50;

static void on_incoming_call(pjsua_acc_id acc_id, pjsua_call_id call_id, pjsip_rx_data *rdata);
static void on_call_state(pjsua_call_id call_id, pjsip_event *e);
static void on_call_media_state(pjsua_call_id call_id);
static void error_exit(const char *title, pj_status_t status);

PostNotificationService* post;

int startPjsip(char *sipUser, char* sipDomain, char* password)
{
    pj_status_t status;
    
    // Create pjsua first
    status = pjsua_create();
    if (status != PJ_SUCCESS) error_exit("Error in pjsua_create()", status);
    
    // Init pjsua
    {
        // Init the config structure
        pjsua_config cfg;
        pjsua_config_default (&cfg);
        
        cfg.cb.on_incoming_call = &on_incoming_call;
        cfg.cb.on_call_media_state = &on_call_media_state;
        cfg.cb.on_call_state = &on_call_state;
        
        // Init the logging config structure
        pjsua_logging_config log_cfg;
        pjsua_logging_config_default(&log_cfg);
        log_cfg.console_level = 4;
        
        // Init the pjsua
        status = pjsua_init(&cfg, &log_cfg, NULL);
        if (status != PJ_SUCCESS) error_exit("Error in pjsua_init()", status);
    }
    
    /*
    // Get certificate file path from app document
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory];
    
    NSString *caListFile = @"ca_list.pem";
    
    NSString *calistFilePath;
    while (calistFilePath = [direnum nextObject])
    {
        if (![calistFilePath.lastPathComponent isEqual:caListFile]) {
            continue;
        }
    }
    
    NSString *certFile = @"cert.pem";
    
    NSString *certFilePath;
    while (certFilePath = [direnum nextObject])
    {
        if (![certFilePath.lastPathComponent isEqual:certFile]) {
            continue;
        }
    }
    
    NSString *keyFile = @"key.pem";
    
    NSString *keyFilePath;
    while (keyFilePath = [direnum nextObject])
    {
        if (![keyFilePath.lastPathComponent isEqual:keyFile]) {
            continue;
        }
    }
    
    // TLS transport config
    {
        pjsua_transport_config cfg;
        pjsua_transport_config_default(&cfg);
        
        cfg.port = 5061;
        cfg.tls_setting.method = PJSIP_TLSV1_METHOD;
        //cfg.tls_setting.ca_list_file = pj_str((char*)[calistFilePath UTF8String]);
        //cfg.tls_setting.cert_file = pj_str((char*)[certFilePath UTF8String]);
        //cfg.tls_setting.privkey_file = pj_str((char*)[keyFilePath UTF8String]);
        
        cfg.tls_setting.ca_list_file = pj_str("Users/phanlethanh/Documents/FINAL_SECALL/Secall/Certificate/ca_list.pem");
        cfg.tls_setting.cert_file = pj_str("Users/phanlethanh/Documents/FINAL_SECALL/Secall/Certificate/cert.pem");
        cfg.tls_setting.privkey_file = pj_str("Users/phanlethanh/Documents/FINAL_SECALL/Secall/Certificate/key.pem");
        
        status = pjsua_transport_create(PJSIP_TRANSPORT_TLS, &cfg, NULL);
        if (status != PJ_SUCCESS) error_exit("Error creating transport", status);
    }
    */
    
    // Add TCP transport.
    {
        // Init transport config structure
        pjsua_transport_config cfg;
        pjsua_transport_config_default(&cfg);
        cfg.port = 5060;
        // Add TCP transport.
        status = pjsua_transport_create(PJSIP_TRANSPORT_TCP, &cfg, NULL);
        if (status != PJ_SUCCESS) error_exit("Error creating transport", status);
    }
    
    // Initialization is done, now start pjsua
    status = pjsua_start();
    if (status != PJ_SUCCESS) error_exit("Error starting pjsua", status);
    
    // Register the account on sip server
    {
        pjsua_acc_config cfg;
        pjsua_acc_config_default(&cfg);
        
        // Enable SRTP for specify account
        cfg.use_srtp = PJMEDIA_SRTP_MANDATORY;
        cfg.srtp_secure_signaling = 0;
        
        char sipId[MAX_SIP_ID_LENGTH];
        sprintf(sipId, "sip:%s@%s", sipUser, sipDomain);
        cfg.id = pj_str(sipId);
        
        char regUri[MAX_SIP_REG_URI_LENGTH];
        sprintf(regUri, "sip:%s;transport=tcp", sipDomain);
        cfg.reg_uri = pj_str(regUri);
        
        cfg.cred_count = 1;
        cfg.cred_info[0].realm = pj_str(sipDomain); // set realm to any challenge by "*"
        cfg.cred_info[0].scheme = pj_str("digest");
        cfg.cred_info[0].username = pj_str(sipUser);
        cfg.cred_info[0].data = pj_str(password);
        cfg.cred_info[0].data_type = PJSIP_CRED_DATA_PLAIN_PASSWD;
        
        status = pjsua_acc_add(&cfg, PJ_TRUE, &acc_id);
        if (status != PJ_SUCCESS) error_exit("Error adding account", status);
    }
    post = [[PostNotificationService alloc]init];
    return 0;
}

/* Callback called by the library upon receiving incoming call */
static void on_incoming_call(pjsua_acc_id acc_id, pjsua_call_id call_id,
                             pjsip_rx_data *rdata)
{
    pjsua_call_info ci;
    PJ_UNUSED_ARG(acc_id);
    PJ_UNUSED_ARG(rdata);
    pjsua_call_get_info(call_id, &ci);
    
    PJ_LOG(3,(THIS_FILE, "Incoming call from %.*s!!",(int)ci.remote_info.slen,ci.remote_info.ptr));

    if (isCalling) {
        // Response 486: Busy here
        //pjsua_call_answer(call_id, 486, NULL, NULL);
        printf("\nAnother incoming call...\n");
    } else {
        global_call_id = call_id;
        [post postIncomingCall:[NSString stringWithUTF8String:ci.remote_info.ptr]];
    }
    
}

/* Callback called by the library when call's state has changed */
static void on_call_state(pjsua_call_id call_id, pjsip_event *e)
{
    pjsua_call_info call_info;
    
    PJ_UNUSED_ARG(e);
    
    pjsua_call_get_info(call_id, &call_info);
    PJ_LOG(3,(THIS_FILE, "Call %d state=%.*s", call_id,(int)call_info.state_text.slen,call_info.state_text.ptr));
    
    conf_audio_id = call_info.conf_slot;
    
    if (call_info.state == PJSIP_INV_STATE_DISCONNECTED)
    {
        // When "Decline" or "Finish" a call => close call screen
        isCalling = false;
        [post postDeclineOrFinishCall];
    }
    else if (call_info.state == PJSIP_INV_STATE_EARLY)
    {
        // When start "Call" to other
    }
    else if (call_info.state == PJSIP_INV_STATE_CONNECTING)
    {
        // After "Accept", CONNECTING is first
    }
    else if (call_info.state == PJSIP_INV_STATE_CONFIRMED)
    {
        // After CONNECTING, CONFIRMED is next => transition to calling screen
        isCalling = true;
        [post postAcceptCall];
    }
}

/* Callback called by the library when call's media state has changed */
static void on_call_media_state(pjsua_call_id call_id)
{
    pjsua_call_info ci;
    pjsua_call_get_info(call_id, &ci);
    if (ci.media_status == PJSUA_CALL_MEDIA_ACTIVE) {
        // When media is active, connect call to sound device.
        pjsua_conf_connect(ci.conf_slot, 0);
        pjsua_conf_connect(0, ci.conf_slot);
    }
}

/* Display error and exit application */
static void error_exit(const char *title, pj_status_t status)
{
    pjsua_perror(THIS_FILE, title, status);
    pjsua_destroy();
    exit(1);
}

void makeCall(char* destUri)
{
    pj_status_t status;
    pj_str_t uri = pj_str(destUri);
    status = pjsua_call_make_call(acc_id, &uri, 0, NULL, NULL, &outgoing_call_id);
    global_call_id = outgoing_call_id;
    if (status != PJ_SUCCESS) error_exit("Error making call", status);
}

void endCall()
{
    pjsua_call_hangup(global_call_id, 0, NULL, NULL);
}

void muteMicrophone()
{
    if (conf_audio_id != 0)
    {
        pjsua_conf_disconnect(0, conf_audio_id);
    }
}

void unmuteMicrophone()
{
    if (conf_audio_id != 0)
    {
        pjsua_conf_connect(0, conf_audio_id);
    }
}

// ----------------------------------------
// Call function wrappers for Swift code
// ----------------------------------------
int swfStartPjsip(NSString *sipUser,NSString *sipDomain, NSString *password) {
    return startPjsip((char*)[sipUser UTF8String],(char*)[sipDomain UTF8String],(char*)[password UTF8String]);
}

void swfMakeCall(NSString *destUri) {
    makeCall((char*)[destUri UTF8String]);
}

void swfAcceptComingCall() {
    pjsua_call_answer(global_call_id, 200, NULL, NULL);
}

void swfDestroy() {
    pjsua_destroy();
}

void swfEndCall() {
    endCall();
}

void swfMuteMicrophone() {
    muteMicrophone();
}

void swfUnmuteMicrophone() {
    unmuteMicrophone();
}