//
//  NotificationController.swift
//  HK Ferries WatchKit Extension
//
//  Created by b123400 on 27/11/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import WatchKit
import Foundation
import FerryKit

class NotificationController: WKUserNotificationInterfaceController {
    @IBOutlet weak var islandNameLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    @IBOutlet weak var ferryTypeLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLeftLabel: WKInterfaceTimer!
    
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
        NSLog("%@ init", self)
    }
    
    override func didReceiveRemoteNotification(remoteNotification: [NSObject : AnyObject], withCompletion completionHandler: (WKUserNotificationInterfaceType) -> Void) {
        
        // this app doesn't have remote notification
        // the follow code is to mock a local notification
        // because watchkit simulator doesn't support local notification :(
        
        var dict = remoteNotification
        let localNotification = UILocalNotification()
        dict["date"] = NSDate()
        localNotification.userInfo = dict
        didReceiveLocalNotification(localNotification, withCompletion: completionHandler)
    }
    
    override func didReceiveLocalNotification(notification: UILocalNotification, withCompletion completionHandler: (WKUserNotificationInterfaceType) -> Void) {
        
        let dict = notification.userInfo as [String:AnyObject]
        let ferry = Ferry.fromDict(dictionaryRepresentation: dict)
        
        islandNameLabel.setText(NSLocalizedString(ferry.island.name, comment:""))
        timeLabel.setText(NSDateFormatter.localizedStringFromDate(
            ferry.leavingTime,
            dateStyle: .NoStyle,
            timeStyle: .ShortStyle))
        
        timeLeftLabel.setDate(ferry.leavingTime)
        ferryTypeLabel.setText(NSLocalizedString(ferry.type.rawValue, comment:""))
        
        completionHandler(WKUserNotificationInterfaceType.Custom)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
    }

    /*
    override func didReceiveLocalNotification(localNotification: UILocalNotification, withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        // This method is called when a local notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification inteface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
        completionHandler(.Custom)
    }
    */
    
    /*
    override func didReceiveRemoteNotification(remoteNotification: [NSObject : AnyObject], withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        // This method is called when a remote notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification inteface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
        completionHandler(.Custom)
    }
    */
}
