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
            
//            if self.masterPopoverController != nil {
//                self.masterPopoverController!.dismissPopoverAnimated(true)
//            }
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
//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        let ferry = currentTimetable[indexPath.row]
        cell.textLabel.text = ferry.time
        return cell
    }
}

