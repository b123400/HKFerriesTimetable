//
//  Date+Holiday.swift
//  ferriestimetable2
//
//  Created by b123400 on 4/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import Foundation

internal extension NSDate {
    func isHoliday()-> Bool {
        let calendar = NSCalendar.currentCalendar()
        let flags: NSCalendarUnit = [.Weekday, .Year, .Month, .Day]
        let components = calendar.components(flags, fromDate: self)
        
        if components.weekday == 1 {
            return true
        }
        
        let holidays = [
            "2015/12/26",
            "2016/1/1",
            "2016/2/8",
            "2016/2/9",
            "2016/2/10",
            "2016/3/25",
            "2016/3/26",
            "2016/3/28",
            "2016/4/4",
            "2016/5/2",
            "2016/5/14",
            "2016/6/9",
            "2016/7/1",
            "2016/9/16",
            "2016/10/1",
            "2016/10/10",
            "2016/12/26",
            "2016/12/27"
        ]
        
        let dateString = "\(components.year)/\(components.month)/\(components.day)"
        return holidays.contains(dateString)
    }
}