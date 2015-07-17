//
//  ResetPasswordViewController.swift
//  SeCall
//
//  Created by Bi Brain on 6/29/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit

class RecoverPasswordViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var getCodeButton: UIButton!
    @IBOutlet weak var recoverButton: UIButton!
    var isHadCode = false
    var userService:UserService!
    var verifyService:VerifyService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        verifyCodeTextField.hidden = true
        newPasswordTextField.hidden = true
        userService = UserService()
        verifyService = VerifyService()
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
    
    @IBAction func getCodeTabbed(sender: AnyObject) {
        checkAccountExist(phoneNumberTextField.text, errorLabel: errorLabel)
        getCodeButton.enabled = false
        self.errorLabel.text = "Please wait..."
        
    }
    @IBAction func recoverTabbed(sender: AnyObject) {
        recoverPassword(phoneNumberTextField.text, verifyCode: verifyCodeTextField.text, newPassword: newPasswordTextField.text, errorLabel: errorLabel)
        
    }
    
    func checkValidInfo(type:Int, str:String)->(valid:Bool,error:String){
        var valid = true
        var error = ""
        switch(type){
        case 1: if (count(str) < 9 || count(str) > 32){
            valid = false
            error = "Invalid phone number"
        };break;
        case 2: if( count(str) < 6){
            valid = false
            error = "New password must be at least 6 characters."
        };break;
        case 3: if(count(str) != 4){
            valid = false
            error = "Verify code must be 4 numberic."
        }; break
        default: break;
        }
        return (valid,error)
    }
    
    func checkAccountExist(phoneNumber:String,errorLabel:UILabel){
        var check = checkValidInfo(1, str: phoneNumber)
        var flag = true
        if check.valid{
            var profile = ProfileEntity(phoneNumber: phoneNumber, password: "", insertIntoManagedObjectContext: ViewControlerUtility.managedObjectContext)
            userService.checkAccountExist(profile, callback: { (result, error) -> () in
                if result {
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.isHadCode = true
                        self.verifyCodeTextField.hidden = false
                        self.newPasswordTextField.hidden = false
                        self.getCodeButton.enabled = true
                        self.errorLabel.text = ""
                        self.getCodeButton.hidden = true
                        self.recoverButton.hidden = false
                    }
                }
                else {
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        flag = false
                        self.errorLabel.text = ""
                        self.getCodeButton.enabled = true
                        ViewControlerUtility.alertResult("Recover account", message: error)
                    }
                }
            })
            
        }else{
            errorLabel.text = check.error
        }
    }
    
    func recoverPassword(phoneNumber:String,verifyCode:String,newPassword:String,errorLabel:UILabel){
        var checkCode = checkValidInfo(3, str: verifyCode)
        var checkPass = checkValidInfo(2, str: newPassword)
        if checkCode.valid && checkPass.valid{
            if verifyService.checkValidPassword(newPassword){
                var profile = ProfileEntity(phoneNumber: phoneNumber, password: newPassword, insertIntoManagedObjectContext: ViewControlerUtility.managedObjectContext)
                userService.recoverPassword(profile, newPassword: newPassword, verifyCode: verifyCode, callback: { (result, message) -> () in
                    if result {
                        ViewControlerUtility.alertResult("Recover password", message: message)
                        self.navigationController!.popViewControllerAnimated(true)
                    }
                    else{
                        ViewControlerUtility.alertResult("Recover password failed.", message: message)
                    }
                })
            } else {
                errorLabel.text = "Password must be in (Aa - Zz) (0 -9)"
            }
        }else{
            errorLabel.text = checkPass.error
            errorLabel.text = checkCode.error
        }
    }
    
    @IBAction func phoneNumberEdited(sender: AnyObject) {
    }
    
    @IBAction func newpasswordEdited(sender: AnyObject) {
    }
    
}
