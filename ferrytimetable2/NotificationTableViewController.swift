//
//  NotificationTableViewController.swift
//  ferriestimetable2
//
//  Created by b123400 on 13/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let count = UIApplication.sharedApplication().scheduledLocalNotifications.count
        let size = CGSizeMake(320.0, CGFloat(count) * 44.0)
        self.preferredContentSize = self.tableView.contentSize
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.preferredContentSize = CGSizeMake(320, self.tableView.contentSize.height )
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.preferredContentSize = CGSizeMake(320, self.tableView.contentSize.height )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return UIApplication.sharedApplication().scheduledLocalNotifications.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        let notification = UIApplication.sharedApplication().scheduledLocalNotifications[ indexPath.row ] as UILocalNotification
        let dict = notification.userInfo as [String:AnyObject]
        let ferry = Ferry.fromDict(dictionaryRepresentation: dict)
        
        if ferry.direction == Direction.ToIsland {
            cell.textLabel.text = NSString(format: NSLocalizedString("To %@",comment:""),ferry.island.name)
        } else {
            cell.textLabel.text = NSString(format: NSLocalizedString("From %@",comment:""),ferry.island.name)
        }
        
        let dateText = NSDateFormatter.localizedStringFromDate(notification.fireDate!, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        
        cell.detailTextLabel!.text = NSString(format: NSLocalizedString("Notify at %@",comment:""),dateText)

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if UIApplication.sharedApplication().scheduledLocalNotifications.count == 0 {
            return NSLocalizedString("No Notification",comment:"")
        }
        return ""
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
//             Delete the row from the data source
            let notification = UIApplication.sharedApplication().scheduledLocalNotifications[indexPath.row] as UILocalNotification
            UIApplication.sharedApplication().cancelLocalNotification(notification)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
//             Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "toFerry" {
            let selectedIndex = tableView.indexPathForSelectedRow()?.row
            if selectedIndex == nil {
                return
            }
            let ferryController = segue.destinationViewController as FerryViewController
            let notification = UIApplication.sharedApplication().scheduledLocalNotifications[ selectedIndex! ] as UILocalNotification
            let dict = notification.userInfo as [String:AnyObject]
            let ferry = Ferry.fromDict(dictionaryRepresentation: dict)
            ferryController.ferry = ferry
        }
    }
    
    @IBAction func closeButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
