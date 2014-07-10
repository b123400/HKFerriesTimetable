//
//  BRClockView.swift
//  ferriestimetable2
//
//  Created by b123400 on 10/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit
import QuartzCore

class BRClockView: UIView {
    var fromDate:NSDate?
    var toDate:NSDate?
    
    let shapeLayer = BRClockLayer()
    
    init(frame: CGRect) {
        super.init(frame: frame)
        shapeLayer.frame = self.bounds
        self.layer.addSublayer(shapeLayer)
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        shapeLayer.frame = self.bounds
        self.layer.addSublayer(shapeLayer)
    }
    
    func setTimeRange(fromDate _from:NSDate, toDate _to:NSDate, animated:Bool) {
        fromDate = _from
        toDate = _to
        
        shapeLayer.fillColor = UIColor(red: 95.0/255.0, green: 198.0/255.0, blue: 135.0/255.0, alpha: 1.0);
        
        let calendar = NSCalendar.currentCalendar()
        let fromComponents = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: fromDate!)
        let toComponents = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: toDate)
        
        shapeLayer.startAngle = CGFloat( Double(fromComponents.minute)/60.0 * Double(M_PI)*2.0 - M_PI_2 )
        shapeLayer.endAngle = CGFloat( Double(toComponents.minute)/60.0 * Double(M_PI)*2.0  - M_PI_2) // add 360 so it always go clockwise
        if( shapeLayer.endAngle < shapeLayer.startAngle ){
            shapeLayer.endAngle += CGFloat(M_PI * 2)
        }
        
        if animated {
            let animation = CABasicAnimation(keyPath: "endAngle")
            animation.fromValue = shapeLayer.startAngle
            animation.toValue = shapeLayer.endAngle
            animation.duration = 0.7
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            shapeLayer.addAnimation(animation, forKey: "endAngle")
        }
        shapeLayer.setNeedsDisplay()
    }
}
