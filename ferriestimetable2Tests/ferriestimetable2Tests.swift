//
//  ferriestimetable2Tests.swift
//  ferriestimetable2Tests
//
//  Created by b123400 on 20/11/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit
import XCTest

enum Pier : String{
    case Central = "Central"
    case NorthPoint = "NorthPoint"
}

class ferriestimetable2Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAllPiersData() {
        let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let components = NSDateComponents()
        components.year = 2014
        components.month = 11
        components.day = 20
        components.hour = 1
        // Normal day
        
        let piers = [Pier.NorthPoint,Pier.Central]
        for pier in piers {
            var pierPath = NSBundle.mainBundle().pathForResource(pier.rawValue, ofType: "plist");
            if pierPath == nil {
                return
            }
            let islands = NSMutableArray(contentsOfFile: pierPath!)!
            
            for islandDict in islands {
                let island = Island(dictionary: islandDict as NSDictionary, pier:pier)
                NSLog("===== Checking Island: %@ =====", island.name)
                NSLog("Direction: ToIsland")
                NSLog("Day: Normal")
                var date = calendar.dateFromComponents(components)!
                var ferries = island.getFerriesForDate(date, direction: .ToIsland)
                for ferry in ferries {
                    NSLog("time: %@ type: %@", ferry.leavingTime, ferry.type.rawValue)
                }
                
                NSLog("Direction: FromIsland")
                NSLog("Day: Normal")
                ferries = island.getFerriesForDate(date, direction: .FromIsland)
                for ferry in ferries {
                    NSLog("time: %@ type: %@", ferry.leavingTime, ferry.type.rawValue)
                }
                
                components.day = 23  // Sunday
                NSLog("Direction: ToIsland")
                NSLog("Day: Holiday")
                date = calendar.dateFromComponents(components)!
                ferries = island.getFerriesForDate(date, direction: .ToIsland)
                for ferry in ferries {
                    NSLog("time: %@ type: %@", ferry.leavingTime, ferry.type.rawValue)
                }
                
                NSLog("Direction: FromIsland")
                NSLog("Day: Holiday")
                ferries = island.getFerriesForDate(date, direction: .FromIsland)
                for ferry in ferries {
                    NSLog("time: %@ type: %@", ferry.leavingTime, ferry.type.rawValue)
                }
                
                components.day = 22  // Saturday
                NSLog("Direction: ToIsland")
                NSLog("Day: Saturday")
                date = calendar.dateFromComponents(components)!
                ferries = island.getFerriesForDate(date, direction: .ToIsland)
                for ferry in ferries {
                    NSLog("time: %@ type: %@", ferry.leavingTime, ferry.type.rawValue)
                }
                
                NSLog("Direction: FromIsland")
                NSLog("Day: Saturday")
                date = calendar.dateFromComponents(components)!
                ferries = island.getFerriesForDate(date, direction: .FromIsland)
                for ferry in ferries {
                    NSLog("time: %@ type: %@", ferry.leavingTime, ferry.type.rawValue)
                }
            }
        }
    }
}
