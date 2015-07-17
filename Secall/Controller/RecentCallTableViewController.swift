//
//  RecentCallTableViewController.swift
//  VoIPProject
//
//  Created by BrainBi on 3/25/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit

class RecentCallTableViewController: UITableViewController {
    // service
    var callLogs = [CallLogEntity]()
    var callLogService:CallLogService!
    override func viewDidLoad() {
        super.viewDidLoad()
        callLogService = CallLogService()
        tableView.rowHeight = 66
        //modify this code to read data from database, displayImage,typeCall,Datatime
        callLogs = ModelUtility.GetCallLogs()

        NSNotificationCenter.defaultCenter().addObserver(self,selector: "saveCallLog:",name: "saveCallLog",object: nil)
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
        //modify this
        return callLogs.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecentCallCell", forIndexPath: indexPath) as! RecentCallCell
        var index = callLogs.count - 1 - indexPath.row
        //modify to data here
        cell.profileImageView?.image = UIImage(named: "default_contact")
        cell.displaynameLabel.text = callLogs[index].name
        switch(callLogs[index].type){
        case "call":
            cell.typecallImageView.image = UIImage(named: Utility.CALL_TYPE[2]); break;
        case "receive":
            cell.typecallImageView.image = UIImage(named: Utility.CALL_TYPE[0]); break;
        case "missed":
            cell.typecallImageView.image = UIImage(named: Utility.CALL_TYPE[1]); break;
        default:
            cell.typecallImageView.image = UIImage(named: Utility.CALL_TYPE[1]); break;
        }
        cell.durationLabel.text = callLogs[index].duration
        cell.datatimeLabel.text = callLogs[index].time
        cell.phoneNumber = callLogs[index].phoneNumber
        cell.setBorderForProfileImage()
        return cell
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
            var index = callLogs.count - 1 - indexPath.row
            ModelUtility.DeleteCallLog(index)
            self.callLogs.removeAtIndex(index)
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

    @objc func saveCallLog(notification:NSNotification){
        var log = notification.object as! CallLogEntity!
        self.callLogService.saveCallLog(log)
        callLogs = ModelUtility.GetCallLogs()
        self.tableView.reloadData()
    }
}
