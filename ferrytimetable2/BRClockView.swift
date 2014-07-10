//
//  BRClockView.swift
//  ferriestimetable2
//
//  Created by b123400 on 10/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

class BRClockView: UIView {
    var fromDate:NSDate?
    var toDate:NSDate?
    let arc:UIBezierPath = UIBezierPath()
    
    init(frame: CGRect) {
        super.init(frame: frame)
    }
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        
    }
    
    func setTimeRange(fromDate _from:NSDate, toDate _to:NSDate, animated:Bool) {
        fromDate = _from
        toDate = _to
        self.setNeedsDisplay()
    }
    
    func setupPath(){
        
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect){
        
        if fromDate && toDate {
            let outerRadius = min(self.bounds.size.width, self.bounds.size.height)/2.0
            let innerRadius = outerRadius-10
            
            let calendar = NSCalendar.currentCalendar()
            let fromComponents = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: fromDate!)
            let toComponents = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: toDate!)
            
            var startTime = Double(fromComponents.minute)/60.0 * Double(M_PI)*2.0 - M_PI_2
            var endTime = Double(toComponents.minute)/60.0 * Double(M_PI)*2.0 - M_PI_2
            
            //draw arc
            let center = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);
            let arc = UIBezierPath()
            
            let innerFrom = CGPointMake(
                center.x + innerRadius * cos(Float(startTime)),
                center.y + innerRadius * sin(Float(startTime))
            )
            let outerFrom = CGPointMake(
                center.x + outerRadius * cos(Float(startTime)),
                center.y + outerRadius * sin(Float(startTime))
            )
            arc.moveToPoint(innerFrom)
            arc.addLineToPoint(outerFrom)
            
            arc.addArcWithCenter(center, radius: outerRadius, startAngle: Float(startTime), endAngle: CGFloat(endTime), clockwise: true)
            
            let innerTo = CGPointMake(
                center.x + innerRadius * cos(Float(endTime)),
                center.y + innerRadius * sin(Float(endTime))
            )
            
            arc.addLineToPoint(innerTo)
            arc.addArcWithCenter(center, radius: innerRadius, startAngle: Float(endTime), endAngle: Float(startTime), clockwise: false)
            
            UIColor(red: 95.0/255.0, green: 198.0/255.0, blue: 135.0/255.0, alpha: 1.0).set()
            arc.fill()
        }
    }
}
