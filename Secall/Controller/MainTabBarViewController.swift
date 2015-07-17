//
//  MainTabBarViewController.swift
//  VoIPProject
//
//  Created by BrainBi on 3/14/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    var callService:CallService!
    override func viewDidLoad() {
        super.viewDidLoad()
        callService = CallService()
        // Do any additional setup after loading the view.
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Utility.UIColorFromRGB(0xff9600)], forState:.Selected)
        // for icon
        for item in self.tabBar.items as! [UITabBarItem] {
            if let image = item.image {
                item.selectedImage = image.imageWithColor(Utility.UIColorFromRGB(0xff9600)).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            }
        }
        // get notifacation when call coming
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "InComingCall:",name: "NotificationIdentifier",object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "callFromRecent:",name: "callFromRecent",object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

    @objc func InComingCall(notification:NSNotification){
        Ringtone.sharedInstance.startRinging()
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        let callUri = userInfo["CallUri"]
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UINavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("IncomingCallNavigation2") as! UINavigationController
        let topVC: InComingCallViewController =  vc.topViewController as! InComingCallViewController
        topVC.callFrom = callUri!
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    @objc func callFromRecent(notification:NSNotification){
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        let callTo = userInfo["callTo"]
        let callName = userInfo["callName"]
        if callService.checkValidPhoneNumber(callTo!){
            Ringtone.sharedInstance.startRingingInc()
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : UINavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("CallingNavigation") as! UINavigationController
            
            let topVC: CallingViewController =  vc.topViewController as! CallingViewController
            topVC.callTo = callTo!
            topVC.callName = callName!

            NSOperationQueue.mainQueue().addOperationWithBlock {
                //var destUri = Utility.generateDestUri(callTo!)
                self.callService.call(callTo!)
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }else{
            ViewControlerUtility.alertError("Call failed",message:"Can not call yourself.")
        }
    }
    
}
