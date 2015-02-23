//
//  GlanceController.swift
//  ferriestimetable2
//
//  Created by b123400 on 27/11/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import WatchKit
import FerryKit
import CoreLocation

class GlanceController: WKInterfaceController, CLLocationManagerDelegate {
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    let locationManager: CLLocationManager
    let wormhole: MMWormhole
    
    override init() {
        locationManager = CLLocationManager()
        wormhole = MMWormhole(applicationGroupIdentifier: "group.net.b123400.ferriestimetable", optionalDirectory: "wormhole")
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        
        wormhole.listenForMessageWithIdentifier("hello", listener: { (message:AnyObject!) -> Void in
            NSLog("something here %@",message.description)
        })
        let something = wormhole.messageWithIdentifier("hello")
        if something != nil {
            NSLog(something.description);
        }
    }
    
    override func willActivate() {
        super.willActivate()
        let path = NSBundle.mainBundle().pathForResource("Central", ofType: "plist")
        let islands = NSArray(contentsOfFile: path!)
        let pierDict = islands!.objectAtIndex(0) as NSDictionary
        let island = Island(dictionary: pierDict, pier: .Central)
        let nearestFerry = island.getNextFerryForDate(NSDate(), direction: .ToIsland)
        if nearestFerry == nil {
            timeLabel.setText("No ferry for today :(")
        } else {
            let timeText = NSDateFormatter.localizedStringFromDate(nearestFerry!.leavingTime, dateStyle: .NoStyle, timeStyle: .MediumStyle)
            timeLabel.setText(NSString(format: "Next ferry: %@", timeText))
        }
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case CLAuthorizationStatus.NotDetermined, CLAuthorizationStatus.AuthorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        case CLAuthorizationStatus.AuthorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        switch status {
        case CLAuthorizationStatus.AuthorizedAlways:
            manager.startUpdatingLocation()
        default :
            break
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        manager.stopUpdatingLocation()
        
        let location = (locations as NSArray).lastObject as CLLocation
        NSLog(location.description)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog(error.localizedDescription)
    }
}
