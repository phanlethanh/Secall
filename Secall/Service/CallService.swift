//
//  CallService.swift
//  SeCall
//
//  Created by Bi Brain on 7/1/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import Foundation

public class CallService{
    
    // Check call number
    var profileServive = ProfileService()
    func checkValidPhoneNumber(phoneNumber:String)->Bool{
        var profile = profileServive.getProfile()
        if profile.phoneNumber != phoneNumber{
            return true
        }
        return false
    }
    func call(phoneNumber:String){
        var destUri = Utility.generateDestUri(phoneNumber)
        swfMakeCall(destUri)
    }
    
    func endCall(){
        swfEndCall()
    }
    
    func acceptIncomingCall(){
        swfAcceptComingCall()
    }
    
    func declineCall(){
        swfEndCall()
    }
    
    func turnOnVideoCall(){
        // not supported yet
    }
    
    func turnOffVideoCall(){
        // not supported yet
    }
    
    func muteMicrophone() {
        swfMuteMicrophone()
    }
    
    func unmuteMicrophone() {
        swfUnmuteMicrophone()
    }
}
