//
//  segView.swift
//  EducationSystem
//
//  Created by Serx on 16/5/30.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit

class segView: UIViewController {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var left: UIBarButtonItem = UIBarButtonItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        let img = UIImage(named: "search")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.left.image = img
        self.left.style = .Plain
        self.navigationItem.rightBarButtonItem? = left
    }

}
