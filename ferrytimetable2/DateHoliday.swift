//
//  Date+Holiday.swift
//  ferriestimetable2
//
//  Created by b123400 on 4/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import Foundation

extension NSDate {
    func isHoliday()-> Bool {
        let calendar = NSCalendar.currentCalendar()
        let flags: NSCalendarUnit = .WeekdayCalendarUnit | .YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit
        let components = calendar.components(flags, fromDate: self)
        
        if components.weekday == 1 {
            return true
        }
        
        let holidays = ["2010/1/1",
            "2010/2/13",
            "2010/2/15",
            "2010/2/16",
            "2010/4/2",
            "2010/4/3",
            "2010/4/5",
            "2010/4/6",
            "2010/5/1",
            "2010/5/21",
            "2010/6/16",
            "2010/7/1",
            "2010/9/23",
            "2010/10/1",
            "2010/10/16",
            "2010/12/25",
            "2010/12/27",
            "2011/1/1",
            "2011/2/3",
            "2011/2/4",
            "2011/2/5",
            "2011/4/22",
            "2011/4/23",
            "2011/4/25",
            "2011/5/2",
            "2011/5/10",
            "2011/6/6",
            "2011/7/1",
            "2011/9/13",
            "2011/10/1",
            "2011/10/5",
            "2011/12/26",
            "2011/12/27",
            "2012/1/2",
            "2012/1/23",
            "2012/1/24",
            "2012/1/25",
            "2012/4/4",
            "2012/4/6",
            "2012/4/7",
            "2012/4/9",
            "2012/4/28",
            "2012/5/1",
            "2012/6/23",
            "2012/7/2",
            "2012/10/1",
            "2012/10/2",
            "2012/10/23",
            "2012/12/25",
            "2012/12/26",
            "2013/1/1",
            "2013/2/11",
            "2013/2/12",
            "2013/2/13",
            "2013/3/29",
            "2013/3/30",
            "2013/4/1",
            "2013/4/4",
            "2013/5/1",
            "2013/5/17",
            "2013/6/12",
            "2013/7/1",
            "2013/9/20",
            "2013/10/1",
            "2013/10/14",
            "2013/12/25",
            "2013/12/26"]
        
        let dateString = "\(components.year)/\(components.month)/\(components.day)"
        return contains(holidays,dateString)
    }
}