//
//  VerifyService.swift
//  SeCall
//
//  Created by BiBrain on 7/4/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import Foundation
extension String {
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
}
extension Character {
    var integerValue:Int {
        return String(self).toInt() ?? 0
    }
}

class VerifyService{
    
    func checkValidPassword(password:String) ->Bool{
        for character in password.utf8 {
            let stringSegment: String = "\(character)"
            let iascii: Int = stringSegment.toInt()!
            
            if (iascii < 48) || (iascii > 122) || (iascii > 57 && iascii < 65) ||
                (iascii > 90 && iascii < 97){
                    return false
            }
        }
        return true
    }
    
}
