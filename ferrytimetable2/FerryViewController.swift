//
//  FerryViewController.swift
//  ferriestimetable2
//
//  Created by b123400 on 7/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

class FerryViewController: UIViewController {
    var ferry : Ferry? {
        didSet {
            configureView()
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
        // Do any additional setup after loading the view.
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
            timeLabel.text = ferry?.time
        }
    }
}
