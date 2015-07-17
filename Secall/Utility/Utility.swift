//
//  Utility.swift
//  PrototypeLogin
//
//  Created by BrainBi on 3/1/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Utility {
    
    static let CALL_TYPE = ["receivedcall","missedcall","called"]
    static let IMAGE_ARRAY = ["more_phonenumber","more_changepassword","more_logout","more_trash","more_about"]
    static let INCOMING_CALL_RING = "apple_ring"
    static let CALLING_RING = "ringing"
    static let START_CALL_RING = "startcall"
    static let END_CALL_RING = "endcall"
    
    class func generateSound(number:Int) -> String{
        return "dtmf\(number)"
    }
    
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // contact
    class func generateDestUri(phoneNumber:String) -> String{
        
        return "sip:" + phoneNumber + "@" + Config.SERVER_ADDRESS
            + ":" + Config.SERVER_PORT + ";transport=" + Config.TRANSPORT_METHOD
    }
    
}

extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext() as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
