//
//  DetailViewController.swift
//  ferrytimetable2
//
//  Created by b123400 on 27/6/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView
//    var masterPopoverController: UIPopoverController? = nil

    var island: Island? {
        didSet {
            // Update the view.
            self.configureView()
            
//            if self.masterPopoverController != nil {
//                self.masterPopoverController!.dismissPopoverAnimated(true)
//            }
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
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
}

