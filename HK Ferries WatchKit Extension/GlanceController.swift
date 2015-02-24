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
    @IBOutlet weak var islandNameLabel: WKInterfaceLabel!
    let locationManager: CLLocationManager
    var currentLocation: CLLocation?
    let wormhole: MMWormhole
    let sharedDefaults : NSUserDefaults
    var currentIsland : Island
    
    override init() {
        locationManager = CLLocationManager()
        
        wormhole = MMWormhole(applicationGroupIdentifier: "group.net.b123400.ferriestimetable", optionalDirectory: "wormhole")
        
        sharedDefaults = NSUserDefaults(suiteName: "group.net.b123400.ferriestimetable")!
        
        currentIsland = Pier.Central.islands()[0]
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        wormhole.listenForMessageWithIdentifier("islandSettingChanged", listener: {
            (message:AnyObject!) -> Void in
            let islandName = self.sharedDefaults.stringForKey(SettingWatchIslandNameKey)
            if let name = islandName {
                self.setIsland(name)
            }
        })
        
        wormhole.listenForMessageWithIdentifier("locationSettingChanged", listener: {
            (message:AnyObject!) -> Void in
            if self.sharedDefaults.boolForKey(SettingWatchGlanceDetectLocationKey) {
                let status = CLLocationManager.authorizationStatus()
                switch status {
                case CLAuthorizationStatus.NotDetermined, CLAuthorizationStatus.AuthorizedWhenInUse:
                    self.locationManager.requestAlwaysAuthorization()
                case CLAuthorizationStatus.AuthorizedAlways:
                    self.locationManager.startUpdatingLocation()
                default:
                    break
                }
            } else {
                self.locationManager.stopUpdatingHeading()
                self.currentLocation = nil
                self.updateDisplay()
            }
        })
        reloadIslandFromUserDefaults()
        startTrackLocationIfPossible()
    }
    
    override func willActivate() {
        super.willActivate()
        updateDisplay()
        startTimer()
    }
    
    override func didDeactivate() {
        locationManager.stopUpdatingLocation()
        stopTimer()
    }
    
    func updateDisplay () {
        
        var textToDisplay = ""
        
        if currentLocation != nil && sharedDefaults.boolForKey(SettingWatchGlanceDetectLocationKey) {
            // location found, only show one thing
            islandNameLabel.setText(NSLocalizedString("Ferry time table", comment:""))
            
            let location = currentLocation!
            let atIsland = currentIsland.inLocation(location)
            if atIsland {
                let leaveFerry = currentIsland.getNextFerryForDate(NSDate(), direction: .FromIsland)
                textToDisplay = textForFerry(leaveFerry, shortVersion: false)
            } else {
                let goFerry = currentIsland.getNextFerryForDate(NSDate(), direction: .ToIsland)
                textToDisplay = textForFerry(goFerry, shortVersion: false)
            }
        } else {
            // location not found, show both
            islandNameLabel.setText(NSLocalizedString(currentIsland.name, comment:""))
            
            textToDisplay += textForFerry(currentIsland.getNextFerryForDate(NSDate(), direction: .ToIsland), shortVersion: true)
            textToDisplay += "\n"
            textToDisplay += textForFerry(currentIsland.getNextFerryForDate(NSDate(), direction: .FromIsland), shortVersion: true)
        }
        timeLabel.setText(textToDisplay)
    }
    
    func textForFerry (ferry:Ferry?, shortVersion:Bool) -> String {
        if let thisFerry = ferry {
            let leavingTime = thisFerry.leavingTime
            let timeLeft = thisFerry.leavingTime.timeIntervalSinceNow
            var timeLeftString = NSString(format:NSLocalizedString("%.fmin left", comment:""), timeLeft/60.0)
            if timeLeft <= 60 {
                timeLeftString = NSLocalizedString("now", comment:"")
            }
            let timeText = NSDateFormatter.localizedStringFromDate(leavingTime, dateStyle: .NoStyle, timeStyle: .MediumStyle)
            let src = (thisFerry.direction == .ToIsland ? thisFerry.island.pier.rawValue : thisFerry.island.name)
            let dest = (thisFerry.direction == .FromIsland ? thisFerry.island.pier.rawValue : thisFerry.island.name)
            if !shortVersion {
                return NSString(format: "%@ → %@\n%@\n%@",
                    NSLocalizedString(src, comment:""),
                    NSLocalizedString(dest, comment:""),
                    timeText,
                    timeLeftString)
            } else {
                return NSString(format:NSLocalizedString("To %@\n   %@", comment:""), dest, timeLeftString)
            }
        } else {
            return "No ferry"
        }
    }
    
    // Mark: Island
    
    func setIsland (islandName : String) {
        let islands = Pier.Central.islands() + Pier.NorthPoint.islands()
        for island in islands {
            if island.name == islandName {
                setIsland(island)
                return
            }
        }
    }
    
    func setIsland (island:Island) {
        currentIsland = island
        updateDisplay()
    }
    
    func reloadIslandFromUserDefaults () {
        let islandName = sharedDefaults.stringForKey(SettingWatchIslandNameKey)
        if let preferredIslandName = islandName {
            setIsland(preferredIslandName)
        }
    }
    
    // MARK: Location
    
    func startTrackLocationIfPossible () {
        if sharedDefaults.boolForKey(SettingWatchGlanceDetectLocationKey) {
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case CLAuthorizationStatus.AuthorizedAlways:
                self.locationManager.startUpdatingLocation()
            default:
                break
            }
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
        
        let location: AnyObject? = (locations as NSArray).lastObject
        if let thisLocation = location as? CLLocation {
            currentLocation = thisLocation
            updateDisplay()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        currentLocation = nil
        updateDisplay()
    }
    
    // MARK: Timer
    var timer : NSTimer?
    func startTimer () {
        if timer != nil {
            return
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "timerCalled", userInfo: nil, repeats: true)
    }
    
    func stopTimer () {
        timer?.invalidate()
        timer = nil
    }
    
    func timerCalled () {
        updateDisplay()
    }
}
