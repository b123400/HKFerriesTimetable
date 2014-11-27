//
//  GlanceController.swift
//  ferriestimetable2
//
//  Created by b123400 on 27/11/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import WatchKit

class GlanceController: WKInterfaceController {
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    
    override init(context: AnyObject?) {
        super.init(context: context)
        
    }
    
    override func willActivate() {
        super.willActivate()
        timeLabel.setText("hello")
    }
}
