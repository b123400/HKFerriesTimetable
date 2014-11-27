//
//  MasterViewController.swift
//  ferrytimetable2
//
//  Created by b123400 on 27/6/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit
import CoreLocation
import FerryKit

class MasterViewController: UITableViewController, UITableViewDelegate, UIPopoverPresentationControllerDelegate, UISplitViewControllerDelegate, CLLocationManagerDelegate {

    var detailViewController: DetailViewController? = nil
    var currentPier : Pier = Pier.Central
    var islands = NSMutableArray()
    var locationManager: CLLocationManager? = nil
    
    class func nothing(){}
    
    required init(coder aDecoder: NSCoder) {
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
        
//        let selectPierButton = UIBarButtonItem(title: "Select Pier", style: .Bordered, target: self, action: "selectPier:")
//        self.navigationItem.rightBarButtonItem = selectPierButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - Segues
// Don't use segue because Replace/Push to detail crash splitViewController!
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetail" {
//            
//        }
//    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return islands.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = islands[indexPath.row].objectForKey("name") as NSString
        cell.textLabel!.text = NSLocalizedString(object,comment:"")
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = self.tableView.indexPathForSelectedRow()
        if indexPath == nil {
            return
        }
        let islandDict = islands[indexPath!.row] as NSDictionary
        let island = Island(dictionary: islandDict, pier:currentPier)

        let detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
        
        detailViewController.island = island
        
        let splitViewController = UIApplication.sharedApplication().delegate!.window!!.rootViewController as UISplitViewController
        if splitViewController.viewControllers.count == 1 {
            // small screen
            showDetailViewController(detailViewController, sender: self)
        } else {
            // large screen
            let navigationController = UINavigationController(rootViewController: detailViewController)
            showDetailViewController(navigationController, sender: self)
        }
    }

    // MARK: - Data Source
    
    func changePier (pier:Pier){
        currentPier = pier
        var path = NSBundle.mainBundle().pathForResource(pier.rawValue, ofType: "plist");
        if path == nil {
            return
        }
        islands = NSMutableArray(contentsOfFile: path!)!
        tableView.reloadData()
    }
    @IBAction func changePier(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            changePier(.Central)
        case 1:
            changePier(.NorthPoint)
        default:
            break
        }
    }
    
    @IBAction func locationButtonTapped(sender: AnyObject) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyKilometer
            
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case CLAuthorizationStatus.NotDetermined :
                locationManager!.requestWhenInUseAuthorization()
            case CLAuthorizationStatus.Authorized, CLAuthorizationStatus.AuthorizedWhenInUse:
                locationManager!.startUpdatingLocation()
            default:
                break
            }
        }
    }
        
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus){
            switch status {
            case CLAuthorizationStatus.Authorized, CLAuthorizationStatus.AuthorizedWhenInUse:
                manager.startUpdatingLocation()
            default :
                break
            }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        manager.stopUpdatingLocation()
        
        let location = (locations as NSArray).lastObject as CLLocation
        var closestIndex = -1 as Int
        var closestDistance = -1 as Double
        for var i = 0; i < islands.count; i++ {
            let islandDict = islands[i] as NSDictionary
            let latString = islandDict.objectForKey("location-lat") as NSString
            let longString = islandDict.objectForKey("location-long") as NSString
            let thisLocation = CLLocation(latitude: latString.doubleValue, longitude: longString.doubleValue)
            let distance = location.distanceFromLocation(thisLocation) as Double
            
            let isInitial = closestDistance == -1
            let isClosest = Double(closestDistance) > Double(distance)
            if isInitial || isClosest {
                closestDistance = distance
                closestIndex = i
            }
        }
        if closestIndex != -1 {
            let targetIndexPath = NSIndexPath(forRow: closestIndex, inSection: 0)
            tableView.selectRowAtIndexPath(targetIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            tableView(tableView, didSelectRowAtIndexPath: targetIndexPath)
        }
    }
        
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog(error.description)
    }
   
    @IBAction func aboutButtonPressed(sender: UIBarButtonItem) {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("AboutViewController") as AboutViewController
        viewController.modalPresentationStyle = .Popover
        if let popVC = viewController.popoverPresentationController {
            popVC.delegate = self
            popVC.barButtonItem = sender
        }
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle{
        return .FullScreen
    }
    
    func presentationController(controller: UIPresentationController!,
        viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController!{
        
        let navController = UINavigationController(rootViewController: controller.presentedViewController)
        return navController
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Split view
    
    func splitViewController(splitController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return true
    }
    
    func targetDisplayModeForActionInSplitViewController(svc: UISplitViewController!) -> UISplitViewControllerDisplayMode{
        return .AllVisible
    }
    
    func splitViewControllerSupportedInterfaceOrientations(splitViewController: UISplitViewController!) -> Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    }
    
    func splitViewControllerPreferredInterfaceOrientationForPresentation(splitViewController: UISplitViewController!) -> UIInterfaceOrientation{
        return UIInterfaceOrientation.LandscapeLeft
    }
}

