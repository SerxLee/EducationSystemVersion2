//
//  CourseDetailViewController.swift
//  EducationSystem
//
//  Created by Serx on 16/5/27.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController {

    lazy var logicManager: CourseDetailLogicManager = {return CourseDetailLogicManager()}()
    
    var classViewModel: CourseDetailViewModel!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    func initView() {
        self.classViewModel = self.logicManager.classViewModel
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
