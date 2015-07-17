//
//  ChangePasswordViewController.swift
//  SeCall
//
//  Created by Bi Brain on 6/27/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    var phoneNumber = ""
    var userService:UserService!
    var verifyService:VerifyService!
    var profileService:ProfileService!
    var callService:CallService!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userService = UserService()
        verifyService = VerifyService()
        profileService = ProfileService()
        callService = CallService()
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
    
    @IBAction func ChangeTabbed(sender: AnyObject) {
        changePassword(phoneNumber,currentPassword:currentPasswordTextField.text,newPassword:newPasswordTextField.text, confirmPassword:passwordConfirmTextField.text,errorLabel:errorLabel)
    }
    
    @IBAction func currentPasswordEndExit(sender: AnyObject) {
        currentPasswordTextField.resignFirstResponder()
        newPasswordTextField.becomeFirstResponder()
    }
    
    @IBAction func newPasswordEndExit(sender: AnyObject) {
        newPasswordTextField.resignFirstResponder()
        passwordConfirmTextField.becomeFirstResponder()
    }
    
    @IBAction func confirmPasswordEndExit(sender: AnyObject) {
        println(phoneNumber)
        println(currentPasswordTextField.text)
        println(newPasswordTextField.text)
        println(passwordConfirmTextField.text)
        changePassword(phoneNumber, currentPassword: currentPasswordTextField.text, newPassword: newPasswordTextField.text, confirmPassword: passwordConfirmTextField.text, errorLabel: errorLabel)
    }

    func changePassword(phoneNumber:String,currentPassword:String,newPassword:String, confirmPassword:String,errorLabel:UILabel){
        var check = checkValidInfo(currentPassword, newPassword: newPassword, passConfirm: confirmPassword)
        if check.valid {
            if verifyService.checkValidPassword(newPassword){
                var profile = ProfileEntity(phoneNumber: phoneNumber, password: currentPassword, insertIntoManagedObjectContext:ViewControlerUtility.managedObjectContext)
                userService.changePassword(profile,newPassword:newPassword, callback: { (result, message) -> () in
                    if result {
                        self.profileService.changePassword(newPassword)
                        //logout pjsip and register againt with new password
                        self.userService.logout()
                        self.userService.registerToServer(phoneNumber, sipDomain: Config.SERVER_ADDRESS, password: newPassword)
                        ViewControlerUtility.alertResult("Change password", message: message)
                        self.navigationController!.popViewControllerAnimated(true)
                    }else{
                        ViewControlerUtility.alertResult("Change password", message: message)
                    }
                })
            } else {
                errorLabel.text = "Password must be in (Aa - Zz) (0 -9)"
            }
        }else{
            errorLabel.text = check.error
        }
    }

    func checkValidInfo(currentPassword:String, newPassword:String, passConfirm:String)->(valid:Bool, error:String){
        var currentValid:Bool = true
        var currentError:String = ""
        
        if count(currentPassword) < 6{
            currentError = "Current password must be at least 6 characters."
            currentValid = false
        }else{
            if (count(newPassword) < 6){
                currentError = "New password must be at least 6 characters."
                currentValid = false
            }else{
                if currentPassword == newPassword{
                    currentError = "New password same as current password."
                    currentValid = false
                }else{
                    if (count(newPassword) > 32 ){
                        currentError = "New password maximum 32 characters."
                        currentValid = false
                    }else {
                        if passConfirm != newPassword {
                            currentError = "Confirm password does not match."
                            currentValid = false
                        }
                    }
                }
            }
        }
        return (currentValid, currentError)
    }
}
