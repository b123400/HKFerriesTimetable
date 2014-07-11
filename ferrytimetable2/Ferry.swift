//
//  Ferry.swift
//  ferriestimetable2
//
//  Created by b123400 on 2/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

enum FerryType : String{
    case Slow = "slow"
    case Fast = "fast"
    case Optional = "optional"
}

enum Direction {
    case ToIsland, FromIsland
    case Unknown
}

class Ferry: NSObject {
    let dict : NSDictionary
    let island : Island
    init(dictionary:NSDictionary, island _island : Island, direction _direction: Direction) {
        dict = dictionary
        island = _island
        direction = _direction
        super.init()
    }
    
    var time : String {
        get {
            return dict.objectForKey("time") as String
        }
    }
    
    var type : FerryType {
        get {
            let kind = dict.objectForKey("kind") as String
            let type = FerryType.fromRaw(kind)
            return type!
        }
    }
    
    var direction : Direction = .Unknown;
    
    func convertTime(time:String, fromDate date:NSDate) -> NSDate {
        
        let startHour = time.substringToIndex(2).toInt()
        let startMinutes = time.substringFromIndex(2).toInt()
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay, fromDate: date)
        
        let thisComponents = NSDateComponents()
        thisComponents.year = components.year
        thisComponents.month = components.month
        thisComponents.day = components.day
        thisComponents.hour = startHour!
        thisComponents.minute = startMinutes!
        
        return NSCalendar.currentCalendar().dateFromComponents(thisComponents)
    }
    
    func leavingTime(date:NSDate) -> NSDate {
        return convertTime(time, fromDate: date)
    }
    
    func arrvingTime(date:NSDate) -> NSDate {
        let thisLeavingTime = leavingTime(date)
        let arrvingTime = NSDate(timeInterval: duration!, sinceDate: thisLeavingTime)
        return arrvingTime
    }
    
    var duration : NSTimeInterval? {
    get {
        return island.getDurationMinutesForType(self.type)
    }
    }
    
    func getPriceWithDate(date:NSDate) -> String {
        return island.getPriceForType(type, date: date)
    }
}
