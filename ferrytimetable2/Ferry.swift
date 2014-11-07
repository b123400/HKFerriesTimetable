//
//  Ferry.swift
//  ferriestimetable2
//
//  Created by b123400 on 2/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit
import Crashlytics

enum FerryType : String{
    case Slow = "slow"
    case Fast = "fast"
    case Optional = "optional"
}

enum Direction : String {
    case ToIsland = "ToIsland"
    case FromIsland = "FromIsland"
    case Unknown = "Unknown"
}

class Ferry: NSObject {
    let dict : NSDictionary
    let island : Island
    var date: NSDate = NSDate()
    
    init(dictionary:NSDictionary, island _island : Island, direction _direction: Direction, date _date:NSDate) {
        dict = dictionary
        island = _island
        direction = _direction
        date = _date
        super.init()
    }
    
    class func fromDict(dictionaryRepresentation dict:[String: AnyObject]) -> Ferry {
        let thisDict = dict["dict"]! as NSDictionary
        let thisIsland = Island.fromDict(dictionaryRepresentation:dict["island"]! as Dictionary)
        let thisDirection = Direction(rawValue:dict["direction"]! as String)!
        let thisDate = dict["date"]! as NSDate
        return Ferry(dictionary: thisDict, island: thisIsland, direction: thisDirection, date: thisDate)
    }
    
    var dictionaryRepresentation : NSDictionary {
    get {
        return [
            "date" : date,
            "island": island.dictionaryRepresentation,
            "direction": direction.rawValue,
            "dict":dict
        ]
    }
    }
    
    var time : String {
        get {
            Crashlytics.setObjectValue(island.name, forKey: "island")
            Crashlytics.setObjectValue(direction.rawValue, forKey: "direction")
            Crashlytics.setObjectValue(date, forKey: "date")
            return dict.objectForKey("time") as String
        }
    }
    
    var type : FerryType {
        get {
            let kind = dict.objectForKey("kind") as String
            let type = FerryType(rawValue: kind)
            return type!
        }
    }
    
    var direction : Direction = .Unknown;
    
    func convertTime(time:String, fromDate date:NSDate) -> NSDate {
        
        let thisTime = NSString(string:time)
        let startHour = thisTime.substringToIndex(2).toInt()
        let startMinutes = thisTime.substringFromIndex(2).toInt()
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay, fromDate: date)
        
        let thisComponents = NSDateComponents()
        thisComponents.year = components.year
        thisComponents.month = components.month
        thisComponents.day = components.day
        thisComponents.hour = startHour!
        thisComponents.minute = startMinutes!
        
        return NSCalendar.currentCalendar().dateFromComponents(thisComponents)!
    }
    
    var leavingTime : NSDate {
    get{
        return convertTime(time, fromDate: date)
    }
    }
    
    var arrvingTime : NSDate {
    get{
        let arrvingTime = NSDate(timeInterval: duration!, sinceDate: leavingTime)
        return arrvingTime
    }
    }
    
    var duration : NSTimeInterval? {
    get {
        return island.getDurationMinutesForType(self.type)
    }
    }
    
    var price :String {
    get{
        return island.getPriceForType(type, date: date)
    }
    }
}
