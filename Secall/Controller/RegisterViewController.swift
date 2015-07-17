//
//  RegisterViewController.swift
//  SeCall
//
//  Created by Bi Brain on 6/27/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit
import CoreData
class RegisterViewController: UIViewController {
//    MARK: IBOutlet
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var userService:UserService!
    var profileService:ProfileService!
    var verifyService:VerifyService!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userService = UserService()
        profileService = ProfileService()
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
    @IBAction func registerTabbed(sender: AnyObject) {
        register(phoneNumberTextField.text,password:passwordTextField.text,passwordConfirm:passwordConfirmTextField.text,errorLabel:errorLabel)
    }
    func checkValidInfo(phoneNumber:String, password:String, passConfirm:String)->(valid:Bool, error:String){
        var currentValid:Bool = true
        var currentError:String = ""
        
        if(count(phoneNumber) < 10 || count(phoneNumber) > 11 || phoneNumber.rangeOfString("*") != nil || phoneNumber.rangeOfString("#") != nil || phoneNumber.rangeOfString("+") != nil ){
            currentError = "Invalid phone number, please try again."
            currentValid = false
        }else{
            if (count(password) < 6){
                currentError = "Password must be at least 6 characters."
                currentValid = false
            } else{
                if passConfirm != password {
                    currentError = "Password does not match."
                    currentValid = false
                }}}
        return (currentValid, currentError)
    }

    func register(phoneNumber:String,password:String,passwordConfirm:String, errorLabel:UILabel){
        var check = checkValidInfo(phoneNumber, password: password, passConfirm: passwordConfirm)
        if check.valid {
            if verifyService.checkValidPassword(password){
            var profile = ProfileEntity(phoneNumber: phoneNumber, password: password, insertIntoManagedObjectContext:ViewControlerUtility.managedObjectContext)
            var requestRegister: () = userService.registerNewUser(profile,callback: { (result, error) -> () in
                if result {
                    self.userService.registerToServer(phoneNumber, sipDomain: Config.SERVER_ADDRESS, password: password)
                    self.profileService.genarateProfile(ProfileEntity(phoneNumber: phoneNumber, password: password, insertIntoManagedObjectContext: ViewControlerUtility.managedObjectContext))
                    
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let vc : MainTabBarViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainTabbar") as! MainTabBarViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                    
                }else{
                    ViewControlerUtility.alertResult("Register failed", message: error)
                }

            })
            } else {
                errorLabel.text = "Password must be in (Aa - Zz) (0 -9)"
            }
        }else{
            errorLabel.text = check.error
        }
    }
    
    @IBAction func phoneNumberDidExit(sender: AnyObject) {
        phoneNumberTextField.resignFirstResponder()
    }
    
    @IBAction func passwordDidExit(sender: AnyObject) {
        passwordTextField.resignFirstResponder()
        passwordConfirmTextField.becomeFirstResponder()
    }
    
    @IBAction func passwordConfirmDidExit(sender: AnyObject) {
       register(phoneNumberTextField.text,password:passwordTextField.text,passwordConfirm:passwordConfirmTextField.text,errorLabel:errorLabel)
    }
    
}
