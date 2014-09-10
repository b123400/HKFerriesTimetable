//
//  FerryViewController.swift
//  ferriestimetable2
//
//  Created by b123400 on 7/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FerryViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    @IBOutlet var priceView: UIView?
    @IBOutlet var clockView: BRClockView?
    @IBOutlet var priceLabel: UILabel?
    @IBOutlet var durationLabel: UILabel?
    var shown = false
    var ferry : Ferry? {
        didSet {
            configureView()
            if ferry!.direction == Direction.ToIsland {
                self.title = "\(ferry!.island.pier.toRaw()) → \(ferry!.island.name)"
            } else {
                self.title = "\(ferry!.island.name) → \(ferry!.island.pier.toRaw())"
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        priceView!.layer.borderColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0).CGColor
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        shown = true
        configureView()
        self.preferredContentSize = CGSizeMake(320, 400)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - layout
    @IBOutlet var timeLabel: UILabel?
    func configureView() {
        if timeLabel != nil {
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "HH:mm"
            let leavingString = "\(formatter.stringFromDate(ferry!.leavingTime))"
            let arrivingString = "\(formatter.stringFromDate(ferry!.arrvingTime))"
            timeLabel!.text = "\(leavingString) ~ \(arrivingString)"
        }
        if clockView != nil {
            if ferry != nil {
                if shown {
                    clockView!.setTimeRange(fromDate: ferry!.leavingTime, toDate: ferry!.arrvingTime, animated: false)
                } else {
                    clockView!.setTimeRange(fromDate: ferry!.leavingTime, toDate: ferry!.leavingTime, animated: false)
                }
            }
        }
        if (priceLabel != nil) {
            priceLabel!.text = ferry?.price
        }
        if (durationLabel != nil) {
            let seconds = ferry?.duration
            durationLabel!.text = NSString(format: "%.fmin", seconds!/60)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showMap" {
            let mapController = segue.destinationViewController as MapViewController
            mapController.ferry = ferry
        }
    }
    
    @IBAction func notificationButtonTapped(sender: AnyObject) {
        
        let notificationController = self.storyboard?.instantiateViewControllerWithIdentifier("addNotification") as NewNotificationViewController
        notificationController.ferry = ferry
        
        notificationController.modalPresentationStyle = UIModalPresentationStyle.Popover
        if let popover = notificationController.popoverPresentationController {
            popover.delegate = self
            popover.sourceView = self.view
            popover.sourceRect = sender.frame
        }
        presentViewController(notificationController, animated: true, completion: nil)
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
}
