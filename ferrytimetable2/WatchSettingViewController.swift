//
//  WatchSettingViewController.swift
//  ferriestimetable2
//
//  Created by b123400 on 23/2/15.
//  Copyright (c) 2015 b123400. All rights reserved.
//

import UIKit
import FerryKit

class WatchSettingViewController: UITableViewController {
    var selectedIsland : String?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "Apple Watch"
        selectedIsland = sharedDefaults.stringForKey(SettingWatchIslandNameKey)
    }
    
    lazy var wormhole : MMWormhole = {
        MMWormhole(applicationGroupIdentifier: "group.net.b123400.ferriestimetable", optionalDirectory: "wormhole")
    }()
    
    lazy var islands : [Island] = {
        Pier.Central.islands() + Pier.NorthPoint.islands()
    }()
    
    lazy var sharedDefaults = {
        NSUserDefaults(suiteName: "group.net.b123400.ferriestimetable")!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return islands.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("switchCell", forIndexPath: indexPath) as UITableViewCell
            let switchControl = cell.accessoryView as UISwitch
            switchControl.on = sharedDefaults.boolForKey(SettingWatchGlanceDetectLocationKey)
            switchControl.removeTarget(self, action: "switchValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            switchControl.addTarget(self, action: "switchValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("islandCell", forIndexPath: indexPath) as UITableViewCell
            let thisIsland = islands[indexPath.row]
            cell.textLabel?.text = NSLocalizedString(thisIsland.name, comment:"")
            if let selectedIslandName = selectedIsland {
                cell.accessoryType = (selectedIslandName == thisIsland.name ? .Checkmark : .None)
            } else {
                cell.accessoryType = (indexPath.row == 0 ? .Checkmark : .None)
            }
            return cell
            
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            setGlanceIsland(islands[indexPath.row])
            tableView.reloadData()
        }
    }
    
    func switchValueChanged (sender:UISwitch) {
        setGlanceUseLocation(sender.on)
    }
    
    func setGlanceUseLocation (useLocation:Bool) {
        sharedDefaults.setObject(useLocation, forKey: SettingWatchGlanceDetectLocationKey)
        sharedDefaults.synchronize()
        wormhole.passMessageObject([], identifier: "locationSettingChanged")
    }
    
    func setGlanceIsland (island:Island) {
        selectedIsland = island.name
        sharedDefaults.setObject(island.name, forKey: SettingWatchIslandNameKey)
        sharedDefaults.synchronize()
        wormhole.passMessageObject([], identifier: "islandSettingChanged")
    }
}
