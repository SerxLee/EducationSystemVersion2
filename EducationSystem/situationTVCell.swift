//
//  situationTVCell.swift
//  EducationSystem
//
//  Created by Serx on 16/6/3.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit

class situationTVCell: UITableViewCell {

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var labelDistance: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clearColor()
        self.labelDistance.constant = MasterViewController.getUIScreenSize(false) / 10
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
