//
//  UserService.swift
//  SeCall
//
//  Created by Bi Brain on 7/1/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import Foundation

public class UserService{
    func login(request:ProfileEntity, callback: (result:Bool,error:String) ->()){
        ConnectionManager.request(3, request: request,newPassword:"",verifyCode:"", callback: { (code) -> () in
            if code == "1" {
                //start pjsip
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    callback(result: true,error: "")
                }
            }
            if code == "8" {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    callback(result: false,error: "Incorrect phone number or password.")
                }
            }
        }) // end request
        
    }
    
    func registerToServer(phoneNumber:String,sipDomain:String,password:String){
        swfStartPjsip(phoneNumber, sipDomain, password)
    }
    
    func registerNewUser(request:ProfileEntity,callback: (result:Bool,error:String) ->()){
        
        ConnectionManager.request(1, request: request,newPassword:"",verifyCode:"", callback: { (code) -> () in
            if code == "1" {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    callback(result: true,error: "")
                }
            }
            if code == "2" {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    callback(result: false,error: "This phone number aldready exist.")
                }
            }
            if code == "0"{
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    callback(result: false,error: "Error from server")
                }
            }
        })
        
    }
    
    func changePassword(request:ProfileEntity,newPassword:String,callback: (result:Bool,message:String) ->()){
        ConnectionManager.request(2, request: request,newPassword:newPassword,verifyCode:"", callback: { (code) -> () in
            if code == "1"{
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    callback(result: true,message: "Password was changed.")
                }
            }
            if code == "3" {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    callback(result: false,message: "Incorrect current password.")
                }
            }
            if code == "0" {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    callback(result: true,message:"Change password failed.")
                }
            }
        })
    }
    
    func logout(){
        swfDestroy()
    }
    
    func recoverPassword(request:ProfileEntity,newPassword:String,verifyCode:String,callback: (result:Bool, message:String) ->()){
        ConnectionManager.request(5, request: request,newPassword:newPassword,verifyCode:verifyCode, callback: { (code) -> () in
            if code == "1"{
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    callback(result: true, message:"Reset password success.")
                }
                
            }
            if code == "5"{
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    callback(result: false, message: "New password should not same as old password.")
                }
            }
            if code == "7" {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    callback(result: false, message:"Incorrect verify code.")
                }
            }
        })
    }
    
    func deleteUser(request:ProfileEntity, callback:(result:Bool,error:String) ->()){
        ConnectionManager.request(6, request: request,newPassword:"",verifyCode:"", callback: { (code) -> () in
            if code == "1"{
                callback(result: true,error: "")
            }else{
                if code == "4" {
                    callback(result: false, error: "Incorrect password or phone number does not exist.")
                }else{
                    callback(result: false, error: "Delete error")
                }
            }
        })
    }
    
    func checkAccountExist(request:ProfileEntity,callback: (result:Bool,error:String) ->()){
        ConnectionManager.request(4, request: request,newPassword:"",verifyCode:"", callback: { (code) -> () in
            if code == "1" || code == "6" {
                callback(result: true,error: "")
            }
            if code == "0"{
                callback(result: false,error: "Error.")
            }
        })
    }
}