//
//  FerryTimeTableViewCell.swift
//  ferriestimetable2
//
//  Created by b123400 on 3/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit

class FerryTimeTableViewCell: UITableViewCell {

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var typeColorView: UIView!
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
