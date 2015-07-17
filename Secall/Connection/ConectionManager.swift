//
//  Conection.swift
//  testconnection
//
//  Created by BrainBi on 3/24/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//
import UIKit
import Foundation

public class ConnectionManager: UIViewController,NSXMLParserDelegate  {
    
    // Check if there are no connection
    class func isConnectedToNetwork()->Bool{
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        return Status
    }
    
    // Display warning connection
    class func showConnectionLost() -> Bool{
        if !isConnectedToNetwork() {
            let alert = UIAlertView()
            alert.title = "Connection Failed"
            alert.message = "Check your connection internet and try again."
            alert.addButtonWithTitle("OK")
            alert.show()
            return true
        }
        return false
    }
    
    // Request to use HTTP services from server, which relate account
    class func request(type:Int, request:ProfileEntity,newPassword:String,verifyCode:String, callback: (String) -> ()){
        let rootUrl="http://" + Config.SERVER_ADDRESS + ":8080/KamailioDbService/kamailio/"
        var requestUrl = ""
        
        switch(type){
        case 1:
            requestUrl = rootUrl + "register_subscriber/\(request.phoneNumber)/\(request.password)/\(Config.SERVER_ADDRESS)"; break;
        case 2:
            requestUrl = rootUrl + "change_password/\(request.phoneNumber)/\(request.password)/\(newPassword)"; break;
        case 3:
            requestUrl = rootUrl + "login_subscriber/\(request.phoneNumber)/\(request.password)"; break;
        case 4:
            requestUrl = rootUrl + "request_recover_password/\(request.phoneNumber)"; break;
        case 5:
            requestUrl = rootUrl + "recover_password/\(request.phoneNumber)/\(request.password)/\(verifyCode)"; break;
        case 6:
            requestUrl = rootUrl + "delete_subscriber/\(request.phoneNumber)/\(request.password)"; break;
        default:
            requestUrl = rootUrl + "login_subscriber/\(request.phoneNumber)/\(request.password)"; break;
        }
        let url: NSURL = NSURL(string: requestUrl)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if error != nil {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            } else {
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            var code: String = jsonResult["result_code"] as! String
            print(code)
            callback(code)
            }
        })
        task.resume()
    }
}