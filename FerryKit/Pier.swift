//
//  Pier.swift
//  ferriestimetable2
//
//  Created by b123400 on 27/11/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import Foundation
import CoreLocation

public enum Pier : String{
    case Central = "Central"
    case NorthPoint = "NorthPoint"
    
    public func location () -> CLLocation {
        switch self {
        case .Central:
            return CLLocation(latitude: 22.287319438993627, longitude: 114.1593325138092)
        case .NorthPoint:
            return CLLocation(latitude: 22.294134380887005, longitude: 114.20089066028595)
        }
    }
    
    public func islands () -> [Island] {
        let plistPath = NSBundle.mainBundle().pathForResource(self.rawValue, ofType: "plist");
        if let path = plistPath {
            let sourceDicts = NSArray(contentsOfFile: path)
            if let dicts = sourceDicts as? [NSDictionary] {
                return dicts.map {
                    (dict:NSDictionary) -> Island in
                    Island(dictionary: dict, pier: self)
                }
            }
        }
        return []
    }
}