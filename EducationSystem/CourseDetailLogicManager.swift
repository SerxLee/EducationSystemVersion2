//
//  CourseDetailLogicManager.swift
//  EducationSystem
//
//  Created by Serx on 16/5/27.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit

class CourseDetailLogicManager: NSObject {
    
    let classViewModel: CourseDetailViewModel
    
    override init() {
        self.classViewModel = CourseDetailViewModel()
        super.init()
    }
    
}
