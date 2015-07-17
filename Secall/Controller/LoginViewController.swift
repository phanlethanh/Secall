//
//  LoginViewController.swift
//  SeCall
//
//  Created by BrainBi on 5/23/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
//    Mark: IBOutlet
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    var flag = false
    // services
    var userService:UserService!
    var profileService:ProfileService!
    //    MARK: Function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.\
        passwordTextField.text = ""
        userService = UserService()
        profileService = ProfileService()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTabbed(sender: AnyObject) {
        login(phoneNumberTextField.text, password: passwordTextField.text,label: errorLabel)
    }

    func checkValidInfo(phoneNumber:String, password:String)->(valid:Bool, error:String){
        var currentValid:Bool = true
        var currentError:String = ""
        
        if(count(phoneNumber) < 10 || count(phoneNumber) > 11 || phoneNumber.rangeOfString("*") != nil || phoneNumber.rangeOfString("#") != nil || phoneNumber.rangeOfString("+") != nil ){
            currentError = "Invalid phone number, please try again."
            currentValid = false
        }else{
            if (count(password) == 0){
                currentError = "Please input password."
                currentValid = false
            }
        }
        
        return (currentValid, currentError)
    }
    
    // alert error
    @IBAction func passwordEdited(sender: AnyObject) {
        login(phoneNumberTextField.text, password: passwordTextField.text,label: errorLabel)
    }

    
    func login(phoneNumber:String,password:String,label:UILabel){
        if !ConnectionManager.showConnectionLost(){
            var check = checkValidInfo(phoneNumber,password: password)
            if check.valid {
                var profile = ProfileEntity(phoneNumber: phoneNumber, password: password, insertIntoManagedObjectContext:ViewControlerUtility.managedObjectContext)
                var requestLogin: () = userService.login(profile, callback: { (result, error) -> () in
                    if result {
                        self.loginToMainTabbar(phoneNumber, password: password)
                    }else{
                        self.alertResult("Login failed", message: error)
                    }
            })
            } else {
                label.text = check.error
            }
        }
    }
    
    func alertResult(title:String,message:String){
        var alertView = UIAlertView();
        alertView.addButtonWithTitle("OK");
        alertView.title = title;
        alertView.message = message;
        alertView.tintColor = UIColor.redColor()
        alertView.show();
    }
    
    func loginToMainTabbar(phoneNumber:String,password:String){
        userService.registerToServer(phoneNumber,sipDomain: Config.SERVER_ADDRESS, password: password)
        profileService.genarateProfile(ProfileEntity(phoneNumber: phoneNumber, password: password, insertIntoManagedObjectContext: ViewControlerUtility.managedObjectContext))
        //call to main tabbar.
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : MainTabBarViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainTabbar") as! MainTabBarViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}
