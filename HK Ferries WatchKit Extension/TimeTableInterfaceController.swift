//
//  TimeTableInterfaceController.swift
//  ferriestimetable2
//
//  Created by b123400 on 24/2/15.
//  Copyright (c) 2015 b123400. All rights reserved.
//

import WatchKit
import FerryKit

class TimeTableInterfaceController: WKInterfaceController {
    @IBOutlet weak var timeTable: WKInterfaceTable!
    var island : Island?
    var direction : Direction = .ToIsland
    
    override init!() {
        super.init()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let thisContext = context as? [String:AnyObject] {
            island = (thisContext["island"] as Island)
        }
    }
    
    override func willActivate() {
        super.willActivate()
        makeTable()
    }
    
    func getFerries () -> [Ferry] {
        return island!.getFerriesForDate(NSDate(), direction: direction)
    }
    
    func makeTable () {
        let ferries = getFerries()
        let count = ferries.count
        timeTable.setRowTypes(["row"] + [Int](0..<count).map({_ in "time"}))
        
        let rowController = timeTable.rowControllerAtIndex(0) as RowController
        rowController.textLabel.setText(
            NSString(format: direction == .ToIsland ?
                NSLocalizedString("To %@", comment:"") :
                NSLocalizedString("From %@", comment:""),
                NSLocalizedString(island!.name, comment:"")))
        
        for i in (1...count) {
            let islandIndex = i - 1
            let ferry = ferries[islandIndex]
            
            let timeRowController = timeTable.rowControllerAtIndex(i) as TimeRowController
            timeRowController.timeLabel.setText(
                NSDateFormatter.localizedStringFromDate(
                    ferry.leavingTime,
                    dateStyle: .NoStyle,
                    timeStyle: .ShortStyle))
            
            timeRowController.typeLabel.setText(
                ferry.type == .Fast ?
                    NSLocalizedString("Fast", comment:""):
                    NSLocalizedString("Slow", comment:""))
            
            if ferry.type == .Fast {
                timeRowController.typeGroup.setBackgroundColor(
                    UIColor(red: 1, green: 0.255, blue: 0.533, alpha: 1))
            }
        }
    }
}
