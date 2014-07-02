//
//  DetailViewController.swift
//  ferrytimetable2
//
//  Created by b123400 on 27/6/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var tableView: UITableView
//    var masterPopoverController: UIPopoverController? = nil
    var currentTimetable : Ferry[] = []
    
    var island: Island? {
        didSet {
            currentTimetable = island!.getFerriesForDate(NSDate())
            // Update the view.
            self.configureView()
            
        }
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
    
    // #pragma mark - Table View
    
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
}

