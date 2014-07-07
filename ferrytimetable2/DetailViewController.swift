//
//  DetailViewController.swift
//  ferrytimetable2
//
//  Created by b123400 on 27/6/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UIPopoverPresentationControllerDelegate, PDTSimpleCalendarViewDelegate {

    @IBOutlet var tableView: UITableView
    var currentTimetable : Ferry[] = []
    var currentDate:NSDate = NSDate()
    var currentDirection = Direction.ToIsland
    
    var island: Island? {
        didSet {
            reloadTimetable()
            if let _island = self.island as? Island {
                self.title = _island.name
            }
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController.setToolbarHidden(true, animated: false)
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTimetable.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as FerryTimeTableViewCell
        
        let ferry = currentTimetable[indexPath.row]
        cell.timeLabel.text = ferry.time
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
        return cell
    }
    // MARK: - Interaction
    @IBAction func flipButtonTapped(sender: AnyObject) {
        if currentDirection == Direction.ToIsland {
            currentDirection = .FromIsland
        } else {
            currentDirection = .ToIsland
        }
//        let context = UIGraphicsGetCurrentContext()
//        UIView.beginAnimations(nil, context: UIGraphicsGetCurrentContext())
//        UIView.setAnimationDuration(0.5)
//        UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: tableView, cache: true)
//        UIView.commitAnimations()
        UIView.transitionWithView(tableView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
            [strong self] in
            self.reloadTimetable()
        }, completion: nil)
        
    }
    
    // MARK: - Date picker
    @IBAction func dateButtonTapped(sender: UIBarButtonItem) {
        let calendarViewController = CustomCalendarViewController()
        calendarViewController.delegate = self
        calendarViewController.modalPresentationStyle = .Popover
        let popPC = calendarViewController.popoverPresentationController
        popPC.barButtonItem = sender
        popPC.permittedArrowDirections = .Any
        popPC.delegate = self
        presentModalViewController(calendarViewController, animated: true)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle{
        return .FullScreen
    }
    
    func presentationController(controller: UIPresentationController!,
        viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController!{
            
            let navController = UINavigationController(rootViewController: controller.presentedViewController)
            return navController
    }
    
    
    
    func simpleCalendarViewController(controller : PDTSimpleCalendarViewController, didSelectDate date: NSDate){
        controller.dismissModalViewControllerAnimated(true)
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
            let ferry = currentTimetable[ tableView.indexPathForSelectedRow().row ]
            ferryController.ferry = ferry
        }
    }
}

