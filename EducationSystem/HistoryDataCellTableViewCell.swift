//
//  historyDataCellTableViewCell.swift
//  EducationSystem
//
//  Created by Serx on 16/6/6.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit

class HistoryDataCellTableViewCell: UITableViewCell {
    
    var title: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let label = UILabel(frame: self.contentView.bounds)
        label.text = title
        label.textAlignment = .Center
        label.tag = 100
        self.contentView.addSubview(label)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
