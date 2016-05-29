//
//  CommentLogicManager.swift
//  EducationSystem
//
//  Created by Serx on 16/5/26.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import UIKit

class CommentLogicManager: NSObject {
    
    private let classViewModel: CommentViewModel
    
    override init() {
        self.classViewModel = CommentViewModel()
        super.init()
    }
    
}
