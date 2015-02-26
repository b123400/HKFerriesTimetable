//
//  TimeTableInterfaceController.swift
//  ferriestimetable2
//
//  Created by b123400 on 24/2/15.
//  Copyright (c) 2015 b123400. All rights reserved.
//

import WatchKit
import FerryKit
import CoreLocation

class TimeTableInterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    @IBOutlet weak var timeTable: WKInterfaceTable!
    var island : Island?
    var direction : Direction = .ToIsland
    let locationManager : CLLocationManager
    var currentLocation : CLLocation?
    
    override init!() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let thisContext = context as? [String:AnyObject] {
            island = (thisContext["island"] as Island)
            let directionString: AnyObject? = thisContext["direction"]
            if let string = directionString as? String {
                direction = Direction(rawValue: string)!
            }
            
//            let status = CLLocationManager.authorizationStatus()
//            switch status {
//            case CLAuthorizationStatus.AuthorizedAlways:
//                self.locationManager.startUpdatingLocation()
//            default:
//                break
//            }
        }
    }
    
    override func willActivate() {
        super.willActivate()
        makeTable()
        makeMenu()
    }
    
    func reverseDirection () {
        if direction == .ToIsland {
            direction = .FromIsland
        } else {
            direction = .ToIsland
        }
        makeTable()
        makeMenu()
    }
    
    func getFerries () -> [Ferry] {
        return island!.getFerriesForDate(NSDate(), direction: direction)
    }
    
    func makeTable () {
        let ferries = getFerries()
        let count = ferries.count
        timeTable.setRowTypes(["row"] + [Int](0..<count).map({_ in "time"}))
        
        let rowController = timeTable.rowControllerAtIndex(0) as RowController
        rowController.textLabel.setText(
            NSString(format: direction == .ToIsland ?
                NSLocalizedString("To %@", comment:"") :
                NSLocalizedString("From %@", comment:""),
                NSLocalizedString(island!.name, comment:"")))
        
        for i in (1...count) {
            let islandIndex = i - 1
            let ferry = ferries[islandIndex]
            
            let timeRowController = timeTable.rowControllerAtIndex(i) as TimeRowController
            timeRowController.timeLabel.setText(
                NSDateFormatter.localizedStringFromDate(
                    ferry.leavingTime,
                    dateStyle: .NoStyle,
                    timeStyle: .ShortStyle))
            
            timeRowController.typeLabel.setText(
                ferry.type == .Fast ?
                    NSLocalizedString("Fast", comment:""):
                    NSLocalizedString("Slow", comment:""))
            
            if ferry.type == .Fast {
                timeRowController.typeGroup.setBackgroundColor(
                    UIColor(red: 1, green: 0.255, blue: 0.533, alpha: 1))
            }
        }
    }
    
    func makeMenu () {
        clearAllMenuItems()
        addMenuItemWithItemIcon(WKMenuItemIcon.Repeat, title: direction == .ToIsland ? "From island" : "To island", action: "reverseDirection")
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
            if let currentIsland = island {
                if currentIsland.inLocation(thisLocation) {
                    direction = .FromIsland
                } else {
                    direction = .ToIsland
                }
                makeMenu()
                makeTable()
            }
        }
    }
}
