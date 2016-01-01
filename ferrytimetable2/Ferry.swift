//
//  Ferry.swift
//  ferriestimetable2
//
//  Created by b123400 on 2/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

public enum FerryType : String{
    case Slow = "slow"
    case Fast = "fast"
    case Optional = "optional"
}

public enum Direction : String {
    case ToIsland = "ToIsland"
    case FromIsland = "FromIsland"
    case Unknown = "Unknown"
}

public class Ferry: NSObject {
    let dict : NSDictionary
    public let island : Island
    public var date: NSDate = NSDate()
    
    public init(dictionary:NSDictionary, island _island : Island, direction _direction: Direction, date _date:NSDate) {
        dict = dictionary
        island = _island
        direction = _direction
        date = _date
        super.init()
    }
    
    public class func fromDict(dictionaryRepresentation dict:[String: AnyObject]) -> Ferry {
        let thisDict = dict["dict"] as! NSDictionary
        let thisIsland = Island.fromDict(dictionaryRepresentation:dict["island"] as! Dictionary)
        let thisDirection = Direction(rawValue:dict["direction"] as! String)!
        let thisDate = dict["date"] as! NSDate
        return Ferry(dictionary: thisDict, island: thisIsland, direction: thisDirection, date: thisDate)
    }
    
    public var dictionaryRepresentation : NSDictionary {
    get {
        return [
            "date" : date,
            "island": island.dictionaryRepresentation,
            "direction": direction.rawValue,
            "dict":dict
        ]
    }
    }
    
    public var time : String {
        get {
            return dict.objectForKey("time") as! String
        }
    }
    
    public var type : FerryType {
        get {
            let kind = dict.objectForKey("kind") as! String
            let type = FerryType(rawValue: kind)
            return type!
        }
    }
    
    public var direction : Direction = .Unknown;
    
    public func convertTime(time:String, fromDate date:NSDate) -> NSDate {
        
        let thisTime = NSString(string:time)
        let startHour = Int(thisTime.substringToIndex(2))
        let startMinutes = Int(thisTime.substringFromIndex(2))
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: date)
        
        let thisComponents = NSDateComponents()
        thisComponents.year = components.year
        thisComponents.month = components.month
        thisComponents.day = components.day
        thisComponents.hour = startHour!
        thisComponents.minute = startMinutes!
        
        return NSCalendar.currentCalendar().dateFromComponents(thisComponents)!
    }
    
    public var leavingTime : NSDate {
    get{
        return convertTime(time, fromDate: date)
    }
    }
    
    public var arrvingTime : NSDate {
    get{
        let arrvingTime = NSDate(timeInterval: duration!, sinceDate: leavingTime)
        return arrvingTime
    }
    }
    
    public var duration : NSTimeInterval? {
    get {
        return island.getDurationMinutesForType(self.type)
    }
    }
    
    public var price :String {
    get{
        return island.getPriceForType(type, date: date)
    }
    }
}
