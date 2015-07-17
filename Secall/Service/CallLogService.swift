//
//  CallLogService.swift
//  SeCall
//
//  Created by Bi Brain on 7/2/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import Foundation

public class CallLogService{
    
    func saveCallLog(log:CallLogEntity){
        ModelUtility.AddCallLog(log)
    }
    
    func deleteAllCallLog(){
        ModelUtility.DeleteAllCallLog()
    }
}