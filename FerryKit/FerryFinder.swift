//
//  FerryFinder.swift
//  ferriestimetable2
//
//  Created by b123400 on 27/11/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import Foundation
import CoreLocation

public class FerryFinder: NSObject {
    
    public class var shared: FerryFinder {
        struct Static {
            static let instance: FerryFinder = FerryFinder()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
    }
    
    public func islandAtLocation(location: CLLocation) -> Island? {
        for pier in [Pier.Central, Pier.NorthPoint] {
            let islands = pier.islands()
            for island in islands {
                let insideIsland = island.inLocation(location)
                return island
            }
        }
        return nil
    }
    
    public func nearestPier (location: CLLocation) -> Pier? {
        var closestDistance : CLLocationDistance = -1
        var closestPier : Pier? = nil
        for pier in [Pier.Central, Pier.NorthPoint] {
            let distance = location.distanceFromLocation(pier.location())
            if closestPier == nil || (closestDistance >= distance) {
                closestPier = pier
                closestDistance = distance
            }
        }
        return closestPier
    }
}