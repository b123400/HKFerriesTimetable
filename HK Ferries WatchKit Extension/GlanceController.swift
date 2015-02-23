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
    let sharedDefaults : NSUserDefaults
    
    override init() {
        locationManager = CLLocationManager()
        
        wormhole = MMWormhole(applicationGroupIdentifier: "group.net.b123400.ferriestimetable", optionalDirectory: "wormhole")
        
        sharedDefaults = NSUserDefaults(suiteName: "net.b123400.ferriestimetable.watchkitextension")!
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        wormhole.listenForMessageWithIdentifier("askPermission", listener: { (message:AnyObject!) -> Void in
            self.locationManager.requestAlwaysAuthorization()
        })
    }
    
    override func willActivate() {
        super.willActivate()
        
        updateDisplay()
//        let status = CLLocationManager.authorizationStatus()
//        switch status {
//        case CLAuthorizationStatus.NotDetermined, CLAuthorizationStatus.AuthorizedWhenInUse:
//            locationManager.requestAlwaysAuthorization()
//        case CLAuthorizationStatus.AuthorizedAlways:
//            locationManager.startUpdatingLocation()
//        default:
//            break
//        }
    }
    
    override func didDeactivate() {
        locationManager.stopUpdatingLocation()
    }
    
    func updateDisplay () {
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
    }
    
    // MARK: Location
    
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
