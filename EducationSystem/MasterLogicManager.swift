//
//  MasterLogicManager.swift
//  EducationSystem
//
//  Created by Serx on 16/5/25.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit

class MasterLogicManager: NSObject {
    
    private let classViewModel: MasterViewModel
    
    override init() {
        self.classViewModel = MasterViewModel()
        super.init()
    }
    
}
