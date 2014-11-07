//
//  ferrytimetable2Tests.swift
//  ferrytimetable2Tests
//
//  Created by b123400 on 27/6/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import XCTest

enum Pier : String{
    case Central = "Central"
    case NorthPoint = "NorthPoint"
}

class ferrytimetable2Tests: XCTestCase {
    
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
    
    func testAllFerriesData() {
        let piers = [Pier.NorthPoint,Pier.Central]
        for pier in piers {
            var pierPath = NSBundle.mainBundle().pathForResource(pier.rawValue, ofType: "plist");
            if pierPath == nil {
                return
            }
            let islands = NSMutableArray(contentsOfFile: pierPath!)!
            
            for islandDict in islands {
                let island = Island(dictionary: islandDict as NSDictionary, pier:pier)
                NSLog("%@", island.name)
//                island.get
            }
        }
    }
}
