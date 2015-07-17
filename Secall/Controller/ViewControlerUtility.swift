//
//  ViewControlerUtility.swift
//  SeCall
//
//  Created by Bi Brain on 7/1/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import Foundation

public class ViewControlerUtility {
    
    static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    class func alertResult(title:String,message:String){
        var alertView = UIAlertView();
        alertView.addButtonWithTitle("Ok");
        alertView.title = title;
        alertView.message = message;
        alertView.show();
    }
    
    class func alertError(title:String,message:String){
        var alertView = UIAlertView();
        alertView.addButtonWithTitle("Dismiss");
        alertView.title = title;
        alertView.message = message;
        alertView.show();
    }

}