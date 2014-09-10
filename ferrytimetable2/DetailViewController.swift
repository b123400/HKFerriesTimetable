//
//  DetailViewController.swift
//  ferrytimetable2
//
//  Created by b123400 on 27/6/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

extension NSTimeInterval {
    var toReadableString : String{
        if self < 0 {
            return ""
        }
        let minutes=Int(self/60)
        var returnString = ""
        if minutes < 60 {
            if minutes == 0 {
                return NSLocalizedString("Now",comment:"")
            } else if minutes == 1 {
                returnString = NSLocalizedString("1 minute",comment:"")
            } else {
                returnString = NSString(format: "%d %@", minutes, NSLocalizedString("minutes", comment:""))
            }
        }else if minutes < 3*60 {
            let hour = Int(minutes/60)
            let minutesLeft = minutes%60
            if minutesLeft == 0 {
                if hour == 1 {
                    returnString = NSLocalizedString("1 hour",comment:"")
                } else {
                    returnString = NSString(format: "%d %@", hour, NSLocalizedString("hours",comment:""))
                }
            } else {
                returnString = NSString(format: NSLocalizedString("%d hours and %@",comment:""), hour, NSTimeInterval(minutesLeft*60).toReadableString)
            }
        }
        return returnString
    }
}

class DetailViewController: UIViewController, UITableViewDataSource, UIPopoverPresentationControllerDelegate, PDTSimpleCalendarViewDelegate {

    @IBOutlet var tableView: UITableView!
    var currentTimetable : [Ferry] = []
    var currentDate:NSDate = NSDate()
    var currentDirection = Direction.ToIsland
    
    var island: Island? {
        didSet {
            reloadTimetable()
        }
    }
    
    func reloadTimetable() {
        currentTimetable = island!.getFerriesForDate(currentDate, direction: currentDirection)
        // Update the view.
        self.configureView()
    }

    func configureView() {
        // Update the user interface for the detail item.
        tableView?.reloadData()
        
        if let _island = self.island as Island! {
            if currentDirection == Direction.ToIsland {
                self.title = NSString(format:NSLocalizedString("To %@",comment:""), NSLocalizedString(_island.name,comment:""))
            } else {
                self.title = NSString(format:NSLocalizedString("From %@",comment:""), NSLocalizedString(_island.name,comment:""))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        tableView!.rowHeight = UITableViewAutomaticDimension;
        tableView!.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController!.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController!.setToolbarHidden(true, animated: false)
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return currentTimetable.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as FerryTimeTableViewCell
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.timeLabel.text = NSLocalizedString("Green For Ordinary Ferry",comment:"")
                cell.typeColorView.backgroundColor = UIColor(red: 53/255.0, green: 221/255.0, blue: 112/255.0, alpha: 1.0)
            case 1:
                cell.timeLabel.text = NSLocalizedString("Red For Fast Ferry",comment:"")
                cell.typeColorView.backgroundColor = UIColor(red:255/255.0, green: 1/255.0, blue:128/255.0, alpha: 1.0)
            case 2:
                cell.timeLabel.text = NSLocalizedString("Yellow For Optional Service",comment:"")
                cell.typeColorView.backgroundColor = UIColor(red:244/255.0, green: 209/255.0, blue:70/255.0, alpha: 1.0)
            default:
                break;
            }
            cell.timeLeftLabel.text = ""
            cell.selectionStyle = .None
        } else {
            let ferry = currentTimetable[indexPath.row]
            cell.timeLabel.text = NSDateFormatter.localizedStringFromDate(ferry.leavingTime, dateStyle: .NoStyle, timeStyle: .ShortStyle)
            switch ferry.type {
            case .Slow:
                cell.typeColorView.backgroundColor = UIColor(red: 53/255.0, green: 221/255.0, blue: 112/255.0, alpha: 1.0)
            case .Optional:
                cell.typeColorView.backgroundColor = UIColor(red:244/255.0, green: 209/255.0, blue:70/255.0, alpha: 1.0)
            case .Fast:
                cell.typeColorView.backgroundColor = UIColor(red:255/255.0, green: 1/255.0, blue:128/255.0, alpha: 1.0)
            default:
                break;
            }
            cell.selectionStyle = .Gray
            
            let timeLeft = ferry.leavingTime.timeIntervalSinceNow.toReadableString
            if timeLeft != "Now" && timeLeft != "" {
                cell.timeLeftLabel.text = NSString(format: NSLocalizedString("%@ left", comment:""), timeLeft)
            } else {
                cell.timeLeftLabel.text = timeLeft
            }
        }
        return cell
    }
    // MARK: - Interaction
    @IBAction func flipButtonTapped(sender: AnyObject) {
        if currentDirection == Direction.ToIsland {
            currentDirection = .FromIsland
        } else {
            currentDirection = .ToIsland
        }
        UIView.transitionWithView(tableView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
            [weak self] in
            if self != nil {
                self!.reloadTimetable()
            }
        }, completion: nil)
        
    }
    
    // MARK: - Date picker
    @IBAction func dateButtonTapped(sender: UIBarButtonItem) {
        let calendarViewController = CustomCalendarViewController()
        calendarViewController.delegate = self
        calendarViewController.modalPresentationStyle = .Popover
        let popPC = calendarViewController.popoverPresentationController
        if popPC == nil {
            return
        }
        popPC!.barButtonItem = sender
        popPC!.permittedArrowDirections = .Any
        popPC!.delegate = self
        presentViewController(calendarViewController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle{
        return .FullScreen
    }
    
    func presentationController(controller: UIPresentationController!,
        viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController!{
            
            let navController = UINavigationController(rootViewController: controller.presentedViewController)
            controller.presentedViewController.title = NSLocalizedString("Calendar",comment:"")
            return navController
    }
    
    
    func simpleCalendarViewController(controller : PDTSimpleCalendarViewController, didSelectDate date: NSDate){
        controller.dismissViewControllerAnimated(true, completion: nil)
        currentDate = date
        reloadTimetable()
    }
    func simpleCalendarViewController(controller : PDTSimpleCalendarViewController, shouldUseCustomColorsForDate date:NSDate) -> Bool {
        return date.isHoliday()
    }
    
    func simpleCalendarViewController(controller : PDTSimpleCalendarViewController, circleColorForDate date:NSDate) -> UIColor {
        return UIColor.redColor()
    }
    func simpleCalendarViewController(controller : PDTSimpleCalendarViewController, textColorForDate date:NSDate) -> UIColor {
        return UIColor.whiteColor()
    }
    
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFerry" {
            
            let navController = segue.destinationViewController as UINavigationController
            let ferryController = navController.topViewController as FerryViewController
            let ferry = currentTimetable[ tableView!.indexPathForSelectedRow()!.row ]
            ferryController.ferry = ferry
            tableView!.deselectRowAtIndexPath(tableView!.indexPathForSelectedRow()!, animated: true)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "showFerry" && tableView!.indexPathForSelectedRow()!.section == 0 {
            return false
        }
        return super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
    }
}

