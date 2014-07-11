//
//  FerryViewController.swift
//  ferriestimetable2
//
//  Created by b123400 on 7/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

class FerryViewController: UIViewController {
    @IBOutlet var priceView: UIView
    @IBOutlet var clockView: BRClockView
    var shown = false
    var date = NSDate()
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
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        priceView.layer.borderColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0).CGColor
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        shown = true
        configureView()
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
    @IBOutlet var timeLabel: UILabel
    func configureView() {
        if timeLabel != nil {
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"yyyy"];
//            
//            //Optionally for time zone converstions
//            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
//            
//            NSString *stringFromDate = [formatter stringFromDate:myNSDateInstance];
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "HH:mm"
            let leavingString = "\(formatter.stringFromDate(ferry!.leavingTime(date)))"
            let arrivingString = "\(formatter.stringFromDate(ferry!.arrvingTime(date)))"
            timeLabel.text = "\(leavingString) ~ \(arrivingString)"
        }
        if clockView {
            if ferry {
                if shown {
                    clockView.setTimeRange(fromDate: ferry!.leavingTime(date), toDate: ferry!.arrvingTime(date), animated: false)
                } else {
                    clockView.setTimeRange(fromDate: ferry!.leavingTime(date), toDate: ferry!.leavingTime(date), animated: false)
                }
            }
        }
    }
}
