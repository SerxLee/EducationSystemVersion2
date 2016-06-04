//
//  PageTVCell.swift
//  EducationSystem
//
//  Created by Serx on 16/6/2.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit

class PageTVCell: UITableViewCell {

    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseScore: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
