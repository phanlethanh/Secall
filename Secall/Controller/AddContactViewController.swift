//
//  AddContactViewController.swift
//  VoIPProject
//
//  Created by BrainBi on 4/15/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
    
    var name:String = ""
    var phoneNumber:String = ""
    
//    mark: UIOutlet
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var contactNameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var contactService:ContactService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        contactService = ContactService()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "addContactDoneSegue" {
            var check = checkValidInfo(phoneNumberTextField.text, contactName: contactNameTextField.text)
            if check.valid{
                if contactService.checkExistContact(phoneNumberTextField.text){
                    errorLabel.text = "This phone number aldready exists."
                    return false
                } else {
                    return true
                }
            } else {
                errorLabel.text = check.error
                return false
            }
        }
        // by default, transition
        return true
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "addContactDoneSegue" {
            name = contactNameTextField.text
            phoneNumber = phoneNumberTextField.text
        }
    }
    
    func checkValidInfo(phoneNumber:String,contactName:String)->(valid:Bool,error:String){
        if count(contactName) == 0 {
            return (false,"Please input contact name.")
        }
        if (count(phoneNumber) < 9 || count(phoneNumber) > 32) {
            return (false,"Invalid phone number")
        }
        return (true,"")
    }
    
}
