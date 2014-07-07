//
//  CustomCalendarViewController.swift
//  ferriestimetable2
//
//  Created by b123400 on 7/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import Foundation

class CustomCalendarViewController: PDTSimpleCalendarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelButtonTapped:")
    }
    
    func cancelButtonTapped(sender:UIBarButtonItem) {
        self.dismissModalViewControllerAnimated(true)
    }
}
