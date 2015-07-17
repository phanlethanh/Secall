//
//  MoreViewController.swift
//  VoIPProject
//
//  Created by BrainBi on 3/24/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
//    MARK: IBOutlet
    var profileArray = [String]()
    var profileEntity: ProfileEntity!
    var profileService:ProfileService!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    // services
    
    var userService:UserService!
    var contactService:ContactService!
    var callLogService:CallLogService!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileService = ProfileService()
        userService = UserService()
        contactService = ContactService()
        callLogService = CallLogService()

        profileEntity = ModelUtility.GetProfile()
        profileArray = [profileEntity.phoneNumber as String!,"Change password","Log out","Delete account"]

        var avatar = profileEntity.avatar.substringWithRange(Range<String.Index>(start: profileEntity.avatar.startIndex, end: advance(profileEntity.avatar.endIndex, -4)))
        self.profileImageView.image = UIImage(named: "default")
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderWidth = 3.0;
        self.profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Test")
        tableView.rowHeight = 50
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0{
            return 4
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:ProfileCell!
        var index = indexPath.row
        switch(indexPath.section){
        case 0:
            if index == 0{
                cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ProfileCell
                cell.textField?.text = profileArray[index]
                cell.actionImageView?.image = UIImage(named: Utility.IMAGE_ARRAY[index])
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell", forIndexPath: indexPath) as! ProfileCell
                cell.labelCell.text = profileArray[index]
                cell.actionImageView?.image = UIImage(named: Utility.IMAGE_ARRAY[index])
            }
            break
            
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("ButtonCell", forIndexPath: indexPath) as! ProfileCell
            cell.labelCell.text = "About"
            cell.actionImageView?.image = UIImage(named: Utility.IMAGE_ARRAY[4])
            break
        default:
            cell.textField?.text = "other"
            cell.actionImageView?.image = UIImage(named: Utility.IMAGE_ARRAY[4])
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let  footerCell = tableView.dequeueReusableCellWithIdentifier("FooterCell") as! CustomFooterCell
        
        switch (section) {
        case 0:
            footerCell.footerLabel.text = "About";
        case 1:
            footerCell.footerLabel.text = ""
            footerCell.backgroundColor = Utility.UIColorFromRGB(0xededed)
        default:
            footerCell.footerLabel.text = "";
        }
        return footerCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = self.tableView.indexPathForSelectedRow()
        if indexPath?.row == 1 { //logout
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : LoginViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
            self.dismissViewControllerAnimated(true, completion: nil)
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : ChangePasswordViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ChangePasswordViewController") as! ChangePasswordViewController
            vc.phoneNumber = profileArray[0]
            self.navigationController!.pushViewController(vc, animated: true)
        }
        
        // Log out
        if indexPath.row == 2 {
            alertLogoutWarning()
        }

        // Delete account
        if indexPath.row == 3{
            alertDeleteWarning()
        }
        // about
        if indexPath.row == 0 && indexPath.section == 1{
            let alert = UIAlertView()
            alert.title = "About"
            alert.message = "Secall 1.0 by Thuat Cao - Thanh Phan."
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    func alertDeleteWarning(){
        let actionSheetController: UIAlertController = UIAlertController(title: "Delete account", message: "Are you sure you want to delete this account?", preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            self.userService.logout()
            var profile = ProfileEntity(phoneNumber: self.profileEntity.phoneNumber, password: self.profileEntity.password, insertIntoManagedObjectContext: ViewControlerUtility.managedObjectContext)
            self.userService.deleteUser(profile, callback: { (result, error) -> () in
                if result {
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.profileService.deleteProfile()
                        self.contactService.deleteAllContact()
                        self.callLogService.deleteAllCallLog()
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                        let vc : UINavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginNavi") as! UINavigationController
                        
                        self.presentViewController(vc, animated: true, completion: nil)
                    }
                }else{
                    ViewControlerUtility.alertResult("Delete account", message: error)
                }
                
            })
            
            
        }
        actionSheetController.addAction(deleteAction)
        
        if let popoverController = actionSheetController.popoverPresentationController {
            actionSheetController.popoverPresentationController!.sourceView = self.tableView
            actionSheetController.popoverPresentationController!.sourceRect = CGRectMake(self.tableView.bounds.size.width / 2.0, self.tableView.bounds.size.height / 5.0, 1.0, 1.0)
        }
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }

    func alertLogoutWarning(){
        let actionSheetController: UIAlertController = UIAlertController(title: "Logout?", message: "Logout now?", preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        let deleteAction: UIAlertAction = UIAlertAction(title: "Logout", style: .Default) { action -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.profileService.deleteProfile()
                self.userService.logout()
                self.contactService.deleteAllContact()
                self.callLogService.deleteAllCallLog()
                let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let vc : UINavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginNavi") as! UINavigationController
                self.presentViewController(vc, animated: true, completion: nil)
            }
            
            
        }
        actionSheetController.addAction(deleteAction)
        if let popoverController = actionSheetController.popoverPresentationController {
            actionSheetController.popoverPresentationController!.sourceView = self.tableView
            actionSheetController.popoverPresentationController!.sourceRect = CGRectMake(self.tableView.bounds.size.width / 2.0, self.tableView.bounds.size.height / 6.0, 1.0, 1.0)
        }
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    
}
