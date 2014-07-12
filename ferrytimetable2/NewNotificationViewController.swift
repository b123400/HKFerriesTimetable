//
//  NewNotificationViewController.swift
//  ferriestimetable2
//
//  Created by b123400 on 12/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

class NewNotificationViewController: UIViewController {
    @IBOutlet var datePicker: UIDatePicker
    var date : NSDate = NSDate()
    var ferry : Ferry?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "closeButtonTapped:")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonTapped(sender:UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addNotificationTapped(sender: AnyObject) {
        let interval = datePicker.countDownDuration
        let notification = UILocalNotification()
        notification.fireDate = date.dateByAddingTimeInterval(interval)
        notification.alertBody = "Time to go!"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
