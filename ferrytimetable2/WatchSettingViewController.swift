//
//  WatchSettingViewController.swift
//  ferriestimetable2
//
//  Created by b123400 on 23/2/15.
//  Copyright (c) 2015 b123400. All rights reserved.
//

import UIKit

class WatchSettingViewController: UIViewController {
    let wormhole : MMWormhole
    
    required init(coder aDecoder: NSCoder) {
        wormhole = MMWormhole(applicationGroupIdentifier: "group.net.b123400.ferriestimetable", optionalDirectory: "wormhole")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func locationButtonPressed(sender: UIButton) {
        wormhole.passMessageObject(["test":"wow"], identifier: "hello")
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
