//
//  CallingViewController.swift
//  VoIPProject
//
//  Created by BrainBi on 3/31/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit

class CallingViewController: UIViewController {
    
    //    MARK: IBOutlet
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var avatarRecipient: UIImageView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var videoCallerImage: UIImageView!
    @IBOutlet weak var videoCallerRecipientImage: UIImageView!
    @IBOutlet weak var endcallButton: UIButton!
    //    Mark: Variable
    var type:Int = 0
    var callFrom:String = ""
    var callName:String = ""
    var callTo:String = ""
    //    MARK: Function
    var startTime = NSTimeInterval()
    var isConnected:Bool = false
    var timer:NSTimer = NSTimer()
    var clTime:String = ""
    var clDuration = ""
    var clType = "miss"
    var isSaveCallLog:Bool = false
    var callService:CallService!
    var callLogService:CallLogService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callService = CallService()
        callLogService = CallLogService()
        // Set round for avatar
        self.avatarRecipient.layer.cornerRadius = self.avatarRecipient.frame.size.width / 2;
        self.avatarRecipient.clipsToBounds = true
        self.avatarRecipient.layer.borderWidth = 3.0;
        self.avatarRecipient.layer.borderColor = UIColor.whiteColor().CGColor
        videoCallerRecipientImage.hidden = true
        // Set color for call screen navigation
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barTintColor = Utility.UIColorFromRGB(0x44db5e)
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.navigationItem.title = "Wait for recipient"
        // set picture for buttons
        videoButton.setImage(UIImage(named: "videocall_s"), forState: .Normal)
        videoButton.setImage(UIImage(named: "videocall"), forState: UIControlState.Highlighted)
        muteButton.setImage(UIImage(named: "mute_s"), forState: .Normal)
        muteButton.setImage(UIImage(named: "mute"), forState: UIControlState.Highlighted)
        volumeButton.setImage(UIImage(named: "volume_s"), forState: .Normal)
        volumeButton.setImage(UIImage(named: "volume"), forState: UIControlState.Highlighted)
        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "DeclineOrFinishCall:",name: "DeclineorFinishCall",object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "AcceptCall:",name: "AcceptCall",object: nil)
        // Calculate calling time
        let aSelector : Selector = "updateTime"
        if (!timer.valid) {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        }
        startTime = NSDate.timeIntervalSinceReferenceDate()
        isConnected = false
        
        if callFrom != "" {
            phoneNumberLabel.text = callFrom
        }
        if callTo != "" {
            phoneNumberLabel.text = callTo
        }
        if callName != "" {
            phoneNumberLabel.text = callName
        }
        
        if type == 1 {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd hh:mm"
            clTime = formatter.stringFromDate(NSDate.new())
        }
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
    @IBAction func calltabbed(sender: AnyObject) {
        self.navigationItem.title = "Calling"
    }
    // Update calling time
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
        let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        if isConnected || type == 1{
            clDuration = "\(strMinutes):\(strSeconds)"
            self.navigationItem.title = clDuration
        }
        
    }
    
    var vcIsHighLighted = false
    var mtIsHighLighted = false
    var vlIsHighLighted = false
    
    // Enable/disable video call
    @IBAction func videocallTabbed(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if self.vcIsHighLighted == false{
                sender.highlighted = true;
                self.vcIsHighLighted = true
                self.avatarRecipient.hidden = true
                self.videoCallerRecipientImage.hidden = false
            }else{
                sender.highlighted = false;
                self.vcIsHighLighted = false
                self.videoCallerRecipientImage.hidden = true
                self.avatarRecipient.hidden = false
            }
        });
    }
    
    // Enable/disable micro
    @IBAction func muteButtonTabbed(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if self.mtIsHighLighted == false{
                sender.highlighted = true;
                self.mtIsHighLighted = true
                
                // Mute microphone
                self.callService.muteMicrophone()
            }else{
                sender.highlighted = false;
                self.mtIsHighLighted = false
                
                // Unmute microphone
                self.callService.unmuteMicrophone()
            }
        });
    }
    
    var isSpeaker:Bool = false;
    
    // Enable/disable speaker
    @IBAction func volumeButtonTabbed(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if self.vlIsHighLighted == false{
                sender.highlighted = true;
                self.vlIsHighLighted = true
                
                // Enable loud speaker
                Ringtone.sharedInstance.setAudioToLoudSpeaker()
                self.isSpeaker = true
            }else{
                sender.highlighted = false;
                self.vlIsHighLighted = false
                
                // Enable ear speaker
                Ringtone.sharedInstance.setAudioToEarSpeaker()
                self.isSpeaker = false;
            }
        });
    }
    
    // End call
    @IBAction func endCallTabbed(sender: AnyObject) {
        callService.endCall()

        if !isSaveCallLog{
            saveCallLog()
        }
        
        isSaveCallLog = true

        Ringtone.sharedInstance.stopRinging()
        Ringtone.sharedInstance.startSoundEndCall()
        
        if self.isSpeaker == true {
            Ringtone.sharedInstance.setAudioToEarSpeaker()
        }

        timer.invalidate()
        var navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.barTintColor = Utility.UIColorFromRGB(0xff9600)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

        let secondPresentingVC = self.presentingViewController?.presentingViewController;
        
        if type == 1 {
            secondPresentingVC?.dismissViewControllerAnimated(false, completion: nil);
        }
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @objc func AcceptCall(notification:NSNotification){
        clType = "call"
        startTime = NSDate.timeIntervalSinceReferenceDate()
        Ringtone.sharedInstance.stopRinging()
        Ringtone.sharedInstance.startSoundStartCall()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        clTime = formatter.stringFromDate(NSDate.new())
        isConnected = true
    }

    @objc func DeclineOrFinishCall(notification:NSNotification){
        callService.endCall()
        Ringtone.sharedInstance.stopRinging()
        Ringtone.sharedInstance.startSoundEndCall()
        if (timer.valid) {
            timer.invalidate()
        }
        if !isSaveCallLog{
            saveCallLog()
        }
    
        isSaveCallLog = true
        var navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.barTintColor = Utility.UIColorFromRGB(0xff9600)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

        // dissmis view
        let secondPresentingVC = self.presentingViewController?.presentingViewController;
        
        if type == 1 {
            secondPresentingVC?.dismissViewControllerAnimated(false, completion: nil);
        }
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.dismissViewControllerAnimated(true, completion: nil)            
        }
    }

    func saveCallLog(){
        if isConnected {
        var nameOrPhoneNumber = ""
        if callName != "" {
         nameOrPhoneNumber = callName
        } else {
            if callTo != "" {
                nameOrPhoneNumber = callTo
            } else {
                nameOrPhoneNumber = callFrom
            }
        }
        if type == 1 {
            clType = "receive"
        }
        var phoneNumber = ""
            if callTo != "" {
                phoneNumber = callTo
            }else {
                phoneNumber = callFrom
            }
            var log = CallLogEntity(name: nameOrPhoneNumber, phoneNumber:phoneNumber, avatar: "", duration: clDuration, time:clTime, type: clType, insertIntoManagedObjectContext: ViewControlerUtility.managedObjectContext)
            isSaveCallLog = true
        
            NSNotificationCenter.defaultCenter().postNotificationName("saveCallLog", object: log)
        }
    }
}
