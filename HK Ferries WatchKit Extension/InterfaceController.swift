//
//  InterfaceController.swift
//  HK Ferries WatchKit Extension
//
//  Created by b123400 on 27/11/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import WatchKit
import Foundation
import FerryKit

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var pierTable: WKInterfaceTable!

    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
        NSLog("%@ init", self)
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        NSLog(context?.description ?? "")
    }
    
    lazy var islands = {
        Pier.Central.islands() + Pier.NorthPoint.islands()
    }()
    
//    override func handleActionWithIdentifier(identifier: String?,
//        forLocalNotification notification: UILocalNotification) {
//            if let thisIdentifier = identifier {
//                if countElements(thisIdentifier) > 0 {
//                    let dict = notification.userInfo as [String:AnyObject]
//                    let ferry = Ferry.fromDict(dictionaryRepresentation: dict)
//                    pushControllerWithName("TimeTable", context: ["island":ferry.island])
//                }
//            }
//    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        
        pierTable.setNumberOfRows(islands.count, withRowType: "row")
        
        for (i, island) in islands.enumerate() {
            let controller = pierTable.rowControllerAtIndex(i) as! RowController
            controller.textLabel.setText(island.name)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        if table == pierTable {
            pushControllerWithName("TimeTable", context: ["island":islands[rowIndex]])
        }
    }
}
