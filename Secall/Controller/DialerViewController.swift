//
//  DialerViewController.swift
//  VoIPProject
//
//  Created by BrainBi on 4/9/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit

class DialerViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlet
    @IBOutlet weak var buttond1: UIButton!
    @IBOutlet weak var buttond2: UIButton!
    @IBOutlet weak var buttond3: UIButton!
    @IBOutlet weak var buttond4: UIButton!
    @IBOutlet weak var buttond5: UIButton!
    @IBOutlet weak var buttond6: UIButton!
    @IBOutlet weak var buttond7: UIButton!
    @IBOutlet weak var buttond8: UIButton!
    @IBOutlet weak var buttond9: UIButton!
    @IBOutlet weak var buttonstar: UIButton!
    @IBOutlet weak var buttond0: UIButton!
    @IBOutlet weak var buttonhash: UIButton!
    @IBOutlet weak var buttoncall: UIButton!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var callService:CallService!
    var normalImage = ["d_1","d_2","d_3","d_4","d_5","d_6","d_7","d_8","d_9","d_star","d_0","d_hash"]
    var selectedImage = ["d_1_s","d_2_s","d_3_s","d_4_s","d_5_s","d_6_s","d_7_s","d_8_s","d_9_s","d_star_s","d_0_s","d_hash_s"]
    //    MARK: Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callService = CallService()
        //
        buttonClear.hidden = true;
        buttoncall.setImage(UIImage(named: "call"), forState: .Normal)
        
        buttoncall.setImage(UIImage(named: "call_s"), forState: UIControlState.Highlighted)
        // Do any additional setup after loading the view.
        for var i = 0; i < normalImage.count; i++ {
            var image = UIImage(named: normalImage[i])
            var imageSelected = UIImage(named: selectedImage[i])
            
            switch(i){
            case 0: buttond1.setImage(image, forState: UIControlState.Normal)
            buttond1.setImage(imageSelected, forState: UIControlState.Highlighted)
                break
            case 1: buttond2.setImage(image, forState: UIControlState.Normal)
            buttond2.setImage(imageSelected, forState: UIControlState.Highlighted)
                break
            case 2: buttond3.setImage(image, forState: UIControlState.Normal)
            buttond3.setImage(imageSelected, forState: UIControlState.Highlighted)
                break
            case 3: buttond4.setImage(image, forState: UIControlState.Normal)
            buttond4.setImage(imageSelected, forState: UIControlState.Highlighted)
                break
            case 4: buttond5.setImage(image, forState: UIControlState.Normal)
            buttond5.setImage(imageSelected, forState: UIControlState.Highlighted)
                break
            case 5: buttond6.setImage(image, forState: UIControlState.Normal)
            buttond6.setImage(imageSelected, forState: UIControlState.Highlighted)
                break
            case 6: buttond7.setImage(image, forState: UIControlState.Normal)
            buttond7.setImage(imageSelected, forState: UIControlState.Highlighted)
                break
            case 7: buttond8.setImage(image, forState: UIControlState.Normal)
            buttond8.setImage(imageSelected, forState: UIControlState.Highlighted)
                break
            case 8: buttond9.setImage(image, forState: UIControlState.Normal)
            buttond9.setImage(imageSelected, forState: UIControlState.Highlighted)
                break
            case 10: buttond0.setImage(image, forState: UIControlState.Normal)
            buttond0.setImage(imageSelected, forState: UIControlState.Highlighted)
                break
            default: break
            }
        }
        buttonClear.setImage(UIImage(named: "clear"), forState: .Normal)
        buttonClear.setImage(UIImage(named: "clear_s"), forState: UIControlState.Highlighted)
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
    // các hàm thực thi khi nhấn vào 1 button
    @IBAction func buttond1_Tabbed(sender: AnyObject) {
        self.phoneNumberLabel.text = phoneNumberLabel.text! + "1"
        Ringtone.sharedInstance.startSoundOfNumber(1);
        buttonClear.hidden = false
    }
    
    @IBAction func buttond2_Tabbed(sender: AnyObject) {
        self.phoneNumberLabel.text = phoneNumberLabel.text! + "2"
        Ringtone.sharedInstance.startSoundOfNumber(2);
        buttonClear.hidden = false
        
    }
    
    @IBAction func buttond3_Tabbed(sender: AnyObject) {
        self.phoneNumberLabel.text = phoneNumberLabel.text! + "3"
        Ringtone.sharedInstance.startSoundOfNumber(3);
        buttonClear.hidden = false
        
    }
    
    @IBAction func buttond4_Tabbed(sender: AnyObject) {
        self.phoneNumberLabel.text = phoneNumberLabel.text! + "4"
        Ringtone.sharedInstance.startSoundOfNumber(4);
        buttonClear.hidden = false
    }
    
    @IBAction func buttond5_Tabbed(sender: AnyObject) {
        self.phoneNumberLabel.text = phoneNumberLabel.text! + "5"
        Ringtone.sharedInstance.startSoundOfNumber(5);
        buttonClear.hidden = false
    }
    
    @IBAction func buttond6_Tabbed(sender: AnyObject) {
        self.phoneNumberLabel.text = phoneNumberLabel.text! + "6"
        Ringtone.sharedInstance.startSoundOfNumber(6);
        buttonClear.hidden = false
    }
    
    @IBAction func buttond7_Tabbed(sender: AnyObject) {
        self.phoneNumberLabel.text = phoneNumberLabel.text! + "7"
        Ringtone.sharedInstance.startSoundOfNumber(7);
        buttonClear.hidden = false
    }
    
    @IBAction func buttond8_Tabbed(sender: AnyObject) {
        self.phoneNumberLabel.text = phoneNumberLabel.text! + "8"
        Ringtone.sharedInstance.startSoundOfNumber(8);
        buttonClear.hidden = false
    }
    
    @IBAction func buttond9_Tabbed(sender: AnyObject) {
        self.phoneNumberLabel.text = phoneNumberLabel.text! + "9"
        Ringtone.sharedInstance.startSoundOfNumber(9);
        buttonClear.hidden = false
    }
    
    @IBAction func buttond0_Tabbed(sender: AnyObject) {
        self.phoneNumberLabel.text = phoneNumberLabel.text! + "0"
        Ringtone.sharedInstance.startSoundOfNumber(0);
        buttonClear.hidden = false
    }
    
    @IBAction func buttonAsterix_Tabbed(sender: AnyObject) {
        self.phoneNumberLabel.text = phoneNumberLabel.text! + "*"
        Ringtone.sharedInstance.startSoundOfNumber(11);
        buttonClear.hidden = false
    }
    
    @IBAction func buttonHash_Tabbed(sender: AnyObject) {
        self.phoneNumberLabel.text = phoneNumberLabel.text! + "*"
        Ringtone.sharedInstance.startSoundOfNumber(12);
        buttonClear.hidden = false
    }

    @IBAction func buttoncall_Tabbed(sender: AnyObject) {
        if checkValidPhone(phoneNumberLabel.text!){
            var recipient = phoneNumberLabel.text!;

            if callService.checkValidPhoneNumber(recipient){
                let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let vc : UINavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("CallingNavigation") as! UINavigationController
                
                let topVC: CallingViewController =  vc.topViewController as! CallingViewController
                topVC.callTo = recipient
                Ringtone.sharedInstance.startRingingInc()
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.callService.call(recipient)
                    self.presentViewController(vc, animated: true, completion: nil)
                }
            }else{
                ViewControlerUtility.alertError("Call failed",message:"Can not call yourself.")
            }
        }else{
            let alert = UIAlertView()
            alert.title = "Dialer"
            alert.message = "Invalid phone number!"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    @IBAction func buttonClearTabbed(sender: AnyObject) {
        phoneNumberLabel.text = phoneNumberLabel.text!.substringToIndex(phoneNumberLabel.text!.endIndex.predecessor())
        if count(phoneNumberLabel.text!) == 0 {
            buttonClear.hidden = true
        }
    }
    
    func checkValidPhone(phone:String) ->Bool{
        if (count(phone) > 9) && (count(phone) < 12) {
            return true
        }
        return false
    }
    
}




























