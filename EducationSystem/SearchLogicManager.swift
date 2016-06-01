//
//  SearchLogicManager.swift
//  EducationSystem
//
//  Created by Serx on 16/5/30.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit

class SearchLogicManager: NSObject {
    
    let classViewModel: SearchViewModel
    
    override init() {
        self.classViewModel = SearchViewModel()
        super.init()
    }
}
