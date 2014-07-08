//
//  Island.swift
//  ferriestimetable2
//
//  Created by b123400 on 30/6/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

class Island: NSObject {
    let sourceDict:NSDictionary;
    var _detailDict:NSDictionary?;
    
    init(dictionary dict:NSDictionary){
        sourceDict = dict
        super.init()
    }
    
    var detailDict:NSDictionary {
        get {
            if !_detailDict {
                _detailDict = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("\(name)Info", ofType: "plist"))
            }
            return _detailDict!
        }
    }
    
    var name : String {
        get {
            return sourceDict.objectForKey("name") as String
        }
    }
    
    func getFerriesForDate(date:NSDate, direction:Direction) -> [Ferry] {
        var directionString:String;
        if direction == Direction.ToIsland {
            directionString = "To"
        } else {
            directionString = "From"
        }
        let dateString:String = date.isHoliday() ? "Holiday" : "Normal"
        NSLog( dateString )
        let timeString = detailDict.objectForKey("\(directionString)IslandPlist\(dateString)")as String
        let arr = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource(timeString, ofType: "plist")) as Array<NSDictionary>
        let ferries = arr.map({
            (var thisTime) -> Ferry in
            return Ferry(dictionary: thisTime as Dictionary)
        })
        return ferries
    }
}
