//
//  GlanceController.swift
//  ferriestimetable2
//
//  Created by b123400 on 27/11/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import WatchKit
import FerryKit

class GlanceController: WKInterfaceController {
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    
    override init(context: AnyObject?) {
        super.init(context: context)
        
    }
    
    override func willActivate() {
        super.willActivate()
        let path = NSBundle.mainBundle().pathForResource("Central", ofType: "plist")
        let islands = NSArray(contentsOfFile: path!)
        let pierDict = islands!.objectAtIndex(0) as NSDictionary
        let island = Island(dictionary: pierDict, pier: .Central)
        let nearestFerry = island.getNextFerryForDate(NSDate(), direction: .ToIsland)
        if nearestFerry == nil {
            timeLabel.setText("No ferry for today :(")
        } else {
            let timeText = NSDateFormatter.localizedStringFromDate(nearestFerry!.leavingTime, dateStyle: .NoStyle, timeStyle: .MediumStyle)
            timeLabel.setText(NSString(format: "Next ferry: %@", timeText))
        }
    }
}
