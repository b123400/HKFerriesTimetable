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

class Ferry: NSObject {
    let dict:NSDictionary
    init(dictionary:NSDictionary) {
        dict = dictionary
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
}
