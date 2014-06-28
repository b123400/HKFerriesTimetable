//
//  MasterViewController.swift
//  ferrytimetable2
//
//  Created by b123400 on 27/6/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, PierSelectTableViewControllerDelegate, UIPopoverPresentationControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var currentPier : Pier = Pier.Central
    var islands = NSMutableArray()
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.changePier(.Central)
        // Do any additional setup after loading the view, typically from a nib.
        
        let selectPierButton = UIBarButtonItem(title: "Select Pier", style: .Bordered, target: self, action: "selectPier:")
        self.navigationItem.rightBarButtonItem = selectPierButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetail" {
//            let indexPath = self.tableView.indexPathForSelectedRow()
//            let object = objects[indexPath.row] as NSDate
//            ((segue.destinationViewController as UINavigationController).topViewController as DetailViewController).detailItem = object
//        }
    }

    // #pragma mark - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return islands.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = islands[indexPath.row].objectForKey("name") as NSString
        cell.textLabel.text = object.description
        return cell
    }

    // #pragma mark - Data Source
    
    func selectPier (sender:UIBarButtonItem){
        let selectViewController = PierSelectTableViewController(selectedPier: currentPier)
        selectViewController.delegate = self
        selectViewController.modalPresentationStyle = .Popover
        let popPC = selectViewController.popoverPresentationController
        popPC.barButtonItem = sender
        popPC.permittedArrowDirections = .Any
        popPC.delegate = self
        presentModalViewController(selectViewController, animated: true)
    }
    func changePier (pier:Pier){
        currentPier = pier
        var path = NSBundle.mainBundle().pathForResource(pier.toRaw(), ofType: "plist");
        islands = NSMutableArray(contentsOfFile: path);
        tableView.reloadData()
    }
    
    func pierSelectTableViewController(vc:PierSelectTableViewController,didSelected pier:Pier){
        changePier(pier)
        dismissModalViewControllerAnimated(true)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle{
        return .FullScreen
    }
    
    func presentationController(controller: UIPresentationController!,
        viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController!{
        
            let navController = UINavigationController(rootViewController: controller.presentedViewController)
            return navController
    }
}

