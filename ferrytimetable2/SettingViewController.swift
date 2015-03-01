//
//  SettingViewController.swift
//  ferriestimetable2
//
//  Created by b123400 on 24/2/15.
//  Copyright (c) 2015 b123400. All rights reserved.
//

import UIKit

class SettingViewController: IASKAppSettingsViewController, IASKSettingsDelegate {
    
    override init() {
        super.init()
        self.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.delegate = self
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        self.delegate = self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func settingsViewController(sender: IASKAppSettingsViewController!, buttonTappedForSpecifier specifier: IASKSpecifier!) {
        if specifier.key() == "about" {
            UIApplication.sharedApplication().openURL(NSURL(string: "http://b123400.net")!)
        }
    }
    
    func settingsViewControllerDidEnd(sender: IASKAppSettingsViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}