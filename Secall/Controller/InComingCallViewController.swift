//
//  InComingCallViewController.swift
//  VoIPProject
//
//  Created by BrainBi on 5/11/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit

class InComingCallViewController: UIViewController {
//    MARK: OBOutlet
    @IBOutlet weak var callerImage: UIImageView!
    @IBOutlet weak var callerInfo: UILabel!

    var callFrom:String = ""
    var isConnect = false
    var isDecline = false
    var isSaved = false
    var clTime = ""
    var callService:CallService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callService = CallService()

        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        clTime = formatter.stringFromDate(NSDate.new())
        
        // Do any additional setup after loading the view.
        // Make border for image
        self.callerImage.layer.cornerRadius = self.callerImage.frame.size.width / 2;
        self.callerImage.clipsToBounds = true
        self.callerImage.layer.borderWidth = 3.0;
        self.callerImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.barTintColor = UIColor.grayColor()
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

        var strCallerArr = callFrom.componentsSeparatedByString("\"")
        if strCallerArr.count == 1 {
            // Caller has not a name
            // "<sip:0989824742@210.211.117.30>"
            let strTempArr = strCallerArr[0].componentsSeparatedByString("@")
            let str = strTempArr[0]
            self.callerInfo.text = str.substringWithRange(Range<String.Index>(start: advance(str.startIndex, 5), end: advance(str.endIndex, 0)))
            callFrom = self.callerInfo.text!
            self.callerInfo.text = ModelUtility.CheckContactName(self.callerInfo.text!)
        } else {
            self.callerInfo.text = strCallerArr[1] // Get caller name
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "DeclineOrFinishCall:",name: "DeclineorFinishCall",object: nil)
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

    @IBAction func acceptTabbed(sender: AnyObject) {
        callService.acceptIncomingCall()
        Ringtone.sharedInstance.stopRinging()
        Ringtone.sharedInstance.startSoundStartCall()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let vc : UINavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("CallingNavigation") as! UINavigationController
        
        let topVC: CallingViewController =  vc.topViewController as! CallingViewController
        
        topVC.callFrom = callFrom
        topVC.callName = self.callerInfo.text!
        topVC.type = 1
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    @IBAction func declineTabbed(sender: AnyObject) {
        Ringtone.sharedInstance.stopRinging()
        Ringtone.sharedInstance.startSoundEndCall()
        isDecline = true
        callService.endCall()
        // prevert navigation color
        var navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.barTintColor = Utility.UIColorFromRGB(0xff9600)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        //
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @objc func DeclineOrFinishCall(notification:NSNotification){
        saveCallLog();
        
        var navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.barTintColor = Utility.UIColorFromRGB(0xff9600)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        // add to call recent
        
        // dissmis view
        let secondPresentingVC = self.presentingViewController?.presentingViewController;
        //play rington
        Ringtone.sharedInstance.stopRinging()
        // dissmis view controller
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func saveCallLog(){
        if !isConnect && !isDecline && !isSaved{
            var nameOrPhoneNumber = ""
            if self.callerInfo.text != callFrom {
                nameOrPhoneNumber = self.callerInfo.text!
            } else {
                nameOrPhoneNumber = callFrom
            }
            var clType = "missed"
            var phoneNumber = ""
            if callFrom != "" {
                phoneNumber = callFrom
            }
            var log = CallLogEntity(name: nameOrPhoneNumber,phoneNumber:phoneNumber , avatar: "", duration: "--:--", time: clTime, type: clType, insertIntoManagedObjectContext: ViewControlerUtility.managedObjectContext)
            isSaved = true
            NSNotificationCenter.defaultCenter().postNotificationName("saveCallLog", object: log)
        }
    }
    
}
