//
//  Island.swift
//  ferriestimetable2
//
//  Created by b123400 on 30/6/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import CoreLocation

private let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)

public class Island: NSObject {
    let sourceDict:NSDictionary;
    var _detailDict:NSDictionary?
    public let pier:Pier
    
    public init(dictionary dict:NSDictionary, pier _pier:Pier){
        sourceDict = dict
        pier = _pier
        super.init()
    }
    
    class func fromDict(dictionaryRepresentation dict:[String: AnyObject]) -> Island{
        let thisDict = dict["dict"]! as NSDictionary
        let pier = Pier(rawValue: dict["pier"]! as String)!
        return Island(dictionary: thisDict, pier: pier)
    }
    
    var dictionaryRepresentation : NSDictionary {
    get {
        return [
            "dict":sourceDict,
            "pier":pier.rawValue
        ]
    }
    }
    
    var detailDict:NSDictionary {
        get {
            if _detailDict == nil {
                _detailDict = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("\(name)Info", ofType: "plist")!)
            }
            return _detailDict!
        }
    }
    
    public var name : String {
        get {
            return sourceDict.objectForKey("name") as String
        }
    }
    
    public var location : CLLocationCoordinate2D {
    get {
        let latString = sourceDict.objectForKey("location-lat") as NSString
        let longString = sourceDict.objectForKey("location-long") as NSString
        return CLLocationCoordinate2DMake(latString.doubleValue, longString.doubleValue)
    }
    }
    
    public func getFerriesForDate(date:NSDate, direction:Direction) -> [Ferry] {
        var directionString:String;
        if direction == Direction.ToIsland {
            directionString = "To"
        } else {
            directionString = "From"
        }
        var dateString = date.isHoliday() ? "Holiday" : "Normal"
        
        if !date.isHoliday() {
            // saturday
            let component = calendar?.components(.WeekdayCalendarUnit, fromDate: date)
            let weekday = component?.weekday
            if weekday != nil {
                if weekday! == 7 {
                    let saturdayPlistKey = "\(directionString)IslandPlistSaturday"
                    if detailDict.objectForKey(saturdayPlistKey) != nil {
                        dateString = "Saturday"
                    }
                }
            }
        }
        
        let timeString = detailDict.objectForKey("\(directionString)IslandPlist\(dateString)")as String
        let arr = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource(timeString, ofType: "plist")!) as Array<NSDictionary>
        
        let ferries = arr.map {
            (var thisTime) -> Ferry in
            return Ferry(dictionary: thisTime as Dictionary, island : self, direction: direction, date: date)
        }
        return ferries
    }
    
    public func getNextFerryForDate(date:NSDate, direction:Direction) -> Ferry? {
        let todayFerries = getFerriesForDate(date, direction: direction)
        for ferry in todayFerries {
            if ferry.leavingTime.timeIntervalSinceNow > 0 {
                return ferry
            }
        }
        return nil
    }
    
    public func getDurationMinutesForType(type:FerryType) -> NSTimeInterval? {
        switch type {
        case .Slow:
            return (detailDict.objectForKey("TimeOfJourney-Slow") as NSNumber).doubleValue * 60
        case .Fast:
            return (detailDict.objectForKey("TimeOfJourney-Fast") as NSNumber).doubleValue * 60
        case .Optional:
            return (detailDict.objectForKey("TimeOfJourney-Optional") as NSNumber).doubleValue * 60
        default:
            return nil;
        }
    }
    
    public func getPriceForType(type:FerryType, date:NSDate) -> String{
        switch (type, date.isHoliday()) {
            
        case (FerryType.Slow, false),(FerryType.Optional, false):
            return detailDict.objectForKey("PriceNormalSlow") as String
            
        case (FerryType.Slow, true),(FerryType.Optional, true):
            return detailDict.objectForKey("PriceHolidaySlow") as String
            
        case (FerryType.Fast, false):
            return detailDict.objectForKey("PriceNormalFast") as String
            
        case (FerryType.Fast, true):
            return detailDict.objectForKey("PriceHolidayFast") as String
            
        default:
            return ""
        }
    }
}
