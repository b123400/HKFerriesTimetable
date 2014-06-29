//
//  Island.swift
//  ferriestimetable2
//
//  Created by b123400 on 30/6/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

class Island: NSObject {
    var sourceDict = NSDictionary();
    init(dictionary dict:NSDictionary){
        super.init()
        self.sourceDict = dict
    }
    
    var name : String {
        get {
            return sourceDict.objectForKey("name") as String
        }
    }
}
