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
    @IBOutlet weak var islandLabel1: WKInterfaceLabel!
    @IBOutlet weak var islandLabel2: WKInterfaceLabel!
    @IBOutlet weak var timeLabel1: WKInterfaceLabel!
    @IBOutlet weak var timeLabel2: WKInterfaceLabel!
    @IBOutlet weak var timeLeftLabel1: WKInterfaceTimer!
    @IBOutlet weak var timeLeftLabel2: WKInterfaceTimer!
    
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
        
        if currentLocation != nil && sharedDefaults.boolForKey(SettingWatchGlanceDetectLocationKey) {
            // location found, only show one direction, two ferries
            
            islandLabel1.setHidden(false)
            timeLabel1.setHidden(false)
            timeLeftLabel1.setHidden(false)
            islandLabel2.setHidden(false)
            timeLabel2.setHidden(false)
            timeLeftLabel2.setHidden(false)
            
            let location = currentLocation!
            let atIsland = currentIsland.inLocation(location)
            let direction : Direction = atIsland ? .FromIsland : .ToIsland
            let firstFerry = currentIsland.getNextFerryForTime(NSDate(), direction: direction)
            
            if let ferry = firstFerry {
                
                islandLabel1.setTextColor(colorForFerry(ferry))
                
                islandLabel1.setText(
                    NSString(format:
                        NSLocalizedString(atIsland ? "From %@" : "To %@", comment:""),
                        NSLocalizedString(currentIsland.name, comment:"")))
                timeLabel1.setText(
                    NSDateFormatter.localizedStringFromDate(
                        ferry.leavingTime,
                        dateStyle: .NoStyle,
                        timeStyle: .ShortStyle))
                timeLeftLabel1.setDate(ferry.leavingTime)
                
                islandLabel2.setHidden(true)
                let nextFerry = currentIsland.getNextFerryForTime(
                    ferry.leavingTime.dateByAddingTimeInterval(1),
                    direction: direction)
                
                if let secondFerry = nextFerry {
                    
                    islandLabel2.setTextColor(colorForFerry(secondFerry))
                    
                    timeLabel2.setText(
                        NSDateFormatter.localizedStringFromDate(
                            secondFerry.leavingTime,
                            dateStyle: .NoStyle,
                            timeStyle: .ShortStyle))
                    timeLeftLabel2.setDate(secondFerry.leavingTime)
                } else {
                    timeLabel2.setHidden(true)
                    timeLeftLabel2.setHidden(true)
                }
            } else {
                islandLabel1.setTextColor(UIColor.whiteColor())
                islandLabel1.setText(NSLocalizedString("No ferry for today", comment:""))
                timeLabel1.setHidden(true)
                timeLeftLabel1.setHidden(true)
                islandLabel2.setHidden(true)
                timeLabel2.setHidden(true)
                timeLeftLabel2.setHidden(true)
            }
            
        } else {
            // location not found, show both
            let toFerry = currentIsland.getNextFerryForTime(NSDate(), direction: .ToIsland)
            if let ferry = toFerry {
                islandLabel1.setHidden(false)
                timeLabel1.setHidden(false)
                timeLeftLabel1.setHidden(false)
                
                islandLabel1.setTextColor(colorForFerry(ferry))
                
                islandLabel1.setText(
                    NSString(format:
                        NSLocalizedString("To %@", comment:""),
                        NSLocalizedString(currentIsland.name, comment:"")))
                
                timeLabel1.setText(
                    NSDateFormatter.localizedStringFromDate(
                        ferry.leavingTime,
                        dateStyle: .NoStyle,
                        timeStyle: .ShortStyle))
                timeLeftLabel1.setDate(ferry.leavingTime)
                
            } else {
                islandLabel1.setHidden(true)
                timeLabel1.setHidden(true)
                timeLeftLabel1.setHidden(true)
            }
            
            let fromFerry = currentIsland.getNextFerryForTime(NSDate(), direction: .FromIsland)
            if let ferry = fromFerry {
                islandLabel2.setHidden(false)
                timeLabel2.setHidden(false)
                timeLeftLabel2.setHidden(false)
                
                islandLabel2.setTextColor(colorForFerry(ferry))
                
                islandLabel2.setText(
                    NSString(format:
                        NSLocalizedString("From %@", comment:""),
                        NSLocalizedString(currentIsland.name, comment:"")))
                
                timeLabel2.setText(
                    NSDateFormatter.localizedStringFromDate(
                        ferry.leavingTime,
                        dateStyle: .NoStyle,
                        timeStyle: .ShortStyle))
                timeLeftLabel2.setDate(ferry.leavingTime)
                
            } else {
                islandLabel2.setHidden(true)
                timeLabel2.setHidden(true)
                timeLeftLabel2.setHidden(true)
            }
            
            if fromFerry == nil && toFerry == nil {
                islandLabel1.setHidden(false)
                islandLabel1.setTextColor(UIColor.whiteColor())
                islandLabel1.setText(NSLocalizedString("No ferry for today", comment:""))
            }
        }
    }
    
    func colorForFerry (ferry:Ferry) -> UIColor {
        switch ferry.type {
        case .Fast:
            return UIColor(red: 1, green: 0.255, blue: 0.533, alpha: 1)
        case .Slow:
            return UIColor(red: 0.255, green: 0.714, blue: 0.376, alpha: 1)
        default:
            return UIColor.whiteColor()
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
