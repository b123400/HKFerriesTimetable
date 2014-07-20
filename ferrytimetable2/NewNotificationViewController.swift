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
    var ferry : Ferry?
    @IBOutlet var dateLabel: UILabel
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationRegistered:", name: ApplicationDidRegisterUserNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Close",comment:""), style: .Plain, target: self, action: "closeButtonTapped:")
        updateDateLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDateLabel() {
        let alarmDate = ferry?.leavingTime.dateByAddingTimeInterval(-datePicker.countDownDuration)
        dateLabel.text = NSDateFormatter.localizedStringFromDate(alarmDate, dateStyle: .NoStyle, timeStyle: .MediumStyle)
    }
    
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        updateDateLabel()
    }
    @IBAction func closeButtonTapped(sender:UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addNotificationTapped(sender: AnyObject) {
        let application = UIApplication.sharedApplication()
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert |
            UIUserNotificationType.Badge, categories: nil
            ))
        UIAlertView(title:  NSLocalizedString("Notification added",comment:""), message:  NSLocalizedString("You can manage notification by tapping the button at the lower right corner",comment:""), delegate: nil, cancelButtonTitle:  NSLocalizedString("OK",comment:"")).show()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func notificationRegistered(notification:NSNotification) {
        let interval = datePicker.countDownDuration
        let notification = UILocalNotification()
        notification.fireDate = ferry?.leavingTime.dateByAddingTimeInterval(-interval)
        notification.alertBody = NSString(format: NSLocalizedString("Time to go to %@",comment:""),NSString(string: ferry?.island.name))
        notification.userInfo = ferry!.dictionaryRepresentation
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}
