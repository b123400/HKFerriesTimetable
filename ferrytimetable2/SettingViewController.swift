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
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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