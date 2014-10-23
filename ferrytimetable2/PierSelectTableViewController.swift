//
//  PierSelectTableViewController.swift
//  ferrytimetable2
//
//  Created by b123400 on 29/6/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

enum Pier : String{
    case Central = "Central"
    case NorthPoint = "NorthPoint"
}

protocol PierSelectTableViewControllerDelegate {
    func pierSelectTableViewController(vc:PierSelectTableViewController,didSelected pier:Pier)
}

class PierSelectTableViewController: UITableViewController {
    let piers : NSArray = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("Piers", ofType: "plist")!)!
    var selectedPier : Pier? = nil
    var delegate : PierSelectTableViewControllerDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init?(selectedPier:Pier){
        super.init(style: UITableViewStyle.Plain)
        self.selectedPier = selectedPier
    }
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }

    override func viewDidLoad() {        
        super.viewDidLoad()
        
        self.navigationItem.title = "Select Pier"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "done:")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let pierCount = CGFloat(piers.count)
//        self.popoverPresentationController.popoverContentSize = CGSizeMake(320, 44.0 * pierCount)
    }

    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return piers.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        
        let thisPier = piers[indexPath.row] as NSDictionary
        let name = thisPier.objectForKey("name") as NSString
        cell.textLabel.text = name
        
        if name == self.selectedPier!.rawValue {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let thisPier = piers[indexPath.row] as NSDictionary
        let name = thisPier.objectForKey("name") as NSString
        let selectedPier = Pier(rawValue:name)
        delegate?.pierSelectTableViewController(self, didSelected:selectedPier!)
    }
    
    func done(sender:UIBarButtonItem){
        dismissViewControllerAnimated(true, completion: nil)
    }
}
