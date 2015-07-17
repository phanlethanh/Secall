//
//  CallRecentViewController.swift
//  VoIPProject
//
//  Created by BrainBi on 3/14/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit

class CallViewController: UIViewController {

    //    MARK: IBOutlet
    @IBOutlet weak var callSegmentedControl: UISegmentedControl!
    @IBOutlet weak var callRecent: UIView!
    @IBOutlet weak var keypad: UIView!
    
    //    MARK: Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        keypad.hidden = false
        callRecent.hidden = true
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
    
    // Change dialer screen and call log screen together
    @IBAction func indexChange(sender: UISegmentedControl) {
        switch callSegmentedControl.selectedSegmentIndex {
        case 1: keypad.hidden = true
                callRecent.hidden = false
                break;
        case 0: keypad.hidden = false
                callRecent.hidden = true
        default:
            break;
        }
    }
    
}
