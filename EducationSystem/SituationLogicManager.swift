//
//  SituationLogicManager.swift
//  EducationSystem
//
//  Created by Serx on 16/5/26.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit

class SituationLogicManager: NSObject {
    
    private let classViewModel: SituationViewModel
    
    override init() {
        self.classViewModel = SituationViewModel()
        super.init()
    }
    
}
