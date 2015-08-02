//
//  ContactTableViewController.swift
//  VoIPProject
//
//  Created by BrainBi on 3/25/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate, UIAlertViewDelegate {
    // Result contacts
    var filteredContact = [ContactEntity]()
    // Contacts
    var contacts = [ContactEntity]()
    
    var contactService:ContactService!
    var callService:CallService!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 46
        contactService = ContactService()
        callService = CallService()

        self.contacts = ModelUtility.GetContacts()
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "callFromContact:",name: "callFromContact",object: nil)

        self.tableView.reloadData()
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if tableView == self.searchDisplayController!.searchResultsTableView{
            return self.filteredContact.count
        } else {
            return self.contacts.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCellWithIdentifier("ContactCell") as! ContactCell
        var contact: ContactEntity
        let searchResult = self.searchDisplayController!.searchResultsTableView
        if tableView == searchResult {
            contact = filteredContact[indexPath.row]
        } else {
            contact = contacts[indexPath.row]
        }
        cell.contactNameLabel.text = contact.name
        cell.profileImageView.image = UIImage(named: contact.avatar)
        cell.phoneNumberLabel.text = contact.phoneNumber
        cell.setBorderForProfileImage()
        return cell
    }
    
    var alertButtonTabbedIndex = -1

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var editAction = UITableViewRowAction(style: .Normal, title: "Edit") { (action, indexPath) -> Void in
            self.showAlertEdit(indexPath.row,name: self.contacts[indexPath.row].name, phoneNumber: self.contacts[indexPath.row].phoneNumber)
        }
        editAction.backgroundColor = UIColor.grayColor()
        
        var deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) -> Void in
            self.contactService.deleteContact(indexPath.row)
            //self.contacts.removeAtIndex(indexPath.row)
            self.contacts = self.contactService.getContacts()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        deleteAction.backgroundColor = UIColor.redColor()
        return [deleteAction,editAction]
    }
    
    // alert
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        alertButtonTabbedIndex = buttonIndex
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredContact = self.contacts.filter({( contact : ContactEntity) -> Bool in
            var categoryMatch = (scope == "All")
            var stringMatch = contact.name.lowercaseString.rangeOfString(searchText.lowercaseString)
            var numberMatch = contact.phoneNumber.lowercaseString.rangeOfString(searchText.lowercaseString)
            return categoryMatch && ((stringMatch != nil) || (numberMatch != nil))
        })
    }

    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController,
        shouldReloadTableForSearchScope searchOption: Int) -> Bool {
            //let scope = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
            self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
            return true
    }

    @IBAction func cancel(segue:UIStoryboardSegue) {
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        var addContact = segue.sourceViewController as! AddContactViewController
        self.contactService.addContact(ContactEntity(avatar: "", name: addContact.name, phoneNumber: addContact.phoneNumber, insertIntoManagedObjectContext: ViewControlerUtility.managedObjectContext))
        contacts = ModelUtility.GetContacts()
        self.tableView.reloadData()
    }

    func showAlertEdit(index:Int,name:String, phoneNumber:String){
        let actionSheetController:UIAlertController = UIAlertController(title: "Edit Contact", message: "", preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
        }
        
        actionSheetController.addAction(cancelAction)
        
        let editAction: UIAlertAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default) { (action) -> Void in
            var newNameTF:UITextField = actionSheetController.textFields?.first as! UITextField
            var newPhoneNumberTF:UITextField = actionSheetController.textFields?.last as! UITextField
            
            var newName = newNameTF.text
            var newPhoneNumber = newPhoneNumberTF.text
            if newName == ""{
                newName = name
            }
            if newPhoneNumber == "" {
                newPhoneNumber = phoneNumber
            }

            self.contactService.editContact(index, newName: newName, newPhone: newPhoneNumber)
            self.contacts = self.contactService.getContacts()
            self.tableView.reloadData()
        }
        
        actionSheetController.addAction(editAction)
        
        actionSheetController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = name
        }
        
        actionSheetController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = phoneNumber
            textField.keyboardType = UIKeyboardType.PhonePad
        }
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        self.contacts = self.contactService.getContacts()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    @objc func callFromContact(notification:NSNotification){

        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        let callTo = userInfo["callTo"]
        let callName = userInfo["callName"]

        if callService.checkValidPhoneNumber(callTo!){

            Ringtone.sharedInstance.startRingingInc()
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : UINavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("CallingNavigation") as! UINavigationController
            
            let topVC: CallingViewController =  vc.topViewController as! CallingViewController
            topVC.callTo = callTo!
            topVC.callName = callName!
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.callService.call(callTo!)
                
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }else{
            ViewControlerUtility.alertError("Call failed",message:"Can not call yourself.")
        }
    }
    
}
