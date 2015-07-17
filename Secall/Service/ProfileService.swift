//
//  ProfileService.swift
//  SeCall
//
//  Created by Bi Brain on 7/1/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import Foundation
public class ProfileService{
    
    func genarateProfile(profile:ProfileEntity){
        ModelUtility.GenerateProfile(profile)
    }
    
    func getProfile()->ProfileEntity{
        return ModelUtility.GetProfile()
    }
    
    func deleteProfile(){
        ModelUtility.deleteProfile()
    }
    func changePassword(newPassword:String){
        ModelUtility.ChangeProfilePassword(newPassword);
    }
}
